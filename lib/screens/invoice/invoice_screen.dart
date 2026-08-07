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
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final item = account.items[index];

                        return InvoiceItemCard(
                          item: item,
                          onIncrease: () {
                            Services.sales.increaseProductQuantity(
                              account: account,
                              productId: item.product.id,
                            );

                            setState(() {});
                          },
                          onDecrease: () async {
                            if (item.quantity > 1) {
                              Services.sales.decreaseProductQuantity(
                                account: account,
                                productId: item.product.id,
                              );

                              setState(() {});
                              return;
                            }

                            final shouldDelete = await _confirmDeleteProduct(
                              item,
                            );

                            if (!shouldDelete || !mounted) {
                              return;
                            }

                            Services.sales.removeProduct(
                              account: account,
                              productId: item.product.id,
                            );

                            setState(() {});
                          },
                          onDelete: () async {
                            final shouldDelete = await _confirmDeleteProduct(
                              item,
                            );

                            if (!shouldDelete || !mounted) {
                              return;
                            }

                            Services.sales.removeProduct(
                              account: account,
                              productId: item.product.id,
                            );

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
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductPickerScreen(account: account),
                    ),
                  );

                  if (!mounted) {
                    return;
                  }

                  setState(() {});
                },
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
                onPressed: account.items.isEmpty
                    ? null
                    : () async {
                        final paymentCompleted = await Navigator.push<bool>(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PaymentScreen(account: account),
                          ),
                        );

                        if (!mounted) {
                          return;
                        }

                        if (paymentCompleted == true) {
                          Navigator.pop(context, true);
                          return;
                        }

                        setState(() {});
                      },
                icon: const Icon(Icons.payments_outlined),
                label: const Text('COBRAR'),
              ),
            ),
          ],
        ),
      ),
    );
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
