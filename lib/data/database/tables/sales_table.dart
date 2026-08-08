import 'package:drift/drift.dart';

class Sales extends Table {
  IntColumn get id => integer()();

  TextColumn get type => text()();

  DateTimeColumn get createdAt => dateTime()();

  IntColumn get tableNumber => integer().nullable()();

  IntColumn get accountId => integer().nullable()();

  TextColumn get customerName => text().nullable()();

  RealColumn get deliveryFee => real().withDefault(const Constant(0))();

  RealColumn get taxRate => real().withDefault(const Constant(0))();

  BoolColumn get isClosed => boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
