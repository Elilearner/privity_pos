import 'package:drift/drift.dart';

class TableAccounts extends Table {
  IntColumn get id => integer()();

  IntColumn get tableNumber => integer()();

  TextColumn get customerName => text()();

  DateTimeColumn get openedAt => dateTime()();

  BoolColumn get isClosed => boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
