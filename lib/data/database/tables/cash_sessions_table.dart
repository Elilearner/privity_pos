import 'package:drift/drift.dart';

class CashSessions extends Table {
  IntColumn get id => integer()();

  DateTimeColumn get openedAt => dateTime()();

  RealColumn get openingAmount => real()();

  DateTimeColumn get closedAt => dateTime().nullable()();

  RealColumn get closingAmount => real().nullable()();

  BoolColumn get isOpen => boolean().withDefault(const Constant(true))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
