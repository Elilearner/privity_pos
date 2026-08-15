import 'package:flutter/foundation.dart';

import '../data/database/app_database.dart' as db;
import '../data/repositories/sale_repository.dart';
import '../models/invoice_item.dart';
import '../models/open_account.dart';
import '../models/payment.dart';
import '../models/payment_method.dart';
import '../models/product.dart';
import '../models/sale.dart';
import '../models/sale_draft.dart';
import '../models/sale_type.dart';
import 'open_account_service.dart';
import 'product_service.dart';

class SaleService extends ChangeNotifier {
  SaleService._();

  static final SaleService instance = SaleService._();

  final List<Sale> _sales = [];

  late final db.AppDatabase _database;
  late final SaleRepository _repository;

  bool _initialized = false;

  int _nextSaleId = 1;

  List<Sale> get sales {
    return List.unmodifiable(_sales);
  }

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    _database = db.AppDatabase();
    _repository = SaleRepository(_database);

    final storedSales = await _repository.getAllSales();

    _sales
      ..clear()
      ..addAll(storedSales);

    if (_sales.isNotEmpty) {
      final highestId = _sales.fold<int>(0, (currentMax, sale) {
        return sale.id > currentMax ? sale.id : currentMax;
      });

      _nextSaleId = highestId + 1;
    }

