import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/currency_formatter.dart';
import '../../models/cash_session.dart';
import '../../models/payment_method.dart';
import '../../models/sale.dart';
import '../../services/service_locator.dart';

class CashScreen extends StatefulWidget {
  const CashScreen({super.key});

  @override
  State<CashScreen> createState() => _CashScreenState();
}

class _CashScreenState extends State<CashScreen> {
  @override
  void initState() {
    super.initState();

    Services.sales.addListener(_onSalesChanged);
  }

  @override
  void dispose() {
    Services.sales.removeListener(_onSalesChanged);

    super.dispose();
  }

  void _onSalesChanged() {
    if (!mounted) {
      return;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final session = Services.cash.activeSession;

    return Scaffold(
      appBar: AppBar(title: const Text('Caja')),
      body: session == null ? _buildClosedCash() : _buildOpenCash(),
    );
  }

  Widget _buildClosedCash() {
    final lastSession = Services.cash.lastClosedSession;

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const SizedBox(height: 30),
        const Icon(
          Icons.point_of_sale_outlined,
          size: 72,
          color: AppColors.textSecondary,
        ),
        const SizedBox(height: 18),
        const Text(
          'CAJA CERRADA',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Abre la caja para comenzar una nueva jornada de ventas.',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
        ),
        const SizedBox(height: 24),
        SizedBox(
          height: 52,
          child: FilledButton.icon(
            onPressed: _showOpenCashDialog,
            icon: const Icon(Icons.lock_open_outlined),
            label: const Text('ABRIR CAJA'),
          ),
        ),
        if (lastSession != null) ...[
          const SizedBox(height: 30),
          const Text(
            'ÚLTIMO CIERRE',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          _buildLastClosedSession(lastSession),
        ],
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildLastClosedSession(CashSession session) {
    final closedAt = session.closedAt;

    final sessionSales = _getSalesBetween(session.openedAt, closedAt);

    final totalSales = sessionSales.fold<double>(
      0,
      (sum, sale) => sum + sale.total,
    );

    final cashSales = _getPaymentsTotal(sessionSales, PaymentMethod.cash);

    final expectedCash = session.openingAmount + cashSales;

    final closingAmount = session.closingAmount ?? 0.0;

    final difference = closingAmount - expectedCash;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _CashInfoRow(
            label: 'Monto inicial',
            value: CurrencyFormatter.format(session.openingAmount),
          ),
          const SizedBox(height: 10),
          _CashInfoRow(label: 'Ventas', value: '${sessionSales.length}'),
          const SizedBox(height: 10),
          _CashInfoRow(
            label: 'Total vendido',
            value: CurrencyFormatter.format(totalSales),
          ),
          const SizedBox(height: 10),
          _CashInfoRow(
            label: 'Ventas en efectivo',
            value: CurrencyFormatter.format(cashSales),
          ),
          const Divider(height: 28),
          _CashInfoRow(
            label: 'Efectivo esperado',
            value: CurrencyFormatter.format(expectedCash),
          ),
          const SizedBox(height: 10),
          _CashInfoRow(
            label: 'Efectivo contado',
            value: CurrencyFormatter.format(closingAmount),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Diferencia',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ),
              Text(
                _formatDifference(difference),
                style: TextStyle(
                  color: _differenceColor(difference),
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Divider(height: 28),
          _CashInfoRow(label: 'Apertura', value: _formatTime(session.openedAt)),
          const SizedBox(height: 10),
          _CashInfoRow(
            label: 'Cierre',
            value: closedAt == null ? '--' : _formatTime(closedAt),
          ),
        ],
      ),
    );
  }

  Widget _buildOpenCash() {
    final session = Services.cash.activeSession;

    if (session == null) {
      return const SizedBox.shrink();
    }

    final sessionSales = _getSessionSales(session.openedAt);

    final totalSales = sessionSales.fold<double>(
      0,
      (sum, sale) => sum + sale.total,
    );

    final cashSales = _getPaymentsTotal(sessionSales, PaymentMethod.cash);

    final cardSales = _getPaymentsTotal(sessionSales, PaymentMethod.card);

    final transferSales = _getPaymentsTotal(
      sessionSales,
      PaymentMethod.transfer,
    );

    final expectedCash = session.openingAmount + cashSales;

    return ListView(
      padding: const EdgeInsets.all(14),
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              const Icon(
                Icons.lock_open_outlined,
                size: 38,
                color: AppColors.goldLight,
              ),
              const SizedBox(height: 10),
              const Text(
                'CAJA ABIERTA',
                style: TextStyle(
                  color: AppColors.goldLight,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 18),
              _CashInfoRow(
                label: 'Monto inicial',
                value: CurrencyFormatter.format(session.openingAmount),
              ),
              const SizedBox(height: 10),
              _CashInfoRow(
                label: 'Hora de apertura',
                value: _formatTime(session.openedAt),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        const Text(
          'VENTAS DE LA SESIÓN',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              _CashInfoRow(label: 'Ventas', value: '${sessionSales.length}'),
              const SizedBox(height: 10),
              _CashInfoRow(
                label: 'Total vendido',
                value: CurrencyFormatter.format(totalSales),
              ),
              const Divider(height: 28),
              _CashInfoRow(
                label: 'Efectivo',
                value: CurrencyFormatter.format(cashSales),
              ),
              const SizedBox(height: 10),
              _CashInfoRow(
                label: 'Tarjeta',
                value: CurrencyFormatter.format(cardSales),
              ),
              const SizedBox(height: 10),
              _CashInfoRow(
                label: 'Transferencia',
                value: CurrencyFormatter.format(transferSales),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.goldLight),
          ),
          child: Column(
            children: [
              const Text(
                'EFECTIVO ESPERADO',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                CurrencyFormatter.format(expectedCash),
                style: const TextStyle(
                  color: AppColors.goldLight,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        SizedBox(
          height: 52,
          child: OutlinedButton.icon(
            onPressed: () {
              _showCloseCashDialog(expectedCash: expectedCash);
            },
            icon: const Icon(Icons.lock_outline),
            label: const Text('CERRAR CAJA'),
          ),
        ),
        const SizedBox(height: 14),
      ],
    );
  }

  List<Sale> _getSessionSales(DateTime openedAt) {
    return Services.sales.sales.where((sale) {
      return sale.isClosed && !sale.createdAt.isBefore(openedAt);
    }).toList();
  }

  List<Sale> _getSalesBetween(DateTime openedAt, DateTime? closedAt) {
    return Services.sales.sales.where((sale) {
      if (!sale.isClosed) {
        return false;
      }

      if (sale.createdAt.isBefore(openedAt)) {
        return false;
      }

      if (closedAt != null && sale.createdAt.isAfter(closedAt)) {
        return false;
      }

      return true;
    }).toList();
  }

  double _getPaymentsTotal(List<Sale> sales, PaymentMethod method) {
    double total = 0;

    for (final sale in sales) {
      for (final payment in sale.payments) {
        if (payment.method == method) {
          total += payment.amount;
        }
      }
    }

    return total;
  }

  Future<void> _showOpenCashDialog() async {
    String enteredAmount = '';

    final openingAmount = await showDialog<double>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Abrir caja'),
          content: TextField(
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Monto inicial',
              hintText: 'Ejemplo: 5000',
              prefixIcon: Icon(Icons.payments_outlined),
            ),
            onChanged: (value) {
              enteredAmount = value.trim();
            },
            onSubmitted: (value) {
              final amount = _parseAmount(value);

              if (amount == null) {
                return;
              }

              Navigator.pop(dialogContext, amount);
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('CANCELAR'),
            ),
            FilledButton(
              onPressed: () {
                final amount = _parseAmount(enteredAmount);

                if (amount == null) {
                  return;
                }

                Navigator.pop(dialogContext, amount);
              },
              child: const Text('ABRIR'),
            ),
          ],
        );
      },
    );

    if (!mounted || openingAmount == null) {
      return;
    }

    final session = await Services.cash.openCash(openingAmount: openingAmount);

    if (!mounted) {
      return;
    }

    if (session == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo abrir la caja.')),
      );

      return;
    }

    setState(() {});
  }

  Future<void> _showCloseCashDialog({required double expectedCash}) async {
    String enteredAmount = '';

    final closingAmount = await showDialog<double>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final countedCash = _parseAmount(enteredAmount);

            final difference = countedCash == null
                ? 0.0
                : countedCash - expectedCash;

            return AlertDialog(
              title: const Text('Cerrar caja'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _CashInfoRow(
                      label: 'Efectivo esperado',
                      value: CurrencyFormatter.format(expectedCash),
                    ),
                    const SizedBox(height: 18),
                    TextField(
                      autofocus: true,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Efectivo contado',
                        hintText: 'Ingresa el efectivo contado',
                        prefixIcon: Icon(Icons.payments_outlined),
                      ),
                      onChanged: (value) {
                        setDialogState(() {
                          enteredAmount = value.trim();
                        });
                      },
                    ),
                    const SizedBox(height: 18),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'DIFERENCIA',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _formatDifference(difference),
                            style: TextStyle(
                              color: _differenceColor(difference),
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                  child: const Text('CANCELAR'),
                ),
                FilledButton(
                  onPressed: countedCash == null
                      ? null
                      : () {
                          Navigator.pop(dialogContext, countedCash);
                        },
                  child: const Text('CONFIRMAR CIERRE'),
                ),
              ],
            );
          },
        );
      },
    );

    if (!mounted || closingAmount == null) {
      return;
    }

    final closed = await Services.cash.closeCash(closingAmount: closingAmount);

    if (!mounted) {
      return;
    }

    if (!closed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo cerrar la caja.')),
      );

      return;
    }

    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Caja cerrada correctamente.')),
    );
  }

  double? _parseAmount(String value) {
    final cleanValue = value.replaceAll(',', '').trim();

    final amount = double.tryParse(cleanValue);

    if (amount == null || amount < 0) {
      return null;
    }

    return amount;
  }

  String _formatDifference(double difference) {
    if (difference > 0) {
      return '+${CurrencyFormatter.format(difference)}';
    }

    if (difference < 0) {
      return '-${CurrencyFormatter.format(difference.abs())}';
    }

    return CurrencyFormatter.format(0);
  }

  Color _differenceColor(double difference) {
    if (difference == 0) {
      return AppColors.goldLight;
    }

    return AppColors.textPrimary;
  }

  String _formatTime(DateTime dateTime) {
    var hour = dateTime.hour;

    final minute = dateTime.minute.toString().padLeft(2, '0');

    final period = hour >= 12 ? 'PM' : 'AM';

    if (hour == 0) {
      hour = 12;
    } else if (hour > 12) {
      hour -= 12;
    }

    return '$hour:$minute $period';
  }
}

class _CashInfoRow extends StatelessWidget {
  const _CashInfoRow({required this.label, required this.value});

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
              fontSize: 14,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
