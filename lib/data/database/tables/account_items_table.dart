import 'package:drift/drift.dart';

class AccountItems extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get accountId => integer()();

  IntColumn get productId => integer()();

  TextColumn get productName => text()();

  TextColumn get productImagePath => text()();

  TextColumn get productCategory => text()();

  RealColumn get unitPrice => real()();

  RealColumn get unitCost => real()();

  IntColumn get quantity => integer()();
}
