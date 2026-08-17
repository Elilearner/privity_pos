import 'package:drift/drift.dart' as drift;

import '../database/app_database.dart' as db;

class BusinessSettingsRepository {
  BusinessSettingsRepository(this.database);

  final db.AppDatabase database;

  Future<db.BusinessSetting> getSettings() async {
    final existing = await database
        .select(database.businessSettings)
        .getSingleOrNull();

    if (existing != null) {
      return existing;
    }

    await database
        .into(database.businessSettings)
        .insert(db.BusinessSettingsCompanion.insert(id: const drift.Value(1)));

    return database.select(database.businessSettings).getSingle();
  }

  Future<void> updateSettings({
    required bool enableTableSales,
    required bool enableBarSales,
    required bool enableQuickSale,
    required bool enableTakeaway,
    required bool enableDelivery,
    required String tableSingularLabel,
    required String tablePluralLabel,
    required String barLabel,
    required String quickSaleLabel,
    required String takeawayLabel,
  }) async {
    await database
        .into(database.businessSettings)
        .insertOnConflictUpdate(
          db.BusinessSettingsCompanion.insert(
            id: const drift.Value(1),

            enableTableSales: drift.Value(enableTableSales),

            enableBarSales: drift.Value(enableBarSales),

            enableQuickSale: drift.Value(enableQuickSale),

            enableTakeaway: drift.Value(enableTakeaway),

            enableDelivery: drift.Value(enableDelivery),

            tableSingularLabel: drift.Value(
              _cleanLabel(tableSingularLabel, fallback: 'Mesa'),
            ),

            tablePluralLabel: drift.Value(
              _cleanLabel(tablePluralLabel, fallback: 'Mesas'),
            ),

            barLabel: drift.Value(_cleanLabel(barLabel, fallback: 'Barra')),

            quickSaleLabel: drift.Value(
              _cleanLabel(quickSaleLabel, fallback: 'Venta rápida'),
            ),

            takeawayLabel: drift.Value(
              _cleanLabel(takeawayLabel, fallback: 'Para llevar'),
            ),
          ),
        );
  }

  String _cleanLabel(String value, {required String fallback}) {
    final cleanValue = value.trim();

    if (cleanValue.isEmpty) {
      return fallback;
    }

    return cleanValue;
  }
}
