import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../models/invoice_item.dart';
import '../../models/table_account.dart';
import '../../services/service_locator.dart';
import '../../widgets/invoice/invoice_item_card.dart';
import '../../widgets/invoice/invoice_summary_card.dart';
import '../payment/payment_screen.dart';
import '../product_picker/product_picker_screen.dart';

class InvoiceScreen extends StatefulWidget {
  const InvoiceScreen({super.key, required this.account});

  final TableAccount account;

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  TableAccount get account => widget.account;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mesa ${account.tableNumber} - ${account.customerName}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cuenta: ${account.customerName}',
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Mesa ${account.tableNumber}',
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: account.items.isEmpty
                  ? const Center(
                      child: Text(
                        'Esta cuenta todavía no tiene productos.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    )
                  : ListView.separated(
                      itemCount: account.items.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final item = account.items[index];

                        return InvoiceItemCard(
                          item: item,
                          onIncrease: () async {
                            final changed = Services.sales
                                .increaseProductQuantity(
                                  account: account,
                                  productId: item.product.id,
                                );

                            if (!changed) {
                              return;
                            }

                            await Services.tables.saveAccount(account);

                            if (!mounted) {
                              return;
                            }

                            setState(() {});
                          },
                          onDecrease: () async {
                            if (item.quantity > 1) {
                              final changed = Services.sales
                                  .decreaseProductQuantity(
                                    account: account,
                                    productId: item.product.id,
                                  );

                              if (!changed) {
                                return;
                              }

                              await Services.tables.saveAccount(account);

                              if (!mounted) {
                                return;
                              }

                              setState(() {});
                              return;
                            }

                            final shouldDelete = await _confirmDeleteProduct(
                              item,
                            );

                            if (!mounted || !shouldDelete) {
                              return;
                            }

                            final removed = Services.sales.removeProduct(
                              account: account,
                              productId: item.product.id,
                            );

                            if (!removed) {
                              return;
                            }

                            await Services.tables.saveAccount(account);

                            if (!mounted) {
                              return;
                            }

                            setState(() {});
                          },
                          onDelete: () async {
                            final shouldDelete = await _confirmDeleteProduct(
                              item,
                            );

                            if (!mounted || !shouldDelete) {
                              return;
                            }

                            final removed = Services.sales.removeProduct(
                              account: account,
                              productId: item.product.id,
                            );

                            if (!removed) {
                              return;
                            }

                            await Services.tables.saveAccount(account);

                            if (!mounted) {
                              return;
                            }

                            setState(() {});
                          },
                        );
                      },
                    ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton.icon(
                onPressed: _openProductPicker,
                icon: const Icon(Icons.add_shopping_cart),
                label: const Text('AGREGAR PRODUCTOS'),
              ),
            ),

            const SizedBox(height: 12),

            InvoiceSummaryCard(
              totalItems: account.totalItems,
              subtotal: account.subtotal,
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton.icon(
                onPressed: account.items.isEmpty ? null : _openPaymentScreen,
                icon: const Icon(Icons.payments_outlined),
                label: const Text('COBRAR'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openProductPicker() async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ProductPickerScreen(account: account)),
    );

    if (!mounted) {
      return;
    }

    await Services.tables.saveAccount(account);

    if (!mounted) {
      return;
    }

    setState(() {});
  }

  Future<void> _openPaymentScreen() async {
    final paymentCompleted = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => PaymentScreen(account: account)),
    );

    if (!mounted) {
      return;
    }

    if (paymentCompleted == true) {
      Navigator.of(context).pop(true);
      return;
    }

    setState(() {});
  }

  Future<bool> _confirmDeleteProduct(InvoiceItem item) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Eliminar producto'),
          content: Text(
            '¿Deseas eliminar '
            '${item.product.name} '
            'de esta cuenta?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('CANCELAR'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('ELIMINAR'),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }
}
