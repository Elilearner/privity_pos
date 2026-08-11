import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../models/invoice_item.dart';
import '../../models/sale_draft.dart';
import '../../models/sale_type.dart';
import '../../services/service_locator.dart';
import '../../widgets/invoice/invoice_item_card.dart';
import '../../widgets/invoice/invoice_summary_card.dart';
import '../../widgets/products/product_card.dart';
import '../payment/payment_screen.dart';

class QuickSaleScreen extends StatefulWidget {
  const QuickSaleScreen({super.key});

  @override
  State<QuickSaleScreen> createState() => _QuickSaleScreenState();
}

class _QuickSaleScreenState extends State<QuickSaleScreen> {
  final SaleDraft _draft = SaleDraft(type: SaleType.quickSale);

  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final products = Services.products.search(_searchQuery);

    return Scaffold(
      appBar: AppBar(title: const Text('Venta rápida')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                hintText: 'Buscar producto...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),

            const SizedBox(height: 12),

            Expanded(
              flex: 3,
              child: GridView.builder(
                itemCount: products.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.72,
                ),
                itemBuilder: (context, index) {
                  final product = products[index];

                  return ProductCard(
                    name: product.name,
                    price: product.salePrice,
                    imagePath: product.imagePath,
                    onTap: () {
                      final existingItem = _draft.findItem(product.id);

                      if (existingItem != null) {
                        existingItem.increase();
                      } else {
                        _draft.addItem(InvoiceItem(product: product));
                      }

                      setState(() {});
                    },
                  );
                },
              ),
            ),

            const Divider(height: 20),

            Expanded(
              flex: 2,
              child: _draft.items.isEmpty
                  ? const Center(
                      child: Text(
                        'Agrega productos para iniciar la venta.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    )
                  : ListView.separated(
                      itemCount: _draft.items.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final item = _draft.items[index];

                        return InvoiceItemCard(
                          item: item,
                          onIncrease: () {
                            item.increase();

                            setState(() {});
                          },
                          onDecrease: () {
                            if (item.quantity > 1) {
                              item.decrease();
                            } else {
                              _draft.removeItem(index);
                            }

                            setState(() {});
                          },
                          onDelete: () {
                            _draft.removeItem(index);

                            setState(() {});
                          },
                        );
                      },
                    ),
            ),

            const SizedBox(height: 10),

            InvoiceSummaryCard(
              totalItems: _draft.totalItems,
              subtotal: _draft.subtotal,
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton.icon(
                onPressed: _draft.isEmpty ? null : _openPaymentScreen,
                icon: const Icon(Icons.payments_outlined),
                label: const Text('COBRAR'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openPaymentScreen() async {
    final paymentCompleted = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => PaymentScreen(draft: _draft)),
    );

    if (!mounted) {
      return;
    }

    if (paymentCompleted == true) {
      setState(() {
        _searchQuery = '';
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Venta rápida completada.')));

      return;
    }

    setState(() {});
  }
}
