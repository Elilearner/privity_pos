import 'payment_method.dart';

class Payment {
  const Payment({required this.method, required this.amount, this.reference});

  final PaymentMethod method;
  final double amount;
  final String? reference;
}
