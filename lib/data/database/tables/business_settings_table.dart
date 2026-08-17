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

  // =========================================================
  // ETIQUETAS CONFIGURABLES DE LOS MÓDULOS
  // =========================================================

  TextColumn get tableSingularLabel =>
      text().withDefault(const Constant('Mesa'))();

  TextColumn get tablePluralLabel =>
      text().withDefault(const Constant('Mesas'))();

  TextColumn get barLabel => text().withDefault(const Constant('Barra'))();

  TextColumn get quickSaleLabel =>
      text().withDefault(const Constant('Venta rápida'))();

  TextColumn get takeawayLabel =>
      text().withDefault(const Constant('Para llevar'))();

  // Delivery permanece fijo por diseño.

  @override
  Set<Column<Object>> get primaryKey => {id};
}
