import 'cash_service.dart';
import 'product_service.dart';
import 'sale_service.dart';
import 'table_service.dart';

class Services {
  Services._();

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

  static Future<void> initialize() async {
    await products.initialize();
    await tables.initialize();
    await sales.initialize();
    await cash.initialize();
  }
}
