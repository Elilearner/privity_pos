import 'package:flutter/foundation.dart';

import '../data/database/app_database.dart' as db;
import '../data/repositories/sale_repository.dart';
import '../models/invoice_item.dart';
import '../models/payment.dart';
import '../models/payment_method.dart';
import '../models/product.dart';
import '../models/sale.dart';
import '../models/sale_draft.dart';
import '../models/sale_type.dart';
import '../models/table_account.dart';
import 'product_service.dart';
import 'table_service.dart';

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
  // PRODUCTOS EN CUENTAS DE MESA
  // =========================================================

  void addProductToAccount({
    required TableAccount account,
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
    required TableAccount account,
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
    required TableAccount account,
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

  bool removeProduct({required TableAccount account, required int productId}) {
    final index = account.items.indexWhere(
      (item) => item.product.id == productId,
    );

    if (index == -1) {
      return false;
    }

    account.removeItem(index);

    return true;
  }

  void clearAccount(TableAccount account) {
    account.clear();
  }

  double getSubtotal(TableAccount account) {
    return account.subtotal;
  }

  int getTotalItems(TableAccount account) {
    return account.totalItems;
  }

  InvoiceItem? getItem({
    required TableAccount account,
    required int productId,
  }) {
    return _findItem(account: account, productId: productId);
  }

  // =========================================================
  // VENTAS DE MESA
  // =========================================================

  Future<Sale?> closeTableSale({
    required TableAccount account,
    required List<Payment> payments,
  }) async {
    if (account.items.isEmpty) {
      return null;
    }

    if (!_paymentsAreValid(total: account.subtotal, payments: payments)) {
      return null;
    }

    // La cuenta que estamos cobrando ya tiene
    // esos productos reservados para ella.
    // Por eso se excluye del cálculo de reservas.
    if (!ProductService.instance.hasEnoughStock(
      account.items,
      excludeAccountId: account.id,
    )) {
      return null;
    }

    final sale = Sale(
      id: _nextSaleId,
      type: SaleType.table,
      createdAt: DateTime.now(),
      items: List<InvoiceItem>.from(account.items),
      tableNumber: account.tableNumber,
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

    final accountClosed = await TableService.instance.closeAccount(
      tableNumber: account.tableNumber,
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

  Future<Sale?> closeTableSaleWithCash({
    required TableAccount account,
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

    return closeTableSale(account: account, payments: [payment]);
  }

  Future<Sale?> closeTableSaleWithCard({
    required TableAccount account,
    String? reference,
  }) async {
    final payment = Payment(
      method: PaymentMethod.card,
      amount: account.subtotal,
      reference: _cleanReference(reference),
    );

    return closeTableSale(account: account, payments: [payment]);
  }

  Future<Sale?> closeTableSaleWithTransfer({
    required TableAccount account,
    String? reference,
  }) async {
    final payment = Payment(
      method: PaymentMethod.transfer,
      amount: account.subtotal,
      reference: _cleanReference(reference),
    );

    return closeTableSale(account: account, payments: [payment]);
  }

  Future<Sale?> closeTableSaleWithMixedPayments({
    required TableAccount account,
    required List<Payment> payments,
  }) async {
    if (payments.length < 2) {
      return null;
    }

    return closeTableSale(account: account, payments: payments);
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

    // En este caso no se excluye ninguna cuenta,
    // porque venta rápida, para llevar y delivery
    // no pertenecen a una cuenta de mesa.
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
    required TableAccount account,
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
