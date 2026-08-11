import 'package:drift/drift.dart' as drift;

import '../../models/invoice_item.dart' as domain_item;
import '../../models/product.dart' as domain_product;
import '../../models/table_account.dart' as domain_account;
import '../database/app_database.dart' as db;

class TableAccountRepository {
  TableAccountRepository(this.database);

  final db.AppDatabase database;

  Future<void> saveAccount(domain_account.TableAccount account) async {
    await database.transaction(() async {
      await database
          .into(database.tableAccounts)
          .insertOnConflictUpdate(
            db.TableAccountsCompanion.insert(
              id: drift.Value(account.id),
              tableNumber: account.tableNumber,
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

  Future<List<domain_account.TableAccount>> getOpenAccounts() async {
    final accountRows = await (database.select(
      database.tableAccounts,
    )..where((table) => table.isClosed.equals(false))).get();

    final result = <domain_account.TableAccount>[];

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
        domain_account.TableAccount(
          id: accountRow.id,
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

  Future<void> deleteAccount(int accountId) async {
    await database.transaction(() async {
      await (database.delete(
        database.accountItems,
      )..where((table) => table.accountId.equals(accountId))).go();

      await (database.delete(
        database.tableAccounts,
      )..where((table) => table.id.equals(accountId))).go();
    });
  }

  Future<void> markAccountClosed(int accountId) async {
    await (database.update(database.tableAccounts)
          ..where((table) => table.id.equals(accountId)))
        .write(const db.TableAccountsCompanion(isClosed: drift.Value(true)));
  }
}
