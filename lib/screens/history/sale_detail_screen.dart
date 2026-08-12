import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/business_config.dart';
import '../../core/currency_formatter.dart';
import '../../models/payment.dart';
import '../../models/payment_method.dart';
import '../../models/sale.dart';
import '../../models/sale_type.dart';
import '../../services/service_locator.dart';

class SaleDetailScreen extends StatelessWidget {
  const SaleDetailScreen({super.key, required this.sale});

  final Sale sale;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Venta #${sale.id}'),
        actions: [
          IconButton(
            tooltip: 'Imprimir factura',
            onPressed: () {
              _printSale(context);
            },
            icon: const Icon(Icons.print_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          _buildBusinessHeader(),

          const SizedBox(height: 14),

          _buildSaleHeader(),

          if (sale.type == SaleType.delivery) ...[
            const SizedBox(height: 20),
            const _SectionTitle(title: 'DATOS DE ENTREGA'),
            const SizedBox(height: 10),
            _buildDeliveryCard(),
          ],

          const SizedBox(height: 20),

          const _SectionTitle(title: 'PRODUCTOS'),

          const SizedBox(height: 10),

          _buildProductsCard(),

          const SizedBox(height: 20),

          const _SectionTitle(title: 'RESUMEN'),

          const SizedBox(height: 10),

          _buildSummaryCard(),

          const SizedBox(height: 20),

          const _SectionTitle(title: 'PAGO'),

          const SizedBox(height: 10),

          _buildPaymentCard(),

          const SizedBox(height: 18),

          SizedBox(
            height: 50,
            child: FilledButton.icon(
              onPressed: () {
                _printSale(context);
              },
              icon: const Icon(Icons.print_outlined),
              label: const Text('IMPRIMIR FACTURA'),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildBusinessHeader() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.goldLight),
      ),
      child: const Column(
        children: [
          Text(
            BusinessConfig.businessName,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.goldLight,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          Text(
            'DETALLE DE FACTURA',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaleHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Factura #${sale.id}',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _StatusBadge(isClosed: sale.isClosed),
            ],
          ),

          const SizedBox(height: 14),

          _InfoRow(icon: _saleTypeIcon, text: _saleTypeName),

          if (sale.tableNumber != null) ...[
            const SizedBox(height: 8),
            _InfoRow(
              icon: Icons.table_restaurant_outlined,
              text: 'Mesa ${sale.tableNumber}',
            ),
          ],

          if (_hasText(sale.customerName)) ...[
            const SizedBox(height: 8),
            _InfoRow(icon: Icons.person_outline, text: sale.customerName!),
          ],

          const SizedBox(height: 8),

          _InfoRow(icon: Icons.schedule, text: _formatDateTime(sale.createdAt)),
        ],
      ),
    );
  }

  Widget _buildDeliveryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          if (_hasText(sale.customerPhone))
            _InfoRow(icon: Icons.phone_outlined, text: sale.customerPhone!),

          if (_hasText(sale.customerPhone) && _hasText(sale.deliveryAddress))
            const SizedBox(height: 10),

          if (_hasText(sale.deliveryAddress))
            _InfoRow(
              icon: Icons.location_on_outlined,
              text: sale.deliveryAddress!,
            ),

          if (_hasText(sale.deliveryReference)) ...[
            const SizedBox(height: 10),
            _InfoRow(
              icon: Icons.place_outlined,
              text: 'Referencia: ${sale.deliveryReference}',
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildProductsCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          for (int index = 0; index < sale.items.length; index++) ...[
            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          sale.items[index].product.name,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '${sale.items[index].quantity} × '
                          '${CurrencyFormatter.format(sale.items[index].unitPrice)}',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 12),

                  Text(
                    CurrencyFormatter.format(sale.items[index].total),
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            if (index < sale.items.length - 1) const Divider(height: 1),
          ],
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    final productCount = sale.items.fold<int>(
      0,
      (sum, item) => sum + item.quantity,
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _SummaryRow(label: 'Productos', value: '$productCount'),

          const SizedBox(height: 10),

          _SummaryRow(
            label: 'Subtotal',
            value: CurrencyFormatter.format(sale.subtotal),
          ),

          if (sale.tax > 0) ...[
            const SizedBox(height: 10),
            _SummaryRow(
              label: 'Impuestos',
              value: CurrencyFormatter.format(sale.tax),
            ),
          ],

          if (sale.deliveryFee > 0) ...[
            const SizedBox(height: 10),
            _SummaryRow(
              label: 'Delivery',
              value: CurrencyFormatter.format(sale.deliveryFee),
            ),
          ],

          const Divider(height: 26),

          _SummaryRow(
            label: 'TOTAL',
            value: CurrencyFormatter.format(sale.total),
            highlight: true,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentCard() {
    if (sale.payments.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: const Text(
          'No hay pagos registrados.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          if (sale.payments.length > 1) ...[
            const _SummaryRow(
              label: 'Tipo de pago',
              value: 'PAGO MIXTO',
              highlight: true,
            ),
            const Divider(height: 26),
          ],

          for (int index = 0; index < sale.payments.length; index++) ...[
            _PaymentDetails(payment: sale.payments[index]),

            if (index < sale.payments.length - 1) const Divider(height: 26),
          ],

          const Divider(height: 26),

          _SummaryRow(
            label: 'Total pagado',
            value: CurrencyFormatter.format(sale.amountPaid),
          ),
        ],
      ),
    );
  }

  IconData get _saleTypeIcon {
    switch (sale.type) {
      case SaleType.table:
        return Icons.table_restaurant_outlined;

      case SaleType.quickSale:
        return Icons.point_of_sale_outlined;

      case SaleType.takeaway:
        return Icons.shopping_bag_outlined;

      case SaleType.delivery:
        return Icons.delivery_dining;
    }
  }

  String get _saleTypeName {
    switch (sale.type) {
      case SaleType.table:
        return 'Venta en mesa';

      case SaleType.quickSale:
        return 'Venta rápida';

      case SaleType.takeaway:
        return 'Para llevar';

      case SaleType.delivery:
        return 'Delivery';
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

    return '$day/$month/$year · '
        '$hour:$minute $period';
  }

  Future<void> _printSale(BuildContext context) async {
    if (!Services.printer.hasSelectedPrinter) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'No hay una impresora configurada. '
            'Ve a Ajustes para seleccionar una.',
          ),
        ),
      );

      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Conectando con la impresora...'),
        duration: Duration(seconds: 1),
      ),
    );

