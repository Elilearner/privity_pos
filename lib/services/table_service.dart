import 'package:flutter/foundation.dart';

import '../core/business_config.dart';
import '../core/table_names.dart';
import '../models/business_table.dart';
import '../models/open_account.dart';
import 'open_account_service.dart';

class TableService extends ChangeNotifier {
  TableService._();

  static final TableService instance = TableService._();

  final List<BusinessTable> _tables = [];

  bool _initialized = false;

  List<BusinessTable> get tables {
    return List.unmodifiable(_tables);
  }

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    await OpenAccountService.instance.initialize();

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

    final storedAccounts = OpenAccountService.instance.allOpenAccounts;

    for (final account in storedAccounts) {
      if (!account.isTable) {
        continue;
      }

      final tableNumber = account.tableNumber;

      if (tableNumber == null) {
        continue;
      }

      final table = getTable(tableNumber);

      if (table != null) {
        table.addAccount(account);
      }
    }

    OpenAccountService.instance.addListener(_handleOpenAccountsChanged);

    _initialized = true;
  }

  @override
  void dispose() {
    OpenAccountService.instance.removeListener(_handleOpenAccountsChanged);

    super.dispose();
  }

  void _handleOpenAccountsChanged() {
    _synchronizeTableAccounts();

    notifyListeners();
  }

  void _synchronizeTableAccounts() {
    for (final table in _tables) {
      table.accounts.clear();
    }

    final accounts = OpenAccountService.instance.allOpenAccounts;

    for (final account in accounts) {
      if (!account.isTable) {
        continue;
      }

      final tableNumber = account.tableNumber;

      if (tableNumber == null) {
        continue;
      }

      final table = getTable(tableNumber);

      if (table != null) {
        table.addAccount(account);
      }
    }
  }

  BusinessTable? getTable(int tableNumber) {
    for (final table in _tables) {
      if (table.number == tableNumber) {
        return table;
      }
    }

    return null;
  }

  List<OpenAccount> getAccounts(int tableNumber) {
    final table = getTable(tableNumber);

    if (table == null) {
      return const [];
    }

    return List.unmodifiable(table.accounts);
  }

  List<OpenAccount> get allOpenAccounts {
    return OpenAccountService.instance.allOpenAccounts;
  }

  int getReservedQuantity({required int productId, int? excludeAccountId}) {
    return OpenAccountService.instance.getReservedQuantity(
      productId: productId,
      excludeAccountId: excludeAccountId,
    );
  }

  int getReservedQuantityForAccount({
    required int productId,
    required int accountId,
  }) {
    return OpenAccountService.instance.getReservedQuantityForAccount(
      productId: productId,
      accountId: accountId,
    );
  }

  Future<OpenAccount?> openAccount({
    required int tableNumber,
    required String customerName,
  }) async {
    final table = getTable(tableNumber);

    if (table == null) {
      return null;
    }

    final account = await OpenAccountService.instance.openTableAccount(
      tableNumber: tableNumber,
      customerName: customerName,
    );

    if (account == null) {
      return null;
    }

    _synchronizeTableAccounts();

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

    final closed = await OpenAccountService.instance.closeAccount(
      accountId: accountId,
    );

    if (!closed) {
      return false;
    }

    _synchronizeTableAccounts();

    notifyListeners();

    return true;
  }

  Future<bool> renameAccount({
    required int tableNumber,
    required int accountId,
    required String customerName,
  }) async {
    final table = getTable(tableNumber);

    if (table == null) {
      return false;
    }

    final account = table.findAccount(accountId);

    if (account == null) {
      return false;
    }

    final renamed = await OpenAccountService.instance.renameAccount(
      accountId: accountId,
      customerName: customerName,
    );

    if (!renamed) {
      return false;
    }

    notifyListeners();

    return true;
  }

  Future<void> saveAccount(OpenAccount account) async {
    await OpenAccountService.instance.saveAccount(account);

    notifyListeners();
  }

  Future<bool> moveAccountToTable({
    required int accountId,
    required int tableNumber,
  }) async {
    final table = getTable(tableNumber);

    if (table == null) {
      return false;
    }

    final moved = await OpenAccountService.instance.moveToTable(
      accountId: accountId,
      tableNumber: tableNumber,
    );

    if (!moved) {
      return false;
    }

    _synchronizeTableAccounts();

    notifyListeners();

    return true;
  }

  Future<bool> moveAccountToBar({required int accountId}) async {
    final moved = await OpenAccountService.instance.moveToBar(
      accountId: accountId,
    );

    if (!moved) {
      return false;
    }

    _synchronizeTableAccounts();

    notifyListeners();

    return true;
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
