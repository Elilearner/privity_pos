import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

import '../core/business_config.dart';
import '../core/currency_formatter.dart';
import '../models/payment.dart';
import '../models/payment_method.dart';
import '../models/sale.dart';
import '../models/sale_type.dart';

enum PrinterPaperSize { mm58, mm80 }

class PrinterService {
  PrinterService._();

  static final PrinterService instance = PrinterService._();

  String? _printerName;
  String? _printerMacAddress;

  PrinterPaperSize _paperSize = PrinterPaperSize.mm80;

  String? get printerName => _printerName;

  String? get printerMacAddress => _printerMacAddress;

  PrinterPaperSize get paperSize => _paperSize;

  bool get hasSelectedPrinter {
    return _printerMacAddress != null && _printerMacAddress!.trim().isNotEmpty;
  }

  void setPaperSize(PrinterPaperSize value) {
    _paperSize = value;
  }

  void selectPrinter({required String name, required String macAddress}) {
    _printerName = name.trim().isEmpty ? macAddress : name.trim();

    _printerMacAddress = macAddress.trim();
  }

  void clearPrinter() {
    _printerName = null;
    _printerMacAddress = null;
  }

  Future<bool> connect() async {
    if (!hasSelectedPrinter) {
      return false;
    }

    try {
      final connected = await PrintBluetoothThermal.connectionStatus;

      if (connected) {
        return true;
      }

      return await PrintBluetoothThermal.connect(
        macPrinterAddress: _printerMacAddress!,
      );
    } catch (_) {
      return false;
    }
  }

  Future<void> disconnect() async {
    try {
      await PrintBluetoothThermal.disconnect;
    } catch (_) {
      // No hacemos nada si no había conexión activa.
    }
  }

  Future<bool> printTest() async {
    final connected = await connect();

    if (!connected) {
      return false;
    }

    final bytes = await _buildTestTicket();

    try {
      return await PrintBluetoothThermal.writeBytes(bytes);
    } catch (_) {
      return false;
    }
  }

  Future<bool> printSale(Sale sale) async {
    final connected = await connect();

    if (!connected) {
      return false;
    }

    final bytes = await buildSaleTicket(sale);

    try {
      return await PrintBluetoothThermal.writeBytes(bytes);
    } catch (_) {
      return false;
    }
  }

  Future<List<int>> buildSaleTicket(Sale sale) async {
    final profile = await CapabilityProfile.load();

    final generator = Generator(_escPosPaperSize, profile);

    final bytes = <int>[];

    bytes.addAll(
      generator.text(
        BusinessConfig.businessName,
        styles: const PosStyles(
          align: PosAlign.center,
          bold: true,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ),
      ),
    );

    bytes.addAll(
      generator.text(
        'FACTURA #${sale.id}',
        styles: const PosStyles(align: PosAlign.center, bold: true),
      ),
    );

    bytes.addAll(
      generator.text(
        _formatDateTime(sale.createdAt),
        styles: const PosStyles(align: PosAlign.center),
      ),
    );

    bytes.addAll(generator.hr());

    bytes.addAll(generator.text('Tipo: ${_saleTypeName(sale)}'));

    if (sale.tableNumber != null) {
      bytes.addAll(generator.text('Mesa: ${sale.tableNumber}'));
    }

    if (_hasText(sale.customerName)) {
      bytes.addAll(generator.text('Cliente: ${sale.customerName}'));
    }

    if (sale.type == SaleType.delivery) {
      if (_hasText(sale.customerPhone)) {
        bytes.addAll(generator.text('Telefono: ${sale.customerPhone}'));
      }

      if (_hasText(sale.deliveryAddress)) {
        bytes.addAll(generator.text('Direccion: ${sale.deliveryAddress}'));
      }

      if (_hasText(sale.deliveryReference)) {
        bytes.addAll(generator.text('Referencia: ${sale.deliveryReference}'));
      }
    }

    bytes.addAll(generator.hr());

    bytes.addAll(
      generator.row([
        PosColumn(text: 'Cant', width: 2, styles: const PosStyles(bold: true)),
        PosColumn(
          text: 'Producto',
          width: 6,
          styles: const PosStyles(bold: true),
        ),
        PosColumn(
          text: 'Total',
          width: 4,
          styles: const PosStyles(bold: true, align: PosAlign.right),
        ),
      ]),
    );

    for (final item in sale.items) {
      bytes.addAll(
        generator.row([
          PosColumn(text: '${item.quantity}', width: 2),
          PosColumn(text: item.product.name, width: 6),
          PosColumn(
            text: CurrencyFormatter.format(item.total),
            width: 4,
            styles: const PosStyles(align: PosAlign.right),
          ),
        ]),
      );

      bytes.addAll(
        generator.text(
          '  ${item.quantity} x '
          '${CurrencyFormatter.format(item.unitPrice)}',
          styles: const PosStyles(align: PosAlign.left),
        ),
      );
    }

    bytes.addAll(generator.hr());

    bytes.addAll(_totalRow(generator, 'Subtotal', sale.subtotal));

    if (sale.tax > 0) {
      bytes.addAll(_totalRow(generator, 'Impuestos', sale.tax));
    }

    if (sale.deliveryFee > 0) {
      bytes.addAll(_totalRow(generator, 'Delivery', sale.deliveryFee));
    }

    bytes.addAll(generator.hr());

    bytes.addAll(
      generator.row([
        PosColumn(
          text: 'TOTAL',
          width: 6,
          styles: const PosStyles(bold: true, height: PosTextSize.size2),
        ),
        PosColumn(
          text: CurrencyFormatter.format(sale.total),
          width: 6,
          styles: const PosStyles(
            bold: true,
            align: PosAlign.right,
            height: PosTextSize.size2,
          ),
        ),
      ]),
    );

    bytes.addAll(generator.hr());

    if (sale.payments.length > 1) {
      bytes.addAll(
        generator.text('PAGO MIXTO', styles: const PosStyles(bold: true)),
      );
    }

    for (final payment in sale.payments) {
      bytes.addAll(_paymentLines(generator, payment));
    }

    bytes.addAll(generator.feed(1));

    bytes.addAll(
      generator.text(
        'Gracias por su compra',
        styles: const PosStyles(align: PosAlign.center, bold: true),
      ),
    );

    bytes.addAll(generator.feed(3));

    return bytes;
  }

