import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/business_config.dart';
import '../../core/currency_formatter.dart';
import '../../models/table_account.dart';
import '../../services/service_locator.dart';
import '../../widgets/payment/cash_payment_view.dart';
import '../../widgets/payment/payment_method_card.dart';

enum _SelectedPaymentMethod { cash, card, transfer, mixed }

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key, required this.account});

  final TableAccount account;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  _SelectedPaymentMethod? selectedMethod;

  TableAccount get account => widget.account;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cobrar - ${account.customerName}')),
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: EdgeInsets.fromLTRB(
            14,
            14,
            14,
            14 + MediaQuery.viewInsetsOf(context).bottom,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _TotalCard(total: account.subtotal),

              const SizedBox(height: 20),

              if (selectedMethod == null)
                _buildPaymentMethods()
              else
                _buildSelectedMethod(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentMethods() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'SELECCIONA EL MÉTODO DE PAGO',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 12),

        if (BusinessConfig.enableCashPayment) ...[
          PaymentMethodCard(
            icon: Icons.payments_outlined,
            title: 'EFECTIVO',
            subtitle: 'Cobro en efectivo y cálculo de cambio',
            onTap: () {
              setState(() {
                selectedMethod = _SelectedPaymentMethod.cash;
              });
            },
          ),
          const SizedBox(height: 10),
        ],

        if (BusinessConfig.enableCardPayment) ...[
          PaymentMethodCard(
            icon: Icons.credit_card,
            title: 'TARJETA',
            subtitle: 'Pago con tarjeta',
            onTap: () {
              setState(() {
                selectedMethod = _SelectedPaymentMethod.card;
              });
            },
          ),
          const SizedBox(height: 10),
        ],

        if (BusinessConfig.enableTransferPayment) ...[
          PaymentMethodCard(
            icon: Icons.account_balance_outlined,
            title: 'TRANSFERENCIA',
            subtitle: 'Transferencia bancaria',
            onTap: () {
              setState(() {
                selectedMethod = _SelectedPaymentMethod.transfer;
              });
            },
          ),
          const SizedBox(height: 10),
        ],

        if (BusinessConfig.enableMixedPayment)
          PaymentMethodCard(
            icon: Icons.call_split,
            title: 'PAGO MIXTO',
            subtitle: 'Combinar varios métodos de pago',
            onTap: () {
              setState(() {
                selectedMethod = _SelectedPaymentMethod.mixed;
              });
            },
          ),
      ],
    );
  }

  Widget _buildSelectedMethod() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: () {
              FocusScope.of(context).unfocus();

              setState(() {
                selectedMethod = null;
              });
            },
            icon: const Icon(Icons.arrow_back),
            label: const Text('CAMBIAR MÉTODO'),
          ),
        ),

        const SizedBox(height: 6),

        _buildSelectedPaymentView(),
      ],
    );
  }

  Widget _buildSelectedPaymentView() {
    switch (selectedMethod) {
      case _SelectedPaymentMethod.cash:
        return CashPaymentView(
          total: account.subtotal,
          onConfirm: (received) {
            _confirmCashPayment(received);
          },
        );

      case _SelectedPaymentMethod.card:
        return const _PaymentComingSoon(
          icon: Icons.credit_card,
          title: 'PAGO CON TARJETA',
          message:
              'El formulario de tarjeta '
              'será implementado en el '
              'próximo módulo.',
        );

      case _SelectedPaymentMethod.transfer:
        return const _PaymentComingSoon(
          icon: Icons.account_balance_outlined,
          title: 'PAGO POR TRANSFERENCIA',
          message:
              'El formulario de transferencia '
              'será implementado próximamente.',
        );

      case _SelectedPaymentMethod.mixed:
        return const _PaymentComingSoon(
          icon: Icons.call_split,
          title: 'PAGO MIXTO',
          message:
              'Aquí podrás combinar efectivo, '
              'tarjeta y transferencia.',
        );

      case null:
        return const SizedBox.shrink();
    }
  }

  void _confirmCashPayment(double receivedAmount) {
    final sale = Services.sales.closeTableSaleWithCash(
      account: account,
      receivedAmount: receivedAmount,
    );

    if (sale == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo completar el pago.')),
      );

      return;
    }

    final change = receivedAmount - sale.total;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Pago completado. '
          'Cambio: ${CurrencyFormatter.format(change)}',
        ),
      ),
    );

    Navigator.pop(context, true);
  }
}

class _TotalCard extends StatelessWidget {
  const _TotalCard({required this.total});

  final double total;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          const Text(
            'TOTAL A PAGAR',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            CurrencyFormatter.format(total),
            style: const TextStyle(
              color: AppColors.goldLight,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentComingSoon extends StatelessWidget {
  const _PaymentComingSoon({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.goldLight, size: 36),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
