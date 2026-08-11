import 'payment_method.dart';

class Payment {
  const Payment({
    required this.method,
    required this.amount,
    this.receivedAmount,
    this.reference,
  });

  /// Método utilizado para realizar el pago.
  final PaymentMethod method;

  /// Monto realmente aplicado a la venta.
  final double amount;

  /// Monto entregado por el cliente.
  ///
  /// Se utiliza principalmente para pagos en efectivo
  /// para poder calcular el cambio.
  final double? receivedAmount;

  /// Número o código de referencia del pago.
  ///
  /// Puede utilizarse para pagos con tarjeta
  /// o transferencia.
  final String? reference;

  /// Cambio que debe devolverse al cliente.
  ///
  /// Para tarjeta y transferencia normalmente será 0.
  double get change {
    final received = receivedAmount ?? amount;

    if (received <= amount) {
      return 0;
    }

    return received - amount;
  }
}
