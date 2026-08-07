import 'package:flutter/material.dart';

import '../../models/product.dart';
import '../../widgets/products/product_card.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  static const List<Product> products = [
    Product(
      id: 1,
      name: 'Cerveza Presidente Normal',
      salePrice: 150,
      purchasePrice: 95,
      imagePath: 'assets/images/products/presidente_normal.png',
      category: 'Cervezas',
      stock: 24,
    ),
    Product(
      id: 2,
      name: 'Cerveza Presidente Light',
      salePrice: 150,
      purchasePrice: 95,
      imagePath: 'assets/images/products/presidente_light.png',
      category: 'Cervezas',
      stock: 18,
    ),
    Product(
      id: 3,
      name: 'Cerveza Corona',
      salePrice: 200,
      purchasePrice: 117,
      imagePath: 'assets/images/products/corona.png',
      category: 'Cervezas',
      stock: 15,
    ),
    Product(
      id: 4,
      name: 'Smirnoff',
      salePrice: 250,
      purchasePrice: 180,
      imagePath: 'assets/images/products/smirnoff.png',
      category: 'Vodka',
      stock: 10,
    ),
    Product(
      id: 5,
      name: 'Cerveza Michelob',
      salePrice: 150,
      purchasePrice: 100,
      imagePath: 'assets/images/products/michelob.png',
      category: 'Cervezas',
      stock: 20,
    ),
    Product(
      id: 6,
      name: 'Brugal Doble Reserva',
      salePrice: 1300,
      purchasePrice: 820,
      imagePath: 'assets/images/products/brugal_doble_reserva.png',
      category: 'Ron',
      stock: 8,
    ),
    Product(
      id: 7,
      name: 'Brugal Leyenda',
      salePrice: 2000,
      purchasePrice: 1350,
      imagePath: 'assets/images/products/brugal_leyenda.png',
      category: 'Ron',
      stock: 6,
    ),
    Product(
      id: 8,
      name: 'Old Parr',
      salePrice: 3500,
      purchasePrice: 2600,
      imagePath: 'assets/images/products/old_parr.png',
      category: 'Whisky',
      stock: 5,
    ),
    Product(
      id: 9,
      name: 'Jhonny Black Label',
      salePrice: 4000,
      purchasePrice: 3100,
      imagePath: 'assets/images/products/jhonny_black.png',
      category: 'Whisky',
      stock: 4,
    ),
    Product(
      id: 10,
      name: 'Jhonny Gold Label',
      salePrice: 5500,
      purchasePrice: 4200,
      imagePath: 'assets/images/products/jhonny_gold.png',
      category: 'Whisky',
      stock: 3,
    ),
    Product(
      id: 11,
      name: 'Jugo Most',
      salePrice: 300,
      purchasePrice: 190,
      imagePath: 'assets/images/products/jugo_most.png',
      category: 'Jugos',
      stock: 12,
    ),
    Product(
      id: 12,
      name: 'Cubetazo',
      salePrice: 750,
      purchasePrice: 500,
      imagePath: 'assets/images/products/cubetazo.png',
      category: 'Combos',
      stock: 10,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
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
                    debugPrint('Producto seleccionado: ${product.name}');
                    debugPrint('Ganancia estimada: ${product.profit}');
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton.icon(
              onPressed: () {
                debugPrint('Agregar producto');
              },
              icon: const Icon(Icons.add),
              label: const Text('AGREGAR PRODUCTO'),
            ),
          ),
        ],
      ),
    );
  }
}
