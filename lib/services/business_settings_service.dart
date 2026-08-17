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

  String _tableSingularLabel = 'Mesa';
  String _tablePluralLabel = 'Mesas';
  String _barLabel = 'Barra';
  String _quickSaleLabel = 'Venta rápida';
  String _takeawayLabel = 'Para llevar';

  bool get enableTableSales => _enableTableSales;
  bool get enableBarSales => _enableBarSales;
  bool get enableQuickSale => _enableQuickSale;
  bool get enableTakeaway => _enableTakeaway;
  bool get enableDelivery => _enableDelivery;

  String get tableSingularLabel => _tableSingularLabel;
  String get tablePluralLabel => _tablePluralLabel;
  String get barLabel => _barLabel;
  String get quickSaleLabel => _quickSaleLabel;
  String get takeawayLabel => _takeawayLabel;

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

    _tableSingularLabel = _cleanLabel(
      settings.tableSingularLabel,
      fallback: 'Mesa',
    );

    _tablePluralLabel = _cleanLabel(
      settings.tablePluralLabel,
      fallback: 'Mesas',
    );

    _barLabel = _cleanLabel(settings.barLabel, fallback: 'Barra');

    _quickSaleLabel = _cleanLabel(
      settings.quickSaleLabel,
      fallback: 'Venta rápida',
    );

    _takeawayLabel = _cleanLabel(
      settings.takeawayLabel,
      fallback: 'Para llevar',
    );

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

  Future<void> setTableSingularLabel(String value) async {
    _tableSingularLabel = _validateCustomLabel(value, fallback: 'Mesa');

    await _save();
  }

  Future<void> setTablePluralLabel(String value) async {
    _tablePluralLabel = _validateCustomLabel(value, fallback: 'Mesas');

    await _save();
  }

  Future<void> setBarLabel(String value) async {
    _barLabel = _validateCustomLabel(value, fallback: 'Barra');

    await _save();
  }

  Future<void> setQuickSaleLabel(String value) async {
    _quickSaleLabel = _validateCustomLabel(value, fallback: 'Venta rápida');

    await _save();
  }

  Future<void> setTakeawayLabel(String value) async {
    _takeawayLabel = _validateCustomLabel(value, fallback: 'Para llevar');

    await _save();
  }

  Future<void> updateLabels({
    required String tableSingularLabel,
    required String tablePluralLabel,
    required String barLabel,
    required String quickSaleLabel,
    required String takeawayLabel,
  }) async {
    _tableSingularLabel = _validateCustomLabel(
      tableSingularLabel,
      fallback: 'Mesa',
    );

    _tablePluralLabel = _validateCustomLabel(
      tablePluralLabel,
      fallback: 'Mesas',
    );

    _barLabel = _validateCustomLabel(barLabel, fallback: 'Barra');

    _quickSaleLabel = _validateCustomLabel(
      quickSaleLabel,
      fallback: 'Venta rápida',
    );

    _takeawayLabel = _validateCustomLabel(
      takeawayLabel,
      fallback: 'Para llevar',
    );

    await _save();
  }

  Future<void> resetLabelsToDefault() async {
    _tableSingularLabel = 'Mesa';
    _tablePluralLabel = 'Mesas';
    _barLabel = 'Barra';
    _quickSaleLabel = 'Venta rápida';
    _takeawayLabel = 'Para llevar';

    await _save();
  }

  Future<void> _save() async {
    await _repository.updateSettings(
      enableTableSales: _enableTableSales,
      enableBarSales: _enableBarSales,
      enableQuickSale: _enableQuickSale,
      enableTakeaway: _enableTakeaway,
      enableDelivery: _enableDelivery,
      tableSingularLabel: _tableSingularLabel,
      tablePluralLabel: _tablePluralLabel,
      barLabel: _barLabel,
      quickSaleLabel: _quickSaleLabel,
      takeawayLabel: _takeawayLabel,
    );

    notifyListeners();
  }

  String _validateCustomLabel(String value, {required String fallback}) {
    final cleanValue = value.trim();

    if (cleanValue.isEmpty) {
      return fallback;
    }

    if (cleanValue.length > 30) {
      return cleanValue.substring(0, 30);
    }

    return cleanValue;
  }

  String _cleanLabel(String value, {required String fallback}) {
    final cleanValue = value.trim();

    if (cleanValue.isEmpty) {
      return fallback;
    }

    return cleanValue;
  }
}
