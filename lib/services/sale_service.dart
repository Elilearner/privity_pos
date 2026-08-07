import '../models/invoice_item.dart';
import '../models/product.dart';
import '../models/table_account.dart';

class SaleService {
  SaleService._();

  static final SaleService instance = SaleService._();

  void addProductToAccount({
    required TableAccount account,
    required Product product,
  }) {
    for (final item in account.items) {
      if (item.product.id == product.id) {
        item.increase();
        return;
      }
    }

    account.addItem(InvoiceItem(product: product));
  }

  bool increaseProductQuantity({
    required TableAccount account,
    required int productId,
  }) {
    final item = _findItem(account: account, productId: productId);

    if (item == null) {
      return false;
    }

    item.increase();
    return true;
  }

  bool decreaseProductQuantity({
    required TableAccount account,
    required int productId,
  }) {
    final item = _findItem(account: account, productId: productId);

    if (item == null) {
      return false;
    }

    if (item.quantity <= 1) {
      return false;
    }

    item.decrease();
    return true;
  }

  bool removeProduct({required TableAccount account, required int productId}) {
    final index = account.items.indexWhere(
      (item) => item.product.id == productId,
    );

    if (index == -1) {
      return false;
    }

    account.removeItem(index);
    return true;
  }

  void clearAccount(TableAccount account) {
    account.clear();
  }

  double getSubtotal(TableAccount account) {
    return account.subtotal;
  }

  int getTotalItems(TableAccount account) {
    return account.totalItems;
  }

  InvoiceItem? getItem({
    required TableAccount account,
    required int productId,
  }) {
    return _findItem(account: account, productId: productId);
  }

  InvoiceItem? _findItem({
    required TableAccount account,
    required int productId,
  }) {
    for (final item in account.items) {
      if (item.product.id == productId) {
        return item;
      }
    }

    return null;
  }
}
