class Product {
  const Product({
    required this.id,
    required this.name,
    required this.salePrice,
    required this.purchasePrice,
    required this.imagePath,
    required this.category,
    this.stock = 0,
    this.isActive = true,
    this.description = '',
    this.barcode = '',
    this.favorite = false,
  });

  final int id;
  final String name;
  final double salePrice;
  final double purchasePrice;
  final String imagePath;
  final String category;

  final int stock;
  final bool isActive;

  // Información adicional
  final String description;
  final String barcode;
  final bool favorite;

  double get profit {
    return salePrice - purchasePrice;
  }
}
