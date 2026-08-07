import 'invoice_item.dart';

class TableAccount {
  TableAccount({
    required this.id,
    required this.tableNumber,
    required this.customerName,
    DateTime? openedAt,
    List<InvoiceItem>? items,
    this.isClosed = false,
  }) : openedAt = openedAt ?? DateTime.now(),
       items = items ?? [];

  final int id;

  final int tableNumber;

  String customerName;

  final DateTime openedAt;

  final List<InvoiceItem> items;

  bool isClosed;

  double get subtotal {
    return items.fold(0, (sum, item) => sum + item.total);
  }

  int get totalItems {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }

  bool get isEmpty {
    return items.isEmpty;
  }

  void addItem(InvoiceItem item) {
    items.add(item);
  }

  void removeItem(int index) {
    if (index >= 0 && index < items.length) {
      items.removeAt(index);
    }
  }

  void clear() {
    items.clear();
  }
}
