class BusinessConfig {
  BusinessConfig._();

  // Información general
  static const String businessName = 'PRIVITY DRINK';

  static const String currency = 'RD\$';

  // Mesas
  static const int totalTables = 8;

  static const bool enableMultipleAccounts = true;

  // Tipos de venta
  static const bool enableTableSales = true;

  static const bool enableQuickSale = true;

  static const bool enableTakeaway = true;

  static const bool enableDelivery = true;

  // Métodos de pago
  static const bool enableCashPayment = true;

  static const bool enableCardPayment = true;

  static const bool enableTransferPayment = true;

  static const bool enableMixedPayment = true;
}
