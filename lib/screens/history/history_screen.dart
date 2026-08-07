import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/currency_formatter.dart';
import '../../models/payment_method.dart';
import '../../models/sale.dart';
import '../../services/service_locator.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    final sales = Services.sales.sales.reversed.toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Historial de ventas')),
      body: sales.isEmpty ? _buildEmptyHistory() : _buildSalesList(sales),
    );
  }

  Widget _buildEmptyHistory() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 64,
              color: AppColors.textSecondary,
            ),
            SizedBox(height: 16),
            Text(
              'No hay ventas registradas',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Las ventas completadas aparecerán aquí.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSalesList(List<Sale> sales) {
    return ListView.separated(
      padding: const EdgeInsets.all(14),
      itemCount: sales.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final sale = sales[index];

        return _SaleHistoryCard(sale: sale);
      },
    );
  }
}

class _SaleHistoryCard extends StatelessWidget {
  const _SaleHistoryCard({required this.sale});

  final Sale sale;

  @override
  Widget build(BuildContext context) {
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
                  'Venta #${sale.id}',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                CurrencyFormatter.format(sale.total),
                style: const TextStyle(
                  color: AppColors.goldLight,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              const Icon(
                Icons.table_restaurant_outlined,
                size: 18,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _saleLocation,
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
              ),
            ],
          ),

          if (sale.customerName != null &&
              sale.customerName!.trim().isNotEmpty) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.person_outline,
                  size: 18,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    sale.customerName!,
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                ),
              ],
            ),
          ],

          const SizedBox(height: 8),

          Row(
            children: [
              const Icon(
                Icons.schedule,
                size: 18,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _formatDateTime(sale.createdAt),
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 8),

          Row(
            children: [
              Icon(_paymentIcon, size: 20, color: AppColors.goldLight),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _paymentName,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              _StatusBadge(isClosed: sale.isClosed),
            ],
          ),
        ],
      ),
    );
  }

  String get _saleLocation {
    if (sale.tableNumber != null) {
      return 'Mesa ${sale.tableNumber}';
    }

    switch (sale.type.name) {
      case 'quickSale':
        return 'Venta rápida';
      case 'takeaway':
        return 'Para llevar';
      case 'delivery':
        return 'Delivery';
      default:
        return 'Venta';
    }
  }

  PaymentMethod? get _paymentMethod {
    if (sale.payments.isEmpty) {
      return null;
    }

    return sale.payments.first.method;
  }

  String get _paymentName {
    switch (_paymentMethod) {
      case PaymentMethod.cash:
        return 'EFECTIVO';
      case PaymentMethod.card:
        return 'TARJETA';
      case PaymentMethod.transfer:
        return 'TRANSFERENCIA';
      case null:
        return 'SIN PAGO';
    }
  }

  IconData get _paymentIcon {
    switch (_paymentMethod) {
      case PaymentMethod.cash:
        return Icons.payments_outlined;
      case PaymentMethod.card:
        return Icons.credit_card;
      case PaymentMethod.transfer:
        return Icons.account_balance_outlined;
      case null:
        return Icons.help_outline;
    }
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
