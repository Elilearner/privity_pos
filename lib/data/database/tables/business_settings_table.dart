import 'package:drift/drift.dart';

class BusinessSettings extends Table {
  IntColumn get id => integer()();

  BoolColumn get enableTableSales =>
      boolean().withDefault(const Constant(true))();

  BoolColumn get enableBarSales =>
      boolean().withDefault(const Constant(true))();

  BoolColumn get enableQuickSale =>
      boolean().withDefault(const Constant(true))();

  BoolColumn get enableTakeaway =>
      boolean().withDefault(const Constant(true))();

  BoolColumn get enableDelivery =>
      boolean().withDefault(const Constant(true))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
