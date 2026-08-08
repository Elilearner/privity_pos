import 'package:drift/drift.dart';

class Payments extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get saleId => integer()();

  TextColumn get method => text()();

  RealColumn get amount => real()();

  RealColumn get receivedAmount => real().nullable()();

  TextColumn get reference => text().nullable()();
}
