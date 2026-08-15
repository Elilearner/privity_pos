import 'business_settings_service.dart';
import 'cash_service.dart';
import 'open_account_service.dart';
import 'printer_service.dart';
import 'product_service.dart';
import 'sale_service.dart';
import 'table_service.dart';

class Services {
  Services._();

  static BusinessSettingsService get settings {
    return BusinessSettingsService.instance;
  }

  static OpenAccountService get openAccounts {
    return OpenAccountService.instance;
  }

  static TableService get tables {
    return TableService.instance;
  }

  static ProductService get products {
    return ProductService.instance;
  }

  static SaleService get sales {
    return SaleService.instance;
  }

  static CashService get cash {
    return CashService.instance;
  }

  static PrinterService get printer {
    return PrinterService.instance;
  }

  static Future<void> initialize() async {
    await settings.initialize();

    await products.initialize();

    await openAccounts.initialize();

    await tables.initialize();

    await sales.initialize();

    await cash.initialize();
  }
}
