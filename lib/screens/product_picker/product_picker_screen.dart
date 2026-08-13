import 'package:flutter/material.dart';

import '../../models/product.dart';
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

  bool _savingProduct = false;

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
                      if (_savingProduct) {
                        return;
                      }

                      _addProduct(product);
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

  Future<void> _addProduct(Product product) async {
    final currentProduct = Services.products.getProduct(product.id);

    if (currentProduct == null) {
      _showStockMessage(productName: product.name, availableStock: 0);
      return;
    }

    if (!currentProduct.isActive) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${currentProduct.name} está inactivo.')),
      );

      return;
    }

    final existingItem = Services.sales.getItem(
      account: widget.account,
      productId: currentProduct.id,
    );

    final currentQuantity = existingItem?.quantity ?? 0;

    final availableForThisAccount = Services.products.getAvailableStock(
      productId: currentProduct.id,
      excludeAccountId: widget.account.id,
    );

    final desiredQuantity = currentQuantity + 1;

    if (desiredQuantity > availableForThisAccount) {
      _showStockMessage(
        productName: currentProduct.name,
        availableStock: availableForThisAccount,
      );
      return;
    }

    setState(() {
      _savingProduct = true;
    });

    try {
      Services.sales.addProductToAccount(
        account: widget.account,
        product: currentProduct,
      );

      await Services.tables.saveAccount(widget.account);
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _savingProduct = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo agregar el producto.')),
      );

      return;
    }

    if (!mounted) {
      return;
    }

    Navigator.of(context).pop();
  }

  void _showStockMessage({
    required String productName,
    required int availableStock,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          availableStock <= 0
              ? 'Sin existencia disponible de $productName.'
              : 'Stock insuficiente. '
                    'Esta cuenta puede tener hasta '
                    '$availableStock '
                    'unidad${availableStock == 1 ? '' : 'es'} '
                    'de $productName porque existen '
                    'productos reservados en otras cuentas.',
        ),
      ),
    );
  }
}
