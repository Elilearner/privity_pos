import 'package:flutter/foundation.dart';

import '../data/database/app_database.dart' as db;
import '../data/repositories/sale_repository.dart';
import '../models/invoice_item.dart';
import '../models/payment.dart';
import '../models/payment_method.dart';
import '../models/product.dart';
import '../models/sale.dart';
import '../models/sale_type.dart';
import '../models/table_account.dart';
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

  Future<Sale?> closeTableSaleWithCash({
    required TableAccount account,
    required double receivedAmount,
  }) async {
    if (account.items.isEmpty) {
      return null;
    }

    final total = account.subtotal;

    if (receivedAmount < total) {
      return null;
    }

    final payment = Payment(
      method: PaymentMethod.cash,
      amount: total,
      receivedAmount: receivedAmount,
    );

    final sale = Sale(
      id: _nextSaleId,
      type: SaleType.table,
      createdAt: DateTime.now(),
      items: List<InvoiceItem>.from(account.items),
      tableNumber: account.tableNumber,
      accountId: account.id,
      customerName: account.customerName,
      payments: [payment],
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

    _nextSaleId++;

    _sales.add(sale);

    notifyListeners();

    return sale;
  }

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
}
