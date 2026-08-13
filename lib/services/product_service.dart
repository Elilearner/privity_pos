import '../data/database/app_database.dart' as db;
import '../data/repositories/product_repository.dart';
import '../models/invoice_item.dart';
import '../models/product.dart' as domain;
import 'table_service.dart';

class ProductService {
  ProductService._();

  static final ProductService instance = ProductService._();

  final List<domain.Product> _products = [];

  late final db.AppDatabase _database;
  late final ProductRepository _repository;

  bool _initialized = false;

  List<domain.Product> get products {
    return List.unmodifiable(_products);
  }

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    _database = db.AppDatabase();

    _repository = ProductRepository(_database);

    final storedProducts = await _repository.getAllProducts();

    if (storedProducts.isEmpty) {
      final initialProducts = _initialProducts;

      await _repository.saveProducts(initialProducts);

      _products
        ..clear()
        ..addAll(initialProducts);
    } else {
      _products
        ..clear()
        ..addAll(storedProducts);
    }

    _initialized = true;
  }

  domain.Product? getProduct(int productId) {
    for (final product in _products) {
      if (product.id == productId) {
        return product;
      }
    }

    return null;
  }

  List<domain.Product> getByCategory(String category) {
    return _products.where((product) => product.category == category).toList();
  }

  List<domain.Product> search(String query) {
    final cleanQuery = query.trim().toLowerCase();

    if (cleanQuery.isEmpty) {
      return products;
    }

    return _products.where((product) {
      return product.name.toLowerCase().contains(cleanQuery) ||
          product.category.toLowerCase().contains(cleanQuery);
    }).toList();
  }

  Future<void> saveProduct(domain.Product product) async {
    await _repository.saveProduct(product);

    final index = _products.indexWhere((item) => item.id == product.id);

    if (index == -1) {
      _products.add(product);
    } else {
      _products[index] = product;
    }
  }

  Future<bool> deleteProduct(int productId) async {
    final index = _products.indexWhere((product) => product.id == productId);

    if (index == -1) {
      return false;
    }

    await _repository.deleteProduct(productId);

    _products.removeAt(index);

    return true;
  }

  // =========================================================
  // INVENTARIO DISPONIBLE
  // =========================================================

  int getAvailableStock({required int productId, int? excludeAccountId}) {
    final product = getProduct(productId);

    if (product == null) {
      return 0;
    }

    final reserved = TableService.instance.getReservedQuantity(
      productId: productId,
      excludeAccountId: excludeAccountId,
    );

    final available = product.stock - reserved;

    if (available < 0) {
      return 0;
    }

    return available;
  }

  bool canAddQuantity({
    required int productId,
    required int desiredQuantity,
    int? excludeAccountId,
  }) {
    if (desiredQuantity <= 0) {
      return false;
    }

    final product = getProduct(productId);

    if (product == null || !product.isActive) {
      return false;
    }

    final available = getAvailableStock(
      productId: productId,
      excludeAccountId: excludeAccountId,
    );

    return desiredQuantity <= available;
  }

  bool hasEnoughStock(List<InvoiceItem> items, {int? excludeAccountId}) {
    for (final item in items) {
      final currentProduct = getProduct(item.product.id);

      if (currentProduct == null) {
        return false;
      }

      if (!currentProduct.isActive) {
        return false;
      }

      final available = getAvailableStock(
        productId: currentProduct.id,
        excludeAccountId: excludeAccountId,
      );

      if (item.quantity > available) {
        return false;
      }
    }

    return true;
  }

  // =========================================================
  // DESCUENTO DEFINITIVO DE INVENTARIO
  // =========================================================

  Future<bool> decreaseStock(List<InvoiceItem> items) async {
    for (final item in items) {
      final currentProduct = getProduct(item.product.id);

      if (currentProduct == null) {
        return false;
      }

      if (currentProduct.stock < item.quantity) {
        return false;
      }
    }

    final updatedProducts = <domain.Product>[];

    for (final item in items) {
      final currentProduct = getProduct(item.product.id);

      if (currentProduct == null) {
        return false;
      }

      final updatedProduct = domain.Product(
        id: currentProduct.id,
        name: currentProduct.name,
        salePrice: currentProduct.salePrice,
        purchasePrice: currentProduct.purchasePrice,
        imagePath: currentProduct.imagePath,
        category: currentProduct.category,
        stock: currentProduct.stock - item.quantity,
        isActive: currentProduct.isActive,
        description: currentProduct.description,
        barcode: currentProduct.barcode,
        favorite: currentProduct.favorite,
      );

      updatedProducts.add(updatedProduct);
    }

    try {
      for (final product in updatedProducts) {
        await saveProduct(product);
      }
    } catch (_) {
      return false;
    }

    return true;
  }

  // =========================================================
  // PRODUCTOS INICIALES
  // =========================================================

  List<domain.Product> get _initialProducts {
    return const [
      domain.Product(
        id: 1,
        name: 'Cerveza Presidente Normal',
        salePrice: 150,
        purchasePrice: 95,
        imagePath: 'assets/images/products/presidente_normal.png',
        category: 'Cervezas',
        stock: 24,
      ),
      domain.Product(
        id: 2,
        name: 'Cerveza Presidente Light',
        salePrice: 150,
        purchasePrice: 95,
        imagePath: 'assets/images/products/presidente_light.png',
        category: 'Cervezas',
        stock: 18,
      ),
      domain.Product(
        id: 3,
        name: 'Cerveza Corona',
        salePrice: 200,
        purchasePrice: 117,
        imagePath: 'assets/images/products/corona.png',
        category: 'Cervezas',
        stock: 15,
      ),
      domain.Product(
        id: 4,
        name: 'Smirnoff',
        salePrice: 250,
        purchasePrice: 180,
        imagePath: 'assets/images/products/smirnoff.png',
        category: 'Vodka',
        stock: 10,
      ),
      domain.Product(
        id: 5,
        name: 'Cerveza Michelob',
        salePrice: 150,
        purchasePrice: 100,
        imagePath: 'assets/images/products/michelob.png',
        category: 'Cervezas',
        stock: 20,
      ),
      domain.Product(
        id: 6,
        name: 'Brugal Doble Reserva',
        salePrice: 1300,
        purchasePrice: 820,
        imagePath: 'assets/images/products/brugal_doble_reserva.png',
        category: 'Ron',
        stock: 8,
      ),
      domain.Product(
        id: 7,
        name: 'Brugal Leyenda',
        salePrice: 2000,
        purchasePrice: 1350,
        imagePath: 'assets/images/products/brugal_leyenda.png',
        category: 'Ron',
        stock: 6,
      ),
      domain.Product(
        id: 8,
        name: 'Old Parr',
        salePrice: 3500,
        purchasePrice: 2600,
        imagePath: 'assets/images/products/old_parr.png',
        category: 'Whisky',
        stock: 5,
      ),
      domain.Product(
        id: 9,
        name: 'Jhonny Black Label',
        salePrice: 4000,
        purchasePrice: 3100,
        imagePath: 'assets/images/products/jhonny_black.png',
        category: 'Whisky',
        stock: 4,
      ),
      domain.Product(
        id: 10,
        name: 'Jhonny Gold Label',
        salePrice: 5500,
        purchasePrice: 4200,
        imagePath: 'assets/images/products/jhonny_gold.png',
        category: 'Whisky',
        stock: 3,
      ),
      domain.Product(
        id: 11,
        name: 'Jugo Most',
        salePrice: 300,
        purchasePrice: 190,
        imagePath: 'assets/images/products/jugo_most.png',
        category: 'Jugos',
        stock: 12,
      ),
      domain.Product(
        id: 12,
        name: 'Cubetazo',
        salePrice: 750,
        purchasePrice: 500,
        imagePath: 'assets/images/products/cubetazo.png',
        category: 'Combos',
        stock: 10,
      ),
    ];
  }
}
