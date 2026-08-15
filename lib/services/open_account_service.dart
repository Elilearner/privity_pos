import 'package:flutter/foundation.dart';

import '../data/database/app_database.dart' as db;
import '../data/repositories/open_account_repository.dart';
import '../models/account_location_type.dart';
import '../models/open_account.dart';
import 'business_settings_service.dart';

class OpenAccountService extends ChangeNotifier {
  OpenAccountService._();

  static final OpenAccountService instance = OpenAccountService._();

  final List<OpenAccount> _accounts = [];

  late final db.AppDatabase _database;
  late final OpenAccountRepository _repository;

  bool _initialized = false;

  int _nextAccountId = 1;

  bool get isInitialized => _initialized;

  List<OpenAccount> get accounts {
    return List.unmodifiable(_accounts);
  }

  List<OpenAccount> get allOpenAccounts {
    return List.unmodifiable(_accounts.where((account) => !account.isClosed));
  }

  List<OpenAccount> get barAccounts {
    return List.unmodifiable(
      _accounts.where(
        (account) =>
            !account.isClosed &&
            account.locationType == AccountLocationType.bar,
      ),
    );
  }

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    _database = db.AppDatabase();

    _repository = OpenAccountRepository(_database);

    final storedAccounts = await _repository.getOpenAccounts();

    _accounts
      ..clear()
      ..addAll(storedAccounts);

    if (_accounts.isNotEmpty) {
      var highestId = 0;

      for (final account in _accounts) {
        if (account.id > highestId) {
          highestId = account.id;
        }
      }

      _nextAccountId = highestId + 1;
    }

    _initialized = true;

    notifyListeners();
  }

  OpenAccount? getAccount(int accountId) {
    for (final account in _accounts) {
      if (account.id == accountId && !account.isClosed) {
        return account;
      }
    }

    return null;
  }

  List<OpenAccount> getTableAccounts(int tableNumber) {
    if (tableNumber <= 0) {
      return const [];
    }

    return List.unmodifiable(
      _accounts.where(
        (account) =>
            !account.isClosed &&
            account.locationType == AccountLocationType.table &&
            account.tableNumber == tableNumber,
      ),
    );
  }

  Future<OpenAccount?> openTableAccount({
    required int tableNumber,
    required String customerName,
  }) async {
    if (!BusinessSettingsService.instance.enableTableSales) {
      return null;
    }

    final cleanName = customerName.trim();

    if (tableNumber <= 0 || cleanName.isEmpty) {
      return null;
    }

    final account = OpenAccount(
      id: _nextAccountId,
      locationType: AccountLocationType.table,
      tableNumber: tableNumber,
      customerName: cleanName,
    );

    try {
      await _repository.saveAccount(account);
    } catch (_) {
      return null;
    }

    _nextAccountId++;

    _accounts.add(account);

    notifyListeners();

    return account;
  }

  Future<OpenAccount?> openBarAccount({required String customerName}) async {
    if (!BusinessSettingsService.instance.enableBarSales) {
      return null;
    }

    final cleanName = customerName.trim();

    if (cleanName.isEmpty) {
      return null;
    }

    final account = OpenAccount(
      id: _nextAccountId,
      locationType: AccountLocationType.bar,
      customerName: cleanName,
    );

    try {
      await _repository.saveAccount(account);
    } catch (_) {
      return null;
    }

    _nextAccountId++;

    _accounts.add(account);

    notifyListeners();

    return account;
  }

  Future<bool> renameAccount({
    required int accountId,
    required String customerName,
  }) async {
    final account = getAccount(accountId);

    final cleanName = customerName.trim();

    if (account == null || cleanName.isEmpty) {
      return false;
    }

    final previousName = account.customerName;

    account.customerName = cleanName;

    try {
      await _repository.saveAccount(account);
    } catch (_) {
      account.customerName = previousName;

      return false;
    }

    notifyListeners();

    return true;
  }

  Future<bool> moveToTable({
    required int accountId,
    required int tableNumber,
  }) async {
    if (!BusinessSettingsService.instance.enableTableSales) {
      return false;
    }

    if (tableNumber <= 0) {
      return false;
    }

    final account = getAccount(accountId);

    if (account == null) {
      return false;
    }

    final previousLocation = account.locationType;

    final previousTableNumber = account.tableNumber;

    try {
      account.moveToTable(tableNumber);

      await _repository.saveAccount(account);
    } catch (_) {
      account.locationType = previousLocation;

      account.tableNumber = previousTableNumber;

      return false;
    }

    notifyListeners();

    return true;
  }

  Future<bool> moveToBar({required int accountId}) async {
    if (!BusinessSettingsService.instance.enableBarSales) {
      return false;
    }

    final account = getAccount(accountId);

    if (account == null) {
      return false;
    }

    final previousLocation = account.locationType;

    final previousTableNumber = account.tableNumber;

    try {
      account.moveToBar();

      await _repository.saveAccount(account);
    } catch (_) {
      account.locationType = previousLocation;

      account.tableNumber = previousTableNumber;

      return false;
    }

    notifyListeners();

    return true;
  }

  Future<void> saveAccount(OpenAccount account) async {
    if (account.isClosed) {
      throw StateError(
        'No se puede guardar una cuenta cerrada como cuenta abierta.',
      );
    }

    await _repository.saveAccount(account);

    notifyListeners();
  }

  Future<bool> closeAccount({required int accountId}) async {
    final account = getAccount(accountId);

    if (account == null) {
      return false;
    }

    try {
      await _repository.markAccountClosed(accountId);
    } catch (_) {
      return false;
    }

    account.isClosed = true;

    _accounts.removeWhere((item) => item.id == accountId);

    notifyListeners();

    return true;
  }

  Future<bool> deleteAccount({required int accountId}) async {
    final account = getAccount(accountId);

    if (account == null) {
      return false;
    }

    try {
      await _repository.deleteAccount(accountId);
    } catch (_) {
      return false;
    }

    _accounts.removeWhere((item) => item.id == accountId);

    notifyListeners();

    return true;
  }

  int getReservedQuantity({required int productId, int? excludeAccountId}) {
    var reservedQuantity = 0;

    for (final account in _accounts) {
      if (account.isClosed) {
        continue;
      }

      if (excludeAccountId != null && account.id == excludeAccountId) {
        continue;
      }

      for (final item in account.items) {
        if (item.product.id == productId) {
          reservedQuantity += item.quantity;
        }
      }
    }

    return reservedQuantity;
  }

  int getReservedQuantityForAccount({
    required int productId,
    required int accountId,
  }) {
    final account = getAccount(accountId);

    if (account == null) {
      return 0;
    }

    var quantity = 0;

    for (final item in account.items) {
      if (item.product.id == productId) {
        quantity += item.quantity;
      }
    }

    return quantity;
  }

  int get openAccountCount {
    return _accounts.where((account) => !account.isClosed).length;
  }

  int get openBarAccountCount {
    return _accounts
        .where(
          (account) =>
              !account.isClosed &&
              account.locationType == AccountLocationType.bar,
        )
        .length;
  }

  int get openTableAccountCount {
    return _accounts
        .where(
          (account) =>
              !account.isClosed &&
              account.locationType == AccountLocationType.table,
        )
        .length;
  }
}
