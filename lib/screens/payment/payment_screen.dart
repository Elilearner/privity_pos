import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/business_config.dart';
import '../../core/currency_formatter.dart';
import '../../models/payment.dart';
import '../../models/payment_method.dart';
import '../../models/sale_draft.dart';
import '../../models/sale_type.dart';
import '../../models/table_account.dart';
import '../../services/service_locator.dart';
import '../../widgets/payment/cash_payment_view.dart';
import '../../widgets/payment/payment_method_card.dart';

enum _SelectedPaymentMethod { cash, card, transfer, mixed }

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key, this.account, this.draft})
    : assert(
        account != null || draft != null,
        'PaymentScreen necesita una cuenta o una venta.',
      ),
      assert(
        account == null || draft == null,
        'PaymentScreen solo puede recibir una cuenta o una venta.',
      );

  final TableAccount? account;
  final SaleDraft? draft;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  _SelectedPaymentMethod? selectedMethod;

  final TextEditingController _cardReferenceController =
      TextEditingController();

  final TextEditingController _transferReferenceController =
      TextEditingController();

  final TextEditingController _mixedCashController = TextEditingController();

  final TextEditingController _mixedCardController = TextEditingController();

  final TextEditingController _mixedTransferController =
      TextEditingController();

  final TextEditingController _mixedCardReferenceController =
      TextEditingController();

  final TextEditingController _mixedTransferReferenceController =
      TextEditingController();

  bool _processingPayment = false;

  bool get _isTableSale => widget.account != null;

  double get _total {
    if (widget.account != null) {
      return widget.account!.subtotal;
    }

    return widget.draft!.total;
  }

  String get _screenTitle {
    if (widget.account != null) {
      return 'Cobrar - ${widget.account!.customerName}';
    }

    switch (widget.draft!.type) {
      case SaleType.quickSale:
        return 'Cobrar - Venta rápida';

      case SaleType.takeaway:
        return 'Cobrar - Para llevar';

      case SaleType.delivery:
        return 'Cobrar - Delivery';

      case SaleType.table:
        return 'Cobrar';
    }
  }

  @override
  void dispose() {
    _cardReferenceController.dispose();
    _transferReferenceController.dispose();

    _mixedCashController.dispose();
    _mixedCardController.dispose();
    _mixedTransferController.dispose();

    _mixedCardReferenceController.dispose();
    _mixedTransferReferenceController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_screenTitle)),
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
              _TotalCard(total: _total),
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
            onPressed: _processingPayment
                ? null
                : () {
                    FocusScope.of(context).unfocus();

                    _clearPaymentFields();

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
        return CashPaymentView(total: _total, onConfirm: _confirmCashPayment);

      case _SelectedPaymentMethod.card:
        return _buildCardPaymentView();

      case _SelectedPaymentMethod.transfer:
        return _buildTransferPaymentView();

      case _SelectedPaymentMethod.mixed:
        return _buildMixedPaymentView();

      case null:
        return const SizedBox.shrink();
    }
  }

  Widget _buildCardPaymentView() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Icon(Icons.credit_card, color: AppColors.goldLight, size: 38),
          const SizedBox(height: 12),
          const Text(
            'PAGO CON TARJETA',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Monto: ${CurrencyFormatter.format(_total)}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.goldLight,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 18),
          TextField(
            controller: _cardReferenceController,
            enabled: !_processingPayment,
            decoration: const InputDecoration(
              labelText: 'Referencia',
              hintText: 'Opcional',
              prefixIcon: Icon(Icons.tag),
            ),
            textInputAction: TextInputAction.done,
            onSubmitted: (_) {
              if (!_processingPayment) {
                _confirmCardPayment();
              }
            },
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 50,
            child: FilledButton.icon(
              onPressed: _processingPayment ? null : _confirmCardPayment,
              icon: _processingPayment
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.check_circle_outline),
              label: Text(
                _processingPayment ? 'PROCESANDO...' : 'CONFIRMAR PAGO',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransferPaymentView() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Icon(
            Icons.account_balance_outlined,
            color: AppColors.goldLight,
            size: 38,
          ),
          const SizedBox(height: 12),
          const Text(
            'PAGO POR TRANSFERENCIA',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Monto: ${CurrencyFormatter.format(_total)}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.goldLight,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 18),
          TextField(
            controller: _transferReferenceController,
            enabled: !_processingPayment,
            decoration: const InputDecoration(
              labelText: 'Referencia de transferencia',
              hintText: 'Opcional',
              prefixIcon: Icon(Icons.tag),
            ),
            textInputAction: TextInputAction.done,
            onSubmitted: (_) {
              if (!_processingPayment) {
                _confirmTransferPayment();
              }
            },
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 50,
            child: FilledButton.icon(
              onPressed: _processingPayment ? null : _confirmTransferPayment,
              icon: _processingPayment
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.check_circle_outline),
              label: Text(
                _processingPayment
                    ? 'PROCESANDO...'
                    : 'CONFIRMAR TRANSFERENCIA',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMixedPaymentView() {
    final cash = _parseAmount(_mixedCashController.text) ?? 0;

    final card = _parseAmount(_mixedCardController.text) ?? 0;

    final transfer = _parseAmount(_mixedTransferController.text) ?? 0;

    final paid = cash + card + transfer;

    final remaining = _total - paid;

    final activeMethods = [
      cash,
      card,
      transfer,
    ].where((amount) => amount > 0).length;

    const tolerance = 0.01;

    final exactAmount = remaining.abs() <= tolerance;

    final canConfirm = exactAmount && activeMethods >= 2 && !_processingPayment;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Icon(Icons.call_split, color: AppColors.goldLight, size: 38),
          const SizedBox(height: 12),
          const Text(
            'PAGO MIXTO',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Total: ${CurrencyFormatter.format(_total)}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.goldLight,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),

          TextField(
            controller: _mixedCashController,
            enabled: !_processingPayment,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Efectivo',
              hintText: '0.00',
              prefixIcon: Icon(Icons.payments_outlined),
            ),
            onChanged: (_) {
              setState(() {});
            },
          ),

          const SizedBox(height: 12),

          TextField(
            controller: _mixedCardController,
            enabled: !_processingPayment,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Tarjeta',
              hintText: '0.00',
              prefixIcon: Icon(Icons.credit_card),
            ),
            onChanged: (_) {
              setState(() {});
            },
          ),

          const SizedBox(height: 8),

          TextField(
            controller: _mixedCardReferenceController,
            enabled: !_processingPayment && card > 0,
            decoration: const InputDecoration(
              labelText: 'Referencia de tarjeta',
              hintText: 'Opcional',
              prefixIcon: Icon(Icons.tag),
            ),
          ),

          const SizedBox(height: 12),

          TextField(
            controller: _mixedTransferController,
            enabled: !_processingPayment,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Transferencia',
              hintText: '0.00',
              prefixIcon: Icon(Icons.account_balance_outlined),
            ),
            onChanged: (_) {
              setState(() {});
            },
          ),

          const SizedBox(height: 8),

          TextField(
            controller: _mixedTransferReferenceController,
            enabled: !_processingPayment && transfer > 0,
            decoration: const InputDecoration(
              labelText: 'Referencia de transferencia',
              hintText: 'Opcional',
              prefixIcon: Icon(Icons.tag),
            ),
          ),

          const SizedBox(height: 18),

          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                _PaymentInfoRow(
                  label: 'Total pagado',
                  value: CurrencyFormatter.format(paid),
                ),
                const SizedBox(height: 8),
                _PaymentInfoRow(
                  label: remaining >= 0 ? 'Falta' : 'Excede',
                  value: CurrencyFormatter.format(remaining.abs()),
                ),
              ],
            ),
          ),

          if (activeMethods < 2) ...[
            const SizedBox(height: 10),
            const Text(
              'El pago mixto debe utilizar al menos dos métodos.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
            ),
          ],

          const SizedBox(height: 18),

          SizedBox(
            height: 50,
            child: FilledButton.icon(
              onPressed: canConfirm ? _confirmMixedPayment : null,
              icon: _processingPayment
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.check_circle_outline),
              label: Text(
                _processingPayment ? 'PROCESANDO...' : 'CONFIRMAR PAGO MIXTO',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmCashPayment(double receivedAmount) async {
    if (_processingPayment) {
      return;
    }

    setState(() {
      _processingPayment = true;
    });

    final sale = _isTableSale
        ? await Services.sales.closeTableSaleWithCash(
            account: widget.account!,
            receivedAmount: receivedAmount,
          )
        : await Services.sales.closeDraftSaleWithCash(
            draft: widget.draft!,
            receivedAmount: receivedAmount,
          );

    if (!mounted) {
      return;
    }

    if (sale == null) {
      setState(() {
        _processingPayment = false;
      });

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

    Navigator.of(context).pop(true);
  }

  Future<void> _confirmCardPayment() async {
    if (_processingPayment) {
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      _processingPayment = true;
    });

    final reference = _cardReferenceController.text.trim();

    final cleanReference = reference.isEmpty ? null : reference;

    final sale = _isTableSale
        ? await Services.sales.closeTableSaleWithCard(
            account: widget.account!,
            reference: cleanReference,
          )
        : await Services.sales.closeDraftSaleWithCard(
            draft: widget.draft!,
            reference: cleanReference,
          );

    if (!mounted) {
      return;
    }

    if (sale == null) {
      setState(() {
        _processingPayment = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudo completar el pago con tarjeta.'),
        ),
      );

      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pago con tarjeta completado.')),
    );

    Navigator.of(context).pop(true);
  }

  Future<void> _confirmTransferPayment() async {
    if (_processingPayment) {
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      _processingPayment = true;
    });

    final reference = _transferReferenceController.text.trim();

    final cleanReference = reference.isEmpty ? null : reference;

    final sale = _isTableSale
        ? await Services.sales.closeTableSaleWithTransfer(
            account: widget.account!,
            reference: cleanReference,
          )
        : await Services.sales.closeDraftSaleWithTransfer(
            draft: widget.draft!,
            reference: cleanReference,
          );

    if (!mounted) {
      return;
    }

    if (sale == null) {
      setState(() {
        _processingPayment = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo completar la transferencia.')),
      );

      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pago por transferencia completado.')),
    );

    Navigator.of(context).pop(true);
  }

  Future<void> _confirmMixedPayment() async {
    if (_processingPayment) {
      return;
    }

    FocusScope.of(context).unfocus();

    final cash = _parseAmount(_mixedCashController.text) ?? 0;

    final card = _parseAmount(_mixedCardController.text) ?? 0;

    final transfer = _parseAmount(_mixedTransferController.text) ?? 0;

    final payments = <Payment>[];

    if (cash > 0) {
      payments.add(
        Payment(method: PaymentMethod.cash, amount: cash, receivedAmount: cash),
      );
    }

    if (card > 0) {
      final reference = _mixedCardReferenceController.text.trim();

      payments.add(
        Payment(
          method: PaymentMethod.card,
          amount: card,
          reference: reference.isEmpty ? null : reference,
        ),
      );
    }

    if (transfer > 0) {
      final reference = _mixedTransferReferenceController.text.trim();

      payments.add(
        Payment(
          method: PaymentMethod.transfer,
          amount: transfer,
          reference: reference.isEmpty ? null : reference,
        ),
      );
    }

    if (payments.length < 2) {
      return;
    }

    setState(() {
      _processingPayment = true;
    });

    final sale = _isTableSale
        ? await Services.sales.closeTableSaleWithMixedPayments(
            account: widget.account!,
            payments: payments,
          )
        : await Services.sales.closeDraftSaleWithMixedPayments(
            draft: widget.draft!,
            payments: payments,
          );

    if (!mounted) {
      return;
    }

    if (sale == null) {
      setState(() {
        _processingPayment = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo completar el pago mixto.')),
      );

      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Pago mixto completado.')));

    Navigator.of(context).pop(true);
  }

  double? _parseAmount(String value) {
    final cleaned = value.replaceAll(',', '').trim();

    if (cleaned.isEmpty) {
      return null;
    }

    final amount = double.tryParse(cleaned);

    if (amount == null || amount < 0) {
      return null;
    }

    return amount;
  }

  void _clearPaymentFields() {
    _cardReferenceController.clear();
    _transferReferenceController.clear();

    _mixedCashController.clear();
    _mixedCardController.clear();
    _mixedTransferController.clear();

    _mixedCardReferenceController.clear();
    _mixedTransferReferenceController.clear();
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

class _PaymentInfoRow extends StatelessWidget {
  const _PaymentInfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
