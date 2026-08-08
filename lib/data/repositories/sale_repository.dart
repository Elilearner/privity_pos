import 'package:drift/drift.dart' as drift;

import '../../models/invoice_item.dart' as domain_item;
import '../../models/payment.dart' as domain_payment;
import '../../models/payment_method.dart';
import '../../models/product.dart' as domain_product;
import '../../models/sale.dart' as domain_sale;
import '../../models/sale_type.dart';
import '../database/app_database.dart' as db;

class SaleRepository {
  SaleRepository(this.database);

  final db.AppDatabase database;

  Future<void> saveSale(domain_sale.Sale sale) async {
    await database.transaction(() async {
      await database
          .into(database.sales)
          .insertOnConflictUpdate(
            db.SalesCompanion.insert(
              id: drift.Value(sale.id),
              type: sale.type.name,
              createdAt: sale.createdAt,
              tableNumber: drift.Value(sale.tableNumber),
              accountId: drift.Value(sale.accountId),
              customerName: drift.Value(sale.customerName),
              deliveryFee: drift.Value(sale.deliveryFee),
              taxRate: drift.Value(sale.taxRate),
              isClosed: drift.Value(sale.isClosed),
            ),
          );

      await (database.delete(
        database.saleItems,
      )..where((table) => table.saleId.equals(sale.id))).go();

      await (database.delete(
        database.payments,
      )..where((table) => table.saleId.equals(sale.id))).go();

      for (final item in sale.items) {
        await database
            .into(database.saleItems)
            .insert(
              db.SaleItemsCompanion.insert(
                saleId: sale.id,
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

      for (final payment in sale.payments) {
        await database
            .into(database.payments)
            .insert(
              db.PaymentsCompanion.insert(
                saleId: sale.id,
                method: payment.method.name,
                amount: payment.amount,
                receivedAmount: drift.Value(payment.receivedAmount),
                reference: drift.Value(payment.reference),
              ),
            );
      }
    });
  }

  Future<List<domain_sale.Sale>> getAllSales() async {
    final saleRows = await (database.select(
      database.sales,
    )..orderBy([(table) => drift.OrderingTerm.desc(table.createdAt)])).get();

    final result = <domain_sale.Sale>[];

    for (final saleRow in saleRows) {
      final itemRows = await (database.select(
        database.saleItems,
      )..where((table) => table.saleId.equals(saleRow.id))).get();

      final paymentRows = await (database.select(
        database.payments,
      )..where((table) => table.saleId.equals(saleRow.id))).get();

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

      final payments = paymentRows.map((paymentRow) {
        return domain_payment.Payment(
          method: _paymentMethodFromString(paymentRow.method),
          amount: paymentRow.amount,
          receivedAmount: paymentRow.receivedAmount,
          reference: paymentRow.reference,
        );
      }).toList();

      result.add(
        domain_sale.Sale(
          id: saleRow.id,
          type: _saleTypeFromString(saleRow.type),
          createdAt: saleRow.createdAt,
          items: items,
          payments: payments,
          tableNumber: saleRow.tableNumber,
          accountId: saleRow.accountId,
          customerName: saleRow.customerName,
          deliveryFee: saleRow.deliveryFee,
          taxRate: saleRow.taxRate,
          isClosed: saleRow.isClosed,
        ),
      );
    }

    return result;
  }

  Future<domain_sale.Sale?> getSale(int saleId) async {
    final sales = await getAllSales();

    for (final sale in sales) {
      if (sale.id == saleId) {
        return sale;
      }
    }

    return null;
  }

  Future<void> deleteSale(int saleId) async {
    await database.transaction(() async {
      await (database.delete(
        database.payments,
      )..where((table) => table.saleId.equals(saleId))).go();

      await (database.delete(
        database.saleItems,
      )..where((table) => table.saleId.equals(saleId))).go();

      await (database.delete(
        database.sales,
      )..where((table) => table.id.equals(saleId))).go();
    });
  }

  PaymentMethod _paymentMethodFromString(String value) {
    for (final method in PaymentMethod.values) {
      if (method.name == value) {
        return method;
      }
    }

    return PaymentMethod.cash;
  }

  SaleType _saleTypeFromString(String value) {
    for (final type in SaleType.values) {
      if (type.name == value) {
        return type;
      }
    }

    return SaleType.table;
  }
}
