import 'package:drift/drift.dart' as drift;

import '../../models/product.dart' as domain;
import '../database/app_database.dart' as db;

class ProductRepository {
  ProductRepository(this.database);

  final db.AppDatabase database;

  Future<List<domain.Product>> getAllProducts() async {
    final rows = await (database.select(
      database.products,
    )..orderBy([(table) => drift.OrderingTerm.asc(table.name)])).get();

    return rows.map((row) {
      return domain.Product(
        id: row.id,
        name: row.name,
        salePrice: row.salePrice,
        purchasePrice: row.purchasePrice,
        imagePath: row.imagePath,
        category: row.category,
        stock: row.stock,
        isActive: row.isActive,
        description: row.description,
        barcode: row.barcode,
        favorite: row.favorite,
      );
    }).toList();
  }

  Future<void> saveProduct(domain.Product product) async {
    await database
        .into(database.products)
        .insertOnConflictUpdate(
          db.ProductsCompanion.insert(
            id: drift.Value(product.id),
            name: product.name,
            salePrice: product.salePrice,
            purchasePrice: product.purchasePrice,
            imagePath: product.imagePath,
            category: product.category,
            stock: drift.Value(product.stock),
            isActive: drift.Value(product.isActive),
            description: drift.Value(product.description),
            barcode: drift.Value(product.barcode),
            favorite: drift.Value(product.favorite),
          ),
        );
  }

  Future<void> saveProducts(List<domain.Product> products) async {
    await database.transaction(() async {
      for (final product in products) {
        await saveProduct(product);
      }
    });
  }

  Future<void> deleteProduct(int productId) async {
    await (database.delete(
      database.products,
    )..where((table) => table.id.equals(productId))).go();
  }

  Future<domain.Product?> getProduct(int productId) async {
    final row = await (database.select(
      database.products,
    )..where((table) => table.id.equals(productId))).getSingleOrNull();

    if (row == null) {
      return null;
    }

    return domain.Product(
      id: row.id,
      name: row.name,
      salePrice: row.salePrice,
      purchasePrice: row.purchasePrice,
      imagePath: row.imagePath,
      category: row.category,
      stock: row.stock,
      isActive: row.isActive,
      description: row.description,
      barcode: row.barcode,
      favorite: row.favorite,
    );
  }
}
