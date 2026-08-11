import 'invoice_item.dart';
import 'payment.dart';
import 'sale_type.dart';

class Sale {
  Sale({
    required this.id,
    required this.type,
    required this.createdAt,
    required this.items,
    this.tableNumber,
    this.accountId,
    this.customerName,
    this.customerPhone,
    this.deliveryAddress,
    this.deliveryReference,
    this.deliveryFee = 0,
    this.taxRate = 0,
    List<Payment>? payments,
    this.isClosed = false,
  }) : payments = payments ?? [];

  final int id;

  final SaleType type;

  final DateTime createdAt;

  final List<InvoiceItem> items;

  final List<Payment> payments;

  final int? tableNumber;

  final int? accountId;

  final String? customerName;

  final String? customerPhone;

  final String? deliveryAddress;

  final String? deliveryReference;

  final double deliveryFee;

  final double taxRate;

  bool isClosed;

  double get subtotal {
    return items.fold<double>(0, (sum, item) => sum + item.total);
  }

  double get tax {
    return subtotal * taxRate;
  }

  double get total {
    return subtotal + tax + deliveryFee;
  }

  double get amountPaid {
    return payments.fold<double>(0, (sum, payment) => sum + payment.amount);
  }

  double get balance {
    return total - amountPaid;
  }

  bool get isPaid {
    return balance <= 0;
  }
}
