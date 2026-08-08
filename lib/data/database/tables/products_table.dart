import 'package:drift/drift.dart';

class Products extends Table {
  IntColumn get id => integer()();

  TextColumn get name => text()();

  RealColumn get salePrice => real()();

  RealColumn get purchasePrice => real()();

  TextColumn get imagePath => text()();

  TextColumn get category => text()();

  IntColumn get stock => integer().withDefault(const Constant(0))();

  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  TextColumn get description => text().withDefault(const Constant(''))();

  TextColumn get barcode => text().withDefault(const Constant(''))();

  BoolColumn get favorite => boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
