import 'package:flutter/foundation.dart';

import '../core/business_config.dart';
import '../core/table_names.dart';
import '../data/database/app_database.dart' as db;
import '../data/repositories/table_account_repository.dart';
import '../models/business_table.dart';
import '../models/table_account.dart';

class TableService extends ChangeNotifier {
  TableService._();

  static final TableService instance = TableService._();

  final List<BusinessTable> _tables = [];

  late final db.AppDatabase _database;
  late final TableAccountRepository _repository;

  bool _initialized = false;

  int _nextAccountId = 1;

  List<BusinessTable> get tables {
    return List.unmodifiable(_tables);
  }

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    _database = db.AppDatabase();

    _repository = TableAccountRepository(_database);

    _tables.clear();

    for (
      int tableNumber = 1;
      tableNumber <= BusinessConfig.totalTables;
      tableNumber++
    ) {
      _tables.add(
        BusinessTable(
          id: tableNumber,
          number: tableNumber,
          name: TableNames.getName(tableNumber),
          accounts: [],
        ),
      );
    }

    final storedAccounts = await _repository.getOpenAccounts();

    for (final account in storedAccounts) {
      final table = getTable(account.tableNumber);

      if (table != null) {
        table.addAccount(account);
      }
    }

    if (storedAccounts.isNotEmpty) {
      int highestId = 0;

      for (final account in storedAccounts) {
        if (account.id > highestId) {
          highestId = account.id;
        }
      }

      _nextAccountId = highestId + 1;
    }

    _initialized = true;
  }

  BusinessTable? getTable(int tableNumber) {
    for (final table in _tables) {
      if (table.number == tableNumber) {
        return table;
      }
    }

    return null;
  }

  List<TableAccount> getAccounts(int tableNumber) {
    final table = getTable(tableNumber);

    if (table == null) {
      return const [];
    }

    return List.unmodifiable(table.accounts);
  }

  List<TableAccount> get allOpenAccounts {
    final result = <TableAccount>[];

    for (final table in _tables) {
      for (final account in table.accounts) {
        if (!account.isClosed) {
          result.add(account);
        }
      }
    }

    return List.unmodifiable(result);
  }

  int getReservedQuantity({required int productId, int? excludeAccountId}) {
    var reservedQuantity = 0;

    for (final table in _tables) {
      for (final account in table.accounts) {
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
    }

    return reservedQuantity;
  }

  int getReservedQuantityForAccount({
    required int productId,
    required int accountId,
  }) {
    for (final table in _tables) {
      for (final account in table.accounts) {
        if (account.id != accountId || account.isClosed) {
          continue;
        }

        var quantity = 0;

        for (final item in account.items) {
          if (item.product.id == productId) {
            quantity += item.quantity;
          }
        }

        return quantity;
      }
    }

    return 0;
  }

  Future<TableAccount?> openAccount({
    required int tableNumber,
    required String customerName,
  }) async {
    final table = getTable(tableNumber);

    final cleanName = customerName.trim();

    if (table == null || cleanName.isEmpty) {
      return null;
    }

    final account = TableAccount(
      id: _nextAccountId,
      tableNumber: tableNumber,
      customerName: cleanName,
    );

    await _repository.saveAccount(account);

    _nextAccountId++;

    table.addAccount(account);

    notifyListeners();

    return account;
  }

  Future<bool> closeAccount({
    required int tableNumber,
    required int accountId,
  }) async {
    final table = getTable(tableNumber);

    if (table == null) {
      return false;
    }

    final account = table.findAccount(accountId);

    if (account == null) {
      return false;
    }

    account.isClosed = true;

    await _repository.markAccountClosed(accountId);

    table.removeAccount(accountId);

    notifyListeners();

    return true;
  }

  Future<bool> renameAccount({
    required int tableNumber,
    required int accountId,
    required String customerName,
  }) async {
    final table = getTable(tableNumber);

    final cleanName = customerName.trim();

    if (table == null || cleanName.isEmpty) {
      return false;
    }

    final account = table.findAccount(accountId);

    if (account == null) {
      return false;
    }

    account.customerName = cleanName;

    await _repository.saveAccount(account);

    notifyListeners();

    return true;
  }

  Future<void> saveAccount(TableAccount account) async {
    await _repository.saveAccount(account);

    notifyListeners();
  }

  bool get hasOpenTables {
    return _tables.any((table) => table.isOccupied);
  }

  int get totalTables {
    return _tables.length;
  }

  int get occupiedTables {
    return _tables.where((table) => table.isOccupied).length;
  }

  int get freeTables {
    return totalTables - occupiedTables;
  }
}
