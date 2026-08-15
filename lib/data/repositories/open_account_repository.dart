import 'package:drift/drift.dart' as drift;

import '../../models/account_location_type.dart';
import '../../models/invoice_item.dart' as domain_item;
import '../../models/open_account.dart' as domain_account;
import '../../models/product.dart' as domain_product;
import '../database/app_database.dart' as db;

class OpenAccountRepository {
  OpenAccountRepository(this.database);

  final db.AppDatabase database;

  Future<void> saveAccount(domain_account.OpenAccount account) async {
    await database.transaction(() async {
      await database
          .into(database.openAccounts)
          .insertOnConflictUpdate(
            db.OpenAccountsCompanion.insert(
              id: drift.Value(account.id),
              locationType: account.locationType.name,
              tableNumber: drift.Value(account.tableNumber),
              customerName: account.customerName,
              openedAt: account.openedAt,
              isClosed: drift.Value(account.isClosed),
            ),
          );

      await (database.delete(
        database.accountItems,
      )..where((table) => table.accountId.equals(account.id))).go();

      for (final item in account.items) {
        await database
            .into(database.accountItems)
            .insert(
              db.AccountItemsCompanion.insert(
                accountId: account.id,
                productId: item.product.id,
                productName: item.product.name,
                productImagePath: item.product.imagePath,
                productCategory: item.product.category,
                unitPrice: item.unitPrice,
                unitCost: item.unitCost,
                quantity: item.quantity,
              ),
            );
      }
    });
  }

  Future<List<domain_account.OpenAccount>> getOpenAccounts() async {
    final accountRows = await (database.select(
      database.openAccounts,
    )..where((table) => table.isClosed.equals(false))).get();

    final result = <domain_account.OpenAccount>[];

    for (final accountRow in accountRows) {
      final itemRows = await (database.select(
        database.accountItems,
      )..where((table) => table.accountId.equals(accountRow.id))).get();

      final items = itemRows.map((itemRow) {
        final product = domain_product.Product(
          id: itemRow.productId,
          name: itemRow.productName,
          salePrice: itemRow.unitPrice,
          purchasePrice: itemRow.unitCost,
          imagePath: itemRow.productImagePath,
          category: itemRow.productCategory,
        );

        return domain_item.InvoiceItem(
          product: product,
          unitPrice: itemRow.unitPrice,
          unitCost: itemRow.unitCost,
          quantity: itemRow.quantity,
        );
      }).toList();

      result.add(
        domain_account.OpenAccount(
          id: accountRow.id,
          locationType: _locationTypeFromString(accountRow.locationType),
          tableNumber: accountRow.tableNumber,
          customerName: accountRow.customerName,
          openedAt: accountRow.openedAt,
          items: items,
          isClosed: accountRow.isClosed,
        ),
      );
    }

    return result;
  }

  Future<void> markAccountClosed(int accountId) async {
    await (database.update(database.openAccounts)
          ..where((table) => table.id.equals(accountId)))
        .write(const db.OpenAccountsCompanion(isClosed: drift.Value(true)));
  }

  Future<void> deleteAccount(int accountId) async {
    await database.transaction(() async {
      await (database.delete(
        database.accountItems,
      )..where((table) => table.accountId.equals(accountId))).go();

      await (database.delete(
        database.openAccounts,
      )..where((table) => table.id.equals(accountId))).go();
    });
  }

  AccountLocationType _locationTypeFromString(String value) {
    for (final type in AccountLocationType.values) {
      if (type.name == value) {
        return type;
      }
    }

    return AccountLocationType.table;
  }
}
