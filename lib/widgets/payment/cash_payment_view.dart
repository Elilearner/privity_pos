import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/currency_formatter.dart';

class CashPaymentView extends StatefulWidget {
  const CashPaymentView({
    super.key,
    required this.total,
    required this.onConfirm,
  });

  final double total;
  final ValueChanged<double> onConfirm;

  @override
  State<CashPaymentView> createState() => _CashPaymentViewState();
}

class _CashPaymentViewState extends State<CashPaymentView> {
  final TextEditingController _receivedController = TextEditingController();

  double received = 0;

  double get change {
    if (received <= widget.total) {
      return 0;
    }

    return received - widget.total;
  }

  bool get canConfirm {
    return received >= widget.total;
  }

  @override
  void dispose() {
    _receivedController.dispose();
    super.dispose();
  }

  void _updateReceived(double amount) {
    setState(() {
      received = amount;

      _receivedController.text = amount.toStringAsFixed(
        amount.truncateToDouble() == amount ? 0 : 2,
      );

      _receivedController.selection = TextSelection.fromPosition(
        TextPosition(offset: _receivedController.text.length),
      );
    });
  }

  void _handleManualAmount(String value) {
    final cleanValue = value.replaceAll(',', '').trim();

    final amount = double.tryParse(cleanValue) ?? 0;

    setState(() {
      received = amount;
    });
  }

  double _roundUpTo(double value, int multiple) {
    final result = (value / multiple).ceil() * multiple;

    return result.toDouble();
  }

  List<double> get _quickAmounts {
    final amounts = <double>{
      widget.total,
      _roundUpTo(widget.total, 500),
      _roundUpTo(widget.total, 1000),
      _roundUpTo(widget.total, 5000),
      _roundUpTo(widget.total, 10000),
    }.toList();

    amounts.sort();

    return amounts;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'PAGO EN EFECTIVO',
          style: TextStyle(
            color: AppColors.goldLight,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 18),

        const Text(
          'MONTO RECIBIDO',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 8),

        TextFormField(
          controller: _receivedController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            hintText: '0',
            prefixIcon: Icon(Icons.payments_outlined),
          ),
          onChanged: _handleManualAmount,
        ),

        const SizedBox(height: 18),

        const Text(
          'MONTOS RÁPIDOS',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 10),

        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            OutlinedButton.icon(
              onPressed: () {
                FocusScope.of(context).unfocus();

                _updateReceived(widget.total);
              },
              icon: const Icon(Icons.price_check_outlined, size: 18),
              label: const Text('EXACTO'),
            ),

            ..._quickAmounts
                .where((amount) => amount != widget.total)
                .map(
                  (amount) => _QuickAmountButton(
                    amount: amount,
                    onPressed: _updateReceived,
                  ),
                ),
          ],
        ),

        const SizedBox(height: 22),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              _CashSummaryRow(
                label: 'Total',
                value: CurrencyFormatter.format(widget.total),
              ),

              const SizedBox(height: 8),

              _CashSummaryRow(
                label: 'Recibido',
                value: CurrencyFormatter.format(received),
              ),

              const Divider(height: 24),

              _CashSummaryRow(
                label: 'Cambio',
                value: CurrencyFormatter.format(change),
                highlight: true,
              ),
            ],
          ),
        ),

        const SizedBox(height: 18),

        SizedBox(
          height: 52,
          child: FilledButton.icon(
            onPressed: canConfirm
                ? () {
                    FocusScope.of(context).unfocus();

                    widget.onConfirm(received);
                  }
                : null,
            icon: const Icon(Icons.check_circle_outline),
            label: const Text('CONFIRMAR PAGO'),
          ),
        ),
      ],
    );
  }
}

class _QuickAmountButton extends StatelessWidget {
  const _QuickAmountButton({required this.amount, required this.onPressed});

  final double amount;
  final ValueChanged<double> onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        FocusScope.of(context).unfocus();

        onPressed(amount);
      },
      child: Text(CurrencyFormatter.format(amount)),
    );
  }
}

class _CashSummaryRow extends StatelessWidget {
  const _CashSummaryRow({
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
        Text(
          value,
          style: TextStyle(
            color: highlight ? AppColors.goldLight : AppColors.textPrimary,
            fontSize: highlight ? 20 : 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