  Future<List<int>> _buildTestTicket() async {
    final profile = await CapabilityProfile.load();

    final generator = Generator(_escPosPaperSize, profile);

    final bytes = <int>[];

    bytes.addAll(
      generator.text(
        BusinessConfig.businessName,
        styles: const PosStyles(
          align: PosAlign.center,
          bold: true,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ),
      ),
    );

    bytes.addAll(
      generator.text(
        'PRUEBA DE IMPRESION',
        styles: const PosStyles(align: PosAlign.center, bold: true),
      ),
    );

    bytes.addAll(generator.hr());

    bytes.addAll(
      generator.text(
        'Impresora configurada correctamente.',
        styles: const PosStyles(align: PosAlign.center),
      ),
    );

    bytes.addAll(
      generator.text(
        'Papel: ${_paperSize == PrinterPaperSize.mm80 ? '80 mm' : '58 mm'}',
        styles: const PosStyles(align: PosAlign.center),
      ),
    );

    bytes.addAll(generator.feed(3));

    return bytes;
  }

  List<int> _totalRow(Generator generator, String label, double value) {
    return generator.row([
      PosColumn(text: label, width: 6),
      PosColumn(
        text: CurrencyFormatter.format(value),
        width: 6,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);
  }

  List<int> _paymentLines(Generator generator, Payment payment) {
    final bytes = <int>[];

    bytes.addAll(
      generator.row([
        PosColumn(text: _paymentName(payment.method), width: 6),
        PosColumn(
          text: CurrencyFormatter.format(payment.amount),
          width: 6,
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]),
    );

    if (payment.receivedAmount != null) {
      bytes.addAll(
        generator.text(
          'Recibido: '
          '${CurrencyFormatter.format(payment.receivedAmount!)}',
        ),
      );

      bytes.addAll(
        generator.text(
          'Cambio: '
          '${CurrencyFormatter.format(payment.change)}',
        ),
      );
    }

    if (_hasText(payment.reference)) {
      bytes.addAll(generator.text('Referencia: ${payment.reference}'));
    }

    return bytes;
  }

  PaperSize get _escPosPaperSize {
    switch (_paperSize) {
      case PrinterPaperSize.mm58:
        return PaperSize.mm58;

      case PrinterPaperSize.mm80:
        return PaperSize.mm80;
    }
  }

  String _saleTypeName(Sale sale) {
    switch (sale.type) {
      case SaleType.table:
        return 'Mesa';

      case SaleType.bar:
        return 'Barra';

      case SaleType.quickSale:
        return 'Venta rapida';

      case SaleType.takeaway:
        return 'Para llevar';

      case SaleType.delivery:
        return 'Delivery';
    }
  }

  String _paymentName(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.cash:
        return 'EFECTIVO';

      case PaymentMethod.card:
        return 'TARJETA';

      case PaymentMethod.transfer:
        return 'TRANSFERENCIA';
    }
  }

  bool _hasText(String? value) {
    return value != null && value.trim().isNotEmpty;
  }

  String _formatDateTime(DateTime dateTime) {
    final day = dateTime.day.toString().padLeft(2, '0');

    final month = dateTime.month.toString().padLeft(2, '0');

    final year = dateTime.year;

    var hour = dateTime.hour;

    final minute = dateTime.minute.toString().padLeft(2, '0');

    final period = hour >= 12 ? 'PM' : 'AM';

    if (hour == 0) {
      hour = 12;
    } else if (hour > 12) {
      hour -= 12;
    }

    return '$day/$month/$year '
        '$hour:$minute $period';
  }
}
