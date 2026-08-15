import 'account_location_type.dart';
import 'invoice_item.dart';

class OpenAccount {
  OpenAccount({
    required this.id,
    required this.locationType,
    required this.customerName,
    this.tableNumber,
    DateTime? openedAt,
    List<InvoiceItem>? items,
    this.isClosed = false,
  }) : openedAt = openedAt ?? DateTime.now(),
       items = items ?? [] {
    _validateLocation();
  }

  final int id;

  AccountLocationType locationType;

  int? tableNumber;

  String customerName;

  final DateTime openedAt;

  final List<InvoiceItem> items;

  bool isClosed;

  bool get isTable {
    return locationType == AccountLocationType.table;
  }

  bool get isBar {
    return locationType == AccountLocationType.bar;
  }

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

  void moveToTable(int newTableNumber) {
    if (newTableNumber <= 0) {
      throw ArgumentError('El número de mesa debe ser mayor que cero.');
    }

    locationType = AccountLocationType.table;

    tableNumber = newTableNumber;
  }

  void moveToBar() {
    locationType = AccountLocationType.bar;

    tableNumber = null;
  }

  void _validateLocation() {
    if (locationType == AccountLocationType.table &&
        (tableNumber == null || tableNumber! <= 0)) {
      throw ArgumentError(
        'Una cuenta de mesa debe tener un número de mesa válido.',
      );
    }

    if (locationType == AccountLocationType.bar && tableNumber != null) {
      throw ArgumentError('Una cuenta de barra no debe tener número de mesa.');
    }
  }
}
