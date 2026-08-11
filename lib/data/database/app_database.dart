import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables/account_items_table.dart';
import 'tables/cash_sessions_table.dart';
import 'tables/payments_table.dart';
import 'tables/products_table.dart';
import 'tables/sale_items_table.dart';
import 'tables/sales_table.dart';
import 'tables/table_accounts_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Products,
    Sales,
    SaleItems,
    Payments,
    TableAccounts,
    AccountItems,
    CashSessions,
  ],
)
class AppDatabase extends _$AppDatabase {
  static AppDatabase? _instance;

  factory AppDatabase() {
    return _instance ??= AppDatabase._internal();
  }

  AppDatabase._internal() : super(driftDatabase(name: 'privity_pos'));

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 4) {
          await m.createTable(tableAccounts);
          await m.createTable(accountItems);
        }

        if (from < 5) {
          await m.createTable(cashSessions);
        }
      },
    );
  }
}
