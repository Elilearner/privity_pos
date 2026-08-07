import '../core/business_config.dart';
import '../core/table_names.dart';
import '../models/business_table.dart';
import '../models/table_account.dart';

class TableService {
  TableService._();

  static final TableService instance = TableService._();

  final List<BusinessTable> _tables = [];

  int _nextAccountId = 1;

  List<BusinessTable> get tables {
    return List.unmodifiable(_tables);
  }

  void initialize() {
    if (_tables.isNotEmpty) {
      return;
    }

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

  TableAccount? openAccount({
    required int tableNumber,
    required String customerName,
  }) {
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

    _nextAccountId++;
    table.addAccount(account);

    return account;
  }

  bool closeAccount({required int tableNumber, required int accountId}) {
    final table = getTable(tableNumber);

    if (table == null) {
      return false;
    }

    final account = table.findAccount(accountId);

    if (account == null) {
      return false;
    }

    account.isClosed = true;
    table.removeAccount(accountId);

    return true;
  }

  bool renameAccount({
    required int tableNumber,
    required int accountId,
    required String customerName,
  }) {
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
