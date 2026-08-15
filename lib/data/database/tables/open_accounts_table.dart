import 'package:drift/drift.dart';

class OpenAccounts extends Table {
  IntColumn get id => integer()();

  TextColumn get locationType => text()();

  IntColumn get tableNumber => integer().nullable()();

  TextColumn get customerName => text()();

  DateTimeColumn get openedAt => dateTime()();

  BoolColumn get isClosed => boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
