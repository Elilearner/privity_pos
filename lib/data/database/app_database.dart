import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables/account_items_table.dart';
import 'tables/app_users_table.dart';
import 'tables/business_settings_table.dart';
import 'tables/cash_sessions_table.dart';
import 'tables/open_accounts_table.dart';
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
    BusinessSettings,
    OpenAccounts,
    AppUsers,
  ],
)
class AppDatabase extends _$AppDatabase {
  static AppDatabase? _instance;

  factory AppDatabase() {
    return _instance ??= AppDatabase._internal();
  }

  AppDatabase._internal() : super(driftDatabase(name: 'privity_pos'));

  @override
  int get schemaVersion => 10;

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

        if (from < 6) {
          await m.addColumn(sales, sales.customerPhone);

          await m.addColumn(sales, sales.deliveryAddress);

          await m.addColumn(sales, sales.deliveryReference);
        }

        if (from < 7) {
          await m.createTable(businessSettings);
        }

        if (from < 8) {
          await m.createTable(openAccounts);

          await customStatement('''
            INSERT OR IGNORE INTO open_accounts (
              id,
              location_type,
              table_number,
              customer_name,
              opened_at,
              is_closed
            )
            SELECT
              id,
              'table',
              table_number,
              customer_name,
              opened_at,
              is_closed
            FROM table_accounts
            ''');
        }

        if (from < 9) {
          await m.createTable(appUsers);
        }

        if (from < 10) {
          await m.addColumn(
            businessSettings,
            businessSettings.tableSingularLabel,
          );

          await m.addColumn(
            businessSettings,
            businessSettings.tablePluralLabel,
          );

          await m.addColumn(businessSettings, businessSettings.barLabel);

          await m.addColumn(businessSettings, businessSettings.quickSaleLabel);

          await m.addColumn(businessSettings, businessSettings.takeawayLabel);
        }
      },
    );
  }
}
