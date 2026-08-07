import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/currency_formatter.dart';
import '../../models/table_account.dart';
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
                      separatorBuilder: (_, __) {
                        return const Divider();
                      },
                      itemBuilder: (context, index) {
                        final item = account.items[index];

                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            item.product.name,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            '${item.quantity} x '
                            '${CurrencyFormatter.format(item.unitPrice)}',
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          trailing: Text(
                            CurrencyFormatter.format(item.total),
                            style: const TextStyle(
                              color: AppColors.goldLight,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
            const Divider(),

            Row(
              children: [
                const Expanded(
                  child: Text(
                    'TOTAL',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  CurrencyFormatter.format(account.subtotal),
                  style: const TextStyle(
                    color: AppColors.goldLight,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
