import 'invoice_item.dart';
import 'sale_type.dart';

class SaleDraft {
  SaleDraft({
    required this.type,
    List<InvoiceItem>? items,
    this.customerName,
    this.customerPhone,
    this.deliveryAddress,
    this.deliveryReference,
    this.deliveryFee = 0,
    this.taxRate = 0,
  }) : items = items ?? [];

  final SaleType type;

  final List<InvoiceItem> items;

  String? customerName;

  String? customerPhone;

  String? deliveryAddress;

  String? deliveryReference;

  double deliveryFee;

  double taxRate;

  double get subtotal {
    return items.fold<double>(0, (sum, item) => sum + item.total);
  }

  double get tax {
    return subtotal * taxRate;
  }

  double get total {
    return subtotal + tax + deliveryFee;
  }

  int get totalItems {
    return items.fold<int>(0, (sum, item) => sum + item.quantity);
  }

  bool get isEmpty {
    return items.isEmpty;
  }

  bool get isNotEmpty {
    return items.isNotEmpty;
  }

  void addItem(InvoiceItem item) {
    items.add(item);
  }

  void removeItem(int index) {
    if (index < 0 || index >= items.length) {
      return;
    }

    items.removeAt(index);
  }

  InvoiceItem? findItem(int productId) {
    for (final item in items) {
      if (item.product.id == productId) {
        return item;
      }
    }

    return null;
  }

  void clear() {
    items.clear();
  }
}
