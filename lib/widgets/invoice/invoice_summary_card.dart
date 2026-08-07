import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/currency_formatter.dart';

class InvoiceSummaryCard extends StatelessWidget {
  const InvoiceSummaryCard({
    super.key,
    required this.totalItems,
    required this.subtotal,
    this.discount = 0,
    this.tax = 0,
  });

  final int totalItems;
  final double subtotal;
  final double discount;
  final double tax;

  double get total {
    return subtotal - discount + tax;
  }

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
        children: [
          const Text(
            'RESUMEN DE LA VENTA',
            style: TextStyle(
              color: AppColors.goldLight,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          _SummaryRow(title: 'Artículos', value: '$totalItems'),
          const SizedBox(height: 8),
          _SummaryRow(
            title: 'Subtotal',
            value: CurrencyFormatter.format(subtotal),
          ),
          const SizedBox(height: 8),
          _SummaryRow(
            title: 'Descuento',
            value: CurrencyFormatter.format(discount),
          ),
          const SizedBox(height: 8),
          _SummaryRow(title: 'ITBIS', value: CurrencyFormatter.format(tax)),
          const Divider(height: 28),
          _SummaryRow(
            title: 'TOTAL',
            value: CurrencyFormatter.format(total),
            isTotal: true,
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.title,
    required this.value,
    this.isTotal = false,
  });

  final String title;
  final String value;
  final bool isTotal;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: isTotal ? AppColors.textPrimary : AppColors.textSecondary,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 18 : 15,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: isTotal ? AppColors.goldLight : AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: isTotal ? 20 : 15,
          ),
        ),
      ],
    );
  }
}
