import 'package:flutter/foundation.dart';

import '../data/database/app_database.dart' as db;
import '../data/repositories/business_settings_repository.dart';

class BusinessSettingsService extends ChangeNotifier {
  BusinessSettingsService._();

  static final BusinessSettingsService instance = BusinessSettingsService._();

  late final db.AppDatabase _database;
  late final BusinessSettingsRepository _repository;

  bool _initialized = false;

  bool _enableTableSales = true;
  bool _enableBarSales = true;
  bool _enableQuickSale = true;
  bool _enableTakeaway = true;
  bool _enableDelivery = true;

  bool get enableTableSales => _enableTableSales;
  bool get enableBarSales => _enableBarSales;
  bool get enableQuickSale => _enableQuickSale;
  bool get enableTakeaway => _enableTakeaway;
  bool get enableDelivery => _enableDelivery;

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    _database = db.AppDatabase();
    _repository = BusinessSettingsRepository(_database);

    final settings = await _repository.getSettings();

    _enableTableSales = settings.enableTableSales;

    _enableBarSales = settings.enableBarSales;

    _enableQuickSale = settings.enableQuickSale;

    _enableTakeaway = settings.enableTakeaway;

    _enableDelivery = settings.enableDelivery;

    _initialized = true;

    notifyListeners();
  }

  Future<void> setTableSalesEnabled(bool value) async {
    _enableTableSales = value;

    await _save();
  }

  Future<void> setBarSalesEnabled(bool value) async {
    _enableBarSales = value;

    await _save();
  }

  Future<void> setQuickSaleEnabled(bool value) async {
    _enableQuickSale = value;

    await _save();
  }

  Future<void> setTakeawayEnabled(bool value) async {
    _enableTakeaway = value;

    await _save();
  }

  Future<void> setDeliveryEnabled(bool value) async {
    _enableDelivery = value;

    await _save();
  }

  Future<void> _save() async {
    await _repository.updateSettings(
      enableTableSales: _enableTableSales,
      enableBarSales: _enableBarSales,
      enableQuickSale: _enableQuickSale,
      enableTakeaway: _enableTakeaway,
      enableDelivery: _enableDelivery,
    );

    notifyListeners();
  }
}
