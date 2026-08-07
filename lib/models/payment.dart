import 'payment_method.dart';

class Payment {
  const Payment({
    required this.method,
    required this.amount,
    this.receivedAmount,
    this.reference,
  });

  /// Monto realmente aplicado a la venta.
  final double amount;

  /// Monto entregado por el cliente.
  /// Principalmente útil para pagos en efectivo.
  final double? receivedAmount;

  final PaymentMethod method;

  final String? reference;

  double get change {
    final received = receivedAmount ?? amount;

    if (received <= amount) {
      return 0;
    }

    return received - amount;
  }
}