    final printed = await Services.printer.printSale(sale);

    if (!context.mounted) {
      return;
    }

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    if (printed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Factura enviada correctamente '
            'a la impresora.',
          ),
        ),
      );

      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'No se pudo imprimir la factura. '
          'Verifica que la impresora esté '
          'encendida, emparejada y disponible.',
        ),
      ),
    );
  }
}

class _PaymentDetails extends StatelessWidget {
  const _PaymentDetails({required this.payment});

  final Payment payment;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SummaryRow(label: 'Método', value: _paymentName),

        const SizedBox(height: 10),

        _SummaryRow(
          label: 'Pagado',
          value: CurrencyFormatter.format(payment.amount),
        ),

        if (payment.receivedAmount != null) ...[
          const SizedBox(height: 10),

          _SummaryRow(
            label: 'Recibido',
            value: CurrencyFormatter.format(payment.receivedAmount!),
          ),

          const SizedBox(height: 10),

          _SummaryRow(
            label: 'Cambio',
            value: CurrencyFormatter.format(payment.change),
            highlight: true,
          ),
        ],

        if (payment.reference != null &&
            payment.reference!.trim().isNotEmpty) ...[
          const SizedBox(height: 10),

          _SummaryRow(label: 'Referencia', value: payment.reference!),
        ],
      ],
    );
  }

  String get _paymentName {
    switch (payment.method) {
      case PaymentMethod.cash:
        return 'EFECTIVO';

      case PaymentMethod.card:
        return 'TARJETA';

      case PaymentMethod.transfer:
        return 'TRANSFERENCIA';
    }
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: AppColors.textSecondary,
        fontSize: 13,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColors.textSecondary),

        const SizedBox(width: 8),

        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: AppColors.textSecondary),
          ),
        ),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  final String label;
  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: highlight
                  ? AppColors.textPrimary
                  : AppColors.textSecondary,
              fontWeight: highlight ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),

        const SizedBox(width: 12),

        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: highlight ? AppColors.goldLight : AppColors.textPrimary,
              fontSize: highlight ? 18 : 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.isClosed});

  final bool isClosed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isClosed
            ? AppColors.goldLight.withValues(alpha: 0.12)
            : AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isClosed ? AppColors.goldLight : AppColors.border,
        ),
      ),
      child: Text(
        isClosed ? 'PAGADA' : 'ABIERTA',
        style: TextStyle(
          color: isClosed ? AppColors.goldLight : AppColors.textSecondary,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
