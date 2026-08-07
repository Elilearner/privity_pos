import 'package:flutter/material.dart';

import '../../models/table_account.dart';
import '../../services/service_locator.dart';
import '../../widgets/products/product_card.dart';

class ProductPickerScreen extends StatefulWidget {
  const ProductPickerScreen({super.key, required this.account});

  final TableAccount account;

  @override
  State<ProductPickerScreen> createState() => _ProductPickerScreenState();
}

class _ProductPickerScreenState extends State<ProductPickerScreen> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final products = Services.products.search(searchQuery);

    return Scaffold(
      appBar: AppBar(title: Text('Agregar a ${widget.account.customerName}')),
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
                  searchQuery = value;
                });
              },
            ),
            const SizedBox(height: 12),
            Expanded(
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
                      Services.sales.addProductToAccount(
                        account: widget.account,
                        product: product,
                      );

                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
