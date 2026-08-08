import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables/payments_table.dart';
import 'tables/products_table.dart';
import 'tables/sale_items_table.dart';
import 'tables/sales_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Products, Sales, SaleItems, Payments])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'privity_pos'));

  @override
  int get schemaVersion => 3;
}
