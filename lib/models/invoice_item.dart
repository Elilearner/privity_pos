import 'product.dart';

class InvoiceItem {
  InvoiceItem({
    required this.product,
    double? unitPrice,
    double? unitCost,
    this.quantity = 1,
  }) : unitPrice = unitPrice ?? product.salePrice,
       unitCost = unitCost ?? product.purchasePrice;

  final Product product;

  final double unitPrice;
  final double unitCost;

  int quantity;

  double get total {
    return quantity * unitPrice;
  }

  double get totalCost {
    return quantity * unitCost;
  }

  double get profit {
    return total - totalCost;
  }

  void increase() {
    quantity++;
  }

  void decrease() {
    if (quantity > 1) {
      quantity--;
    }
  }
}
