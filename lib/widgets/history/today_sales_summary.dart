import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/currency_formatter.dart';
import '../../models/sale.dart';

class TodaySalesSummary extends StatelessWidget {
  const TodaySalesSummary({super.key, required this.sales});

  final List<Sale> sales;

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();

    final todaySales = sales.where((sale) {
      final date = sale.createdAt;

      return date.year == today.year &&
          date.month == today.month &&
          date.day == today.day;
    }).toList();

    final totalToday = todaySales.fold<double>(
      0,
      (sum, sale) => sum + sale.total,
    );

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
          const Text(
            'VENTAS DE HOY',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _SummaryValue(
                  icon: Icons.receipt_long_outlined,
                  label: 'Ventas',
                  value: '${todaySales.length}',
                ),
              ),
              Container(width: 1, height: 42, color: AppColors.border),
              Expanded(
                child: _SummaryValue(
                  icon: Icons.payments_outlined,
                  label: 'Total',
                  value: CurrencyFormatter.format(totalToday),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryValue extends StatelessWidget {
  const _SummaryValue({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppColors.goldLight, size: 22),
        const SizedBox(height: 6),
        Text(
          value,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
        ),
      ],
    );
  }
}