    _initialized = true;
  }

  // =========================================================
  // PRODUCTOS EN CUENTAS ABIERTAS
  // =========================================================

  void addProductToAccount({
    required OpenAccount account,
    required Product product,
  }) {
    for (final item in account.items) {
      if (item.product.id == product.id) {
        item.increase();
        return;
      }
    }

    account.addItem(InvoiceItem(product: product));
  }

  bool increaseProductQuantity({
    required OpenAccount account,
    required int productId,
  }) {
    final item = _findItem(account: account, productId: productId);

    if (item == null) {
      return false;
    }

    item.increase();

    return true;
  }

  bool decreaseProductQuantity({
    required OpenAccount account,
    required int productId,
  }) {
    final item = _findItem(account: account, productId: productId);

    if (item == null) {
      return false;
    }

    if (item.quantity <= 1) {
      return false;
    }

    item.decrease();

    return true;
  }

  bool removeProduct({required OpenAccount account, required int productId}) {
    final index = account.items.indexWhere(
      (item) => item.product.id == productId,
    );

    if (index == -1) {
      return false;
    }

    account.removeItem(index);

    return true;
  }

  void clearAccount(OpenAccount account) {
    account.clear();
  }

  double getSubtotal(OpenAccount account) {
    return account.subtotal;
  }

  int getTotalItems(OpenAccount account) {
    return account.totalItems;
  }

  InvoiceItem? getItem({required OpenAccount account, required int productId}) {
    return _findItem(account: account, productId: productId);
  }

  // =========================================================
  // CIERRE DE CUENTAS ABIERTAS
  // MESA / BARRA
  // =========================================================

  Future<Sale?> closeOpenAccountSale({
    required OpenAccount account,
    required List<Payment> payments,
  }) async {
    if (account.isClosed) {
      return null;
    }

    if (account.items.isEmpty) {
      return null;
    }

    final saleType = _saleTypeForOpenAccount(account);

    if (saleType == null) {
      return null;
    }

    int? tableNumber;

    if (account.isTable) {
      tableNumber = account.tableNumber;

      if (tableNumber == null || tableNumber <= 0) {
        return null;
      }
    }

    if (account.isBar && account.tableNumber != null) {
      return null;
    }

    if (!_paymentsAreValid(total: account.subtotal, payments: payments)) {
      return null;
    }

    // La propia cuenta se excluye del cálculo de reservas.
    // Sus productos ya están reservados para este cliente.
    if (!ProductService.instance.hasEnoughStock(
      account.items,
      excludeAccountId: account.id,
    )) {
      return null;
    }

    final sale = Sale(
      id: _nextSaleId,
      type: saleType,
      createdAt: DateTime.now(),
      items: List<InvoiceItem>.from(account.items),
      tableNumber: tableNumber,
      accountId: account.id,
      customerName: account.customerName,
      payments: List<Payment>.from(payments),
      isClosed: true,
    );

    try {
      await _repository.saveSale(sale);
    } catch (_) {
      return null;
    }

    final accountClosed = await OpenAccountService.instance.closeAccount(
      accountId: account.id,
    );

    if (!accountClosed) {
      await _repository.deleteSale(sale.id);

      return null;
    }

    final stockUpdated = await ProductService.instance.decreaseStock(
      sale.items,
    );

    if (!stockUpdated) {
      await _repository.deleteSale(sale.id);

      return null;
    }

    _registerCompletedSale(sale);

    return sale;
  }

  Future<Sale?> closeOpenAccountSaleWithCash({
    required OpenAccount account,
    required double receivedAmount,
  }) async {
    final total = account.subtotal;

    if (receivedAmount < total) {
      return null;
    }

    final payment = Payment(
      method: PaymentMethod.cash,
      amount: total,
      receivedAmount: receivedAmount,
    );

    return closeOpenAccountSale(account: account, payments: [payment]);
  }

  Future<Sale?> closeOpenAccountSaleWithCard({
    required OpenAccount account,
    String? reference,
  }) async {
    final payment = Payment(
      method: PaymentMethod.card,
      amount: account.subtotal,
      reference: _cleanReference(reference),
    );

    return closeOpenAccountSale(account: account, payments: [payment]);
  }

  Future<Sale?> closeOpenAccountSaleWithTransfer({
    required OpenAccount account,
    String? reference,
  }) async {
    final payment = Payment(
      method: PaymentMethod.transfer,
      amount: account.subtotal,
      reference: _cleanReference(reference),
    );

    return closeOpenAccountSale(account: account, payments: [payment]);
  }

  Future<Sale?> closeOpenAccountSaleWithMixedPayments({
    required OpenAccount account,
    required List<Payment> payments,
  }) async {
    if (payments.length < 2) {
      return null;
    }

    return closeOpenAccountSale(account: account, payments: payments);
  }

  // =========================================================
  // VENTA RÁPIDA / PARA LLEVAR / DELIVERY
  // =========================================================

  Future<Sale?> closeDraftSale({
    required SaleDraft draft,
    required List<Payment> payments,
  }) async {
    if (draft.items.isEmpty) {
      return null;
    }

    if (!_isSupportedDraftType(draft.type)) {
      return null;
    }

    if (!_paymentsAreValid(total: draft.total, payments: payments)) {
      return null;
    }

    if (!ProductService.instance.hasEnoughStock(draft.items)) {
      return null;
    }

    final sale = Sale(
      id: _nextSaleId,
      type: draft.type,
      createdAt: DateTime.now(),
      items: List<InvoiceItem>.from(draft.items),
      customerName: _cleanReference(draft.customerName),
      customerPhone: _cleanReference(draft.customerPhone),
      deliveryAddress: _cleanReference(draft.deliveryAddress),
      deliveryReference: _cleanReference(draft.deliveryReference),
      deliveryFee: draft.deliveryFee,
      taxRate: draft.taxRate,
      payments: List<Payment>.from(payments),
      isClosed: true,
    );

    try {
      await _repository.saveSale(sale);
    } catch (_) {
      return null;
    }

    final stockUpdated = await ProductService.instance.decreaseStock(
      sale.items,
    );

    if (!stockUpdated) {
      await _repository.deleteSale(sale.id);

      return null;
    }

    _registerCompletedSale(sale);

    draft.clear();

    return sale;
  }

  Future<Sale?> closeDraftSaleWithCash({
    required SaleDraft draft,
    required double receivedAmount,
  }) async {
    final total = draft.total;

    if (receivedAmount < total) {
      return null;
    }

    final payment = Payment(
      method: PaymentMethod.cash,
      amount: total,
      receivedAmount: receivedAmount,
    );

    return closeDraftSale(draft: draft, payments: [payment]);
  }

  Future<Sale?> closeDraftSaleWithCard({
    required SaleDraft draft,
    String? reference,
  }) async {
    final payment = Payment(
      method: PaymentMethod.card,
      amount: draft.total,
      reference: _cleanReference(reference),
    );

    return closeDraftSale(draft: draft, payments: [payment]);
  }

  Future<Sale?> closeDraftSaleWithTransfer({
    required SaleDraft draft,
    String? reference,
  }) async {
    final payment = Payment(
      method: PaymentMethod.transfer,
      amount: draft.total,
      reference: _cleanReference(reference),
    );

    return closeDraftSale(draft: draft, payments: [payment]);
  }

  Future<Sale?> closeDraftSaleWithMixedPayments({
    required SaleDraft draft,
    required List<Payment> payments,
  }) async {
    if (payments.length < 2) {
      return null;
    }

    return closeDraftSale(draft: draft, payments: payments);
  }

  // =========================================================
  // CONSULTAS
  // =========================================================

  Sale? getSale(int saleId) {
    for (final sale in _sales) {
      if (sale.id == saleId) {
        return sale;
      }
    }

    return null;
  }

  double get totalSalesAmount {
    return _sales.fold<double>(0, (sum, sale) => sum + sale.total);
  }

  int get totalSales {
    return _sales.length;
  }

  // =========================================================
  // MÉTODOS INTERNOS
  // =========================================================

  SaleType? _saleTypeForOpenAccount(OpenAccount account) {
    if (account.isTable) {
      return SaleType.table;
    }

    if (account.isBar) {
      return SaleType.bar;
    }

    return null;
  }

  void _registerCompletedSale(Sale sale) {
    _nextSaleId++;

    _sales.add(sale);

    notifyListeners();
  }

  bool _paymentsAreValid({
    required double total,
    required List<Payment> payments,
  }) {
    if (payments.isEmpty) {
      return false;
    }

    for (final payment in payments) {
      if (payment.amount <= 0) {
        return false;
      }
    }

    final amountPaid = payments.fold<double>(
      0,
      (sum, payment) => sum + payment.amount,
    );

    const tolerance = 0.01;

    return (amountPaid - total).abs() <= tolerance;
  }

  bool _isSupportedDraftType(SaleType type) {
    return type == SaleType.quickSale ||
        type == SaleType.takeaway ||
        type == SaleType.delivery;
  }

  InvoiceItem? _findItem({
    required OpenAccount account,
    required int productId,
  }) {
    for (final item in account.items) {
      if (item.product.id == productId) {
        return item;
      }
    }

    return null;
  }

  String? _cleanReference(String? value) {
    final cleanValue = value?.trim();

    if (cleanValue == null || cleanValue.isEmpty) {
      return null;
    }

    return cleanValue;
  }
}
