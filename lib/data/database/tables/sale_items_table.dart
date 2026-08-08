import 'package:drift/drift.dart';

class SaleItems extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get saleId => integer()();

  IntColumn get productId => integer()();

  TextColumn get productName => text()();

  TextColumn get productImagePath => text()();

  TextColumn get productCategory => text()();

  RealColumn get unitPrice => real()();

  RealColumn get unitCost => real()();

  IntColumn get quantity => integer()();
}
