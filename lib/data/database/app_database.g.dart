// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ProductsTable extends Products with TableInfo<$ProductsTable, Product> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _salePriceMeta = const VerificationMeta(
    'salePrice',
  );
  @override
  late final GeneratedColumn<double> salePrice = GeneratedColumn<double>(
    'sale_price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _purchasePriceMeta = const VerificationMeta(
    'purchasePrice',
  );
  @override
  late final GeneratedColumn<double> purchasePrice = GeneratedColumn<double>(
    'purchase_price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imagePathMeta = const VerificationMeta(
    'imagePath',
  );
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
    'image_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stockMeta = const VerificationMeta('stock');
  @override
  late final GeneratedColumn<int> stock = GeneratedColumn<int>(
    'stock',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _barcodeMeta = const VerificationMeta(
    'barcode',
  );
  @override
  late final GeneratedColumn<String> barcode = GeneratedColumn<String>(
    'barcode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _favoriteMeta = const VerificationMeta(
    'favorite',
  );
  @override
  late final GeneratedColumn<bool> favorite = GeneratedColumn<bool>(
    'favorite',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("favorite" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    salePrice,
    purchasePrice,
    imagePath,
    category,
    stock,
    isActive,
    description,
    barcode,
    favorite,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'products';
  @override
  VerificationContext validateIntegrity(
    Insertable<Product> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('sale_price')) {
      context.handle(
        _salePriceMeta,
        salePrice.isAcceptableOrUnknown(data['sale_price']!, _salePriceMeta),
      );
    } else if (isInserting) {
      context.missing(_salePriceMeta);
    }
    if (data.containsKey('purchase_price')) {
      context.handle(
        _purchasePriceMeta,
        purchasePrice.isAcceptableOrUnknown(
          data['purchase_price']!,
          _purchasePriceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_purchasePriceMeta);
    }
    if (data.containsKey('image_path')) {
      context.handle(
        _imagePathMeta,
        imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta),
      );
    } else if (isInserting) {
      context.missing(_imagePathMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('stock')) {
      context.handle(
        _stockMeta,
        stock.isAcceptableOrUnknown(data['stock']!, _stockMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('barcode')) {
      context.handle(
        _barcodeMeta,
        barcode.isAcceptableOrUnknown(data['barcode']!, _barcodeMeta),
      );
    }
    if (data.containsKey('favorite')) {
      context.handle(
        _favoriteMeta,
        favorite.isAcceptableOrUnknown(data['favorite']!, _favoriteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Product map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Product(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      salePrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}sale_price'],
      )!,
      purchasePrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}purchase_price'],
      )!,
      imagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_path'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      stock: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}stock'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      barcode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}barcode'],
      )!,
      favorite: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}favorite'],
      )!,
    );
  }

  @override
  $ProductsTable createAlias(String alias) {
    return $ProductsTable(attachedDatabase, alias);
  }
}

class Product extends DataClass implements Insertable<Product> {
  final int id;
  final String name;
  final double salePrice;
  final double purchasePrice;
  final String imagePath;
  final String category;
  final int stock;
  final bool isActive;
  final String description;
  final String barcode;
  final bool favorite;
  const Product({
    required this.id,
    required this.name,
    required this.salePrice,
    required this.purchasePrice,
    required this.imagePath,
    required this.category,
    required this.stock,
    required this.isActive,
    required this.description,
    required this.barcode,
    required this.favorite,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['sale_price'] = Variable<double>(salePrice);
    map['purchase_price'] = Variable<double>(purchasePrice);
    map['image_path'] = Variable<String>(imagePath);
    map['category'] = Variable<String>(category);
    map['stock'] = Variable<int>(stock);
    map['is_active'] = Variable<bool>(isActive);
    map['description'] = Variable<String>(description);
    map['barcode'] = Variable<String>(barcode);
    map['favorite'] = Variable<bool>(favorite);
    return map;
  }

  ProductsCompanion toCompanion(bool nullToAbsent) {
    return ProductsCompanion(
      id: Value(id),
      name: Value(name),
      salePrice: Value(salePrice),
      purchasePrice: Value(purchasePrice),
      imagePath: Value(imagePath),
      category: Value(category),
      stock: Value(stock),
      isActive: Value(isActive),
      description: Value(description),
      barcode: Value(barcode),
      favorite: Value(favorite),
    );
  }

  factory Product.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Product(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      salePrice: serializer.fromJson<double>(json['salePrice']),
      purchasePrice: serializer.fromJson<double>(json['purchasePrice']),
      imagePath: serializer.fromJson<String>(json['imagePath']),
      category: serializer.fromJson<String>(json['category']),
      stock: serializer.fromJson<int>(json['stock']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      description: serializer.fromJson<String>(json['description']),
      barcode: serializer.fromJson<String>(json['barcode']),
      favorite: serializer.fromJson<bool>(json['favorite']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'salePrice': serializer.toJson<double>(salePrice),
      'purchasePrice': serializer.toJson<double>(purchasePrice),
      'imagePath': serializer.toJson<String>(imagePath),
      'category': serializer.toJson<String>(category),
      'stock': serializer.toJson<int>(stock),
      'isActive': serializer.toJson<bool>(isActive),
      'description': serializer.toJson<String>(description),
      'barcode': serializer.toJson<String>(barcode),
      'favorite': serializer.toJson<bool>(favorite),
    };
  }

  Product copyWith({
    int? id,
    String? name,
    double? salePrice,
    double? purchasePrice,
    String? imagePath,
    String? category,
    int? stock,
    bool? isActive,
    String? description,
    String? barcode,
    bool? favorite,
  }) => Product(
    id: id ?? this.id,
    name: name ?? this.name,
    salePrice: salePrice ?? this.salePrice,
    purchasePrice: purchasePrice ?? this.purchasePrice,
    imagePath: imagePath ?? this.imagePath,
    category: category ?? this.category,
    stock: stock ?? this.stock,
    isActive: isActive ?? this.isActive,
    description: description ?? this.description,
    barcode: barcode ?? this.barcode,
    favorite: favorite ?? this.favorite,
  );
  Product copyWithCompanion(ProductsCompanion data) {
    return Product(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      salePrice: data.salePrice.present ? data.salePrice.value : this.salePrice,
      purchasePrice: data.purchasePrice.present
          ? data.purchasePrice.value
          : this.purchasePrice,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
      category: data.category.present ? data.category.value : this.category,
      stock: data.stock.present ? data.stock.value : this.stock,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      description: data.description.present
          ? data.description.value
          : this.description,
      barcode: data.barcode.present ? data.barcode.value : this.barcode,
      favorite: data.favorite.present ? data.favorite.value : this.favorite,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Product(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('salePrice: $salePrice, ')
          ..write('purchasePrice: $purchasePrice, ')
          ..write('imagePath: $imagePath, ')
          ..write('category: $category, ')
          ..write('stock: $stock, ')
          ..write('isActive: $isActive, ')
          ..write('description: $description, ')
          ..write('barcode: $barcode, ')
          ..write('favorite: $favorite')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    salePrice,
    purchasePrice,
    imagePath,
    category,
    stock,
    isActive,
    description,
    barcode,
    favorite,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Product &&
          other.id == this.id &&
          other.name == this.name &&
          other.salePrice == this.salePrice &&
          other.purchasePrice == this.purchasePrice &&
          other.imagePath == this.imagePath &&
          other.category == this.category &&
          other.stock == this.stock &&
          other.isActive == this.isActive &&
          other.description == this.description &&
          other.barcode == this.barcode &&
          other.favorite == this.favorite);
}

class ProductsCompanion extends UpdateCompanion<Product> {
  final Value<int> id;
  final Value<String> name;
  final Value<double> salePrice;
  final Value<double> purchasePrice;
  final Value<String> imagePath;
  final Value<String> category;
  final Value<int> stock;
  final Value<bool> isActive;
  final Value<String> description;
  final Value<String> barcode;
  final Value<bool> favorite;
  const ProductsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.salePrice = const Value.absent(),
    this.purchasePrice = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.category = const Value.absent(),
    this.stock = const Value.absent(),
    this.isActive = const Value.absent(),
    this.description = const Value.absent(),
    this.barcode = const Value.absent(),
    this.favorite = const Value.absent(),
  });
  ProductsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required double salePrice,
    required double purchasePrice,
    required String imagePath,
    required String category,
    this.stock = const Value.absent(),
    this.isActive = const Value.absent(),
    this.description = const Value.absent(),
    this.barcode = const Value.absent(),
    this.favorite = const Value.absent(),
  }) : name = Value(name),
       salePrice = Value(salePrice),
       purchasePrice = Value(purchasePrice),
       imagePath = Value(imagePath),
       category = Value(category);
  static Insertable<Product> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<double>? salePrice,
    Expression<double>? purchasePrice,
    Expression<String>? imagePath,
    Expression<String>? category,
    Expression<int>? stock,
    Expression<bool>? isActive,
    Expression<String>? description,
    Expression<String>? barcode,
    Expression<bool>? favorite,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (salePrice != null) 'sale_price': salePrice,
      if (purchasePrice != null) 'purchase_price': purchasePrice,
      if (imagePath != null) 'image_path': imagePath,
      if (category != null) 'category': category,
      if (stock != null) 'stock': stock,
      if (isActive != null) 'is_active': isActive,
      if (description != null) 'description': description,
      if (barcode != null) 'barcode': barcode,
      if (favorite != null) 'favorite': favorite,
    });
  }

  ProductsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<double>? salePrice,
    Value<double>? purchasePrice,
    Value<String>? imagePath,
    Value<String>? category,
    Value<int>? stock,
    Value<bool>? isActive,
    Value<String>? description,
    Value<String>? barcode,
    Value<bool>? favorite,
  }) {
    return ProductsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      salePrice: salePrice ?? this.salePrice,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      imagePath: imagePath ?? this.imagePath,
      category: category ?? this.category,
      stock: stock ?? this.stock,
      isActive: isActive ?? this.isActive,
      description: description ?? this.description,
      barcode: barcode ?? this.barcode,
      favorite: favorite ?? this.favorite,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (salePrice.present) {
      map['sale_price'] = Variable<double>(salePrice.value);
    }
    if (purchasePrice.present) {
      map['purchase_price'] = Variable<double>(purchasePrice.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (stock.present) {
      map['stock'] = Variable<int>(stock.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (barcode.present) {
      map['barcode'] = Variable<String>(barcode.value);
    }
    if (favorite.present) {
      map['favorite'] = Variable<bool>(favorite.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('salePrice: $salePrice, ')
          ..write('purchasePrice: $purchasePrice, ')
          ..write('imagePath: $imagePath, ')
          ..write('category: $category, ')
          ..write('stock: $stock, ')
          ..write('isActive: $isActive, ')
          ..write('description: $description, ')
          ..write('barcode: $barcode, ')
          ..write('favorite: $favorite')
          ..write(')'))
        .toString();
  }
}

class $SalesTable extends Sales with TableInfo<$SalesTable, Sale> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SalesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tableNumberMeta = const VerificationMeta(
    'tableNumber',
  );
  @override
  late final GeneratedColumn<int> tableNumber = GeneratedColumn<int>(
    'table_number',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
    'account_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _customerNameMeta = const VerificationMeta(
    'customerName',
  );
  @override
  late final GeneratedColumn<String> customerName = GeneratedColumn<String>(
    'customer_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _customerPhoneMeta = const VerificationMeta(
    'customerPhone',
  );
  @override
  late final GeneratedColumn<String> customerPhone = GeneratedColumn<String>(
    'customer_phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deliveryAddressMeta = const VerificationMeta(
    'deliveryAddress',
  );
  @override
  late final GeneratedColumn<String> deliveryAddress = GeneratedColumn<String>(
    'delivery_address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deliveryReferenceMeta = const VerificationMeta(
    'deliveryReference',
  );
  @override
  late final GeneratedColumn<String> deliveryReference =
      GeneratedColumn<String>(
        'delivery_reference',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _deliveryFeeMeta = const VerificationMeta(
    'deliveryFee',
  );
  @override
  late final GeneratedColumn<double> deliveryFee = GeneratedColumn<double>(
    'delivery_fee',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _taxRateMeta = const VerificationMeta(
    'taxRate',
  );
  @override
  late final GeneratedColumn<double> taxRate = GeneratedColumn<double>(
    'tax_rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isClosedMeta = const VerificationMeta(
    'isClosed',
  );
  @override
  late final GeneratedColumn<bool> isClosed = GeneratedColumn<bool>(
    'is_closed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_closed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    type,
    createdAt,
    tableNumber,
    accountId,
    customerName,
    customerPhone,
    deliveryAddress,
    deliveryReference,
    deliveryFee,
    taxRate,
    isClosed,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sales';
  @override
  VerificationContext validateIntegrity(
    Insertable<Sale> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('table_number')) {
      context.handle(
        _tableNumberMeta,
        tableNumber.isAcceptableOrUnknown(
          data['table_number']!,
          _tableNumberMeta,
        ),
      );
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    }
    if (data.containsKey('customer_name')) {
      context.handle(
        _customerNameMeta,
        customerName.isAcceptableOrUnknown(
          data['customer_name']!,
          _customerNameMeta,
        ),
      );
    }
    if (data.containsKey('customer_phone')) {
      context.handle(
        _customerPhoneMeta,
        customerPhone.isAcceptableOrUnknown(
          data['customer_phone']!,
          _customerPhoneMeta,
        ),
      );
    }
    if (data.containsKey('delivery_address')) {
      context.handle(
        _deliveryAddressMeta,
        deliveryAddress.isAcceptableOrUnknown(
          data['delivery_address']!,
          _deliveryAddressMeta,
        ),
      );
    }
    if (data.containsKey('delivery_reference')) {
      context.handle(
        _deliveryReferenceMeta,
        deliveryReference.isAcceptableOrUnknown(
          data['delivery_reference']!,
          _deliveryReferenceMeta,
        ),
      );
    }
    if (data.containsKey('delivery_fee')) {
      context.handle(
        _deliveryFeeMeta,
        deliveryFee.isAcceptableOrUnknown(
          data['delivery_fee']!,
          _deliveryFeeMeta,
        ),
      );
    }
    if (data.containsKey('tax_rate')) {
      context.handle(
        _taxRateMeta,
        taxRate.isAcceptableOrUnknown(data['tax_rate']!, _taxRateMeta),
      );
    }
    if (data.containsKey('is_closed')) {
      context.handle(
        _isClosedMeta,
        isClosed.isAcceptableOrUnknown(data['is_closed']!, _isClosedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Sale map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Sale(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      tableNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}table_number'],
      ),
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}account_id'],
      ),
      customerName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_name'],
      ),
      customerPhone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_phone'],
      ),
      deliveryAddress: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}delivery_address'],
      ),
      deliveryReference: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}delivery_reference'],
      ),
      deliveryFee: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}delivery_fee'],
      )!,
      taxRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}tax_rate'],
      )!,
      isClosed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_closed'],
      )!,
    );
  }

  @override
  $SalesTable createAlias(String alias) {
    return $SalesTable(attachedDatabase, alias);
  }
}

class Sale extends DataClass implements Insertable<Sale> {
  final int id;
  final String type;
  final DateTime createdAt;
  final int? tableNumber;
  final int? accountId;
  final String? customerName;
  final String? customerPhone;
  final String? deliveryAddress;
  final String? deliveryReference;
  final double deliveryFee;
  final double taxRate;
  final bool isClosed;
  const Sale({
    required this.id,
    required this.type,
    required this.createdAt,
    this.tableNumber,
    this.accountId,
    this.customerName,
    this.customerPhone,
    this.deliveryAddress,
    this.deliveryReference,
    required this.deliveryFee,
    required this.taxRate,
    required this.isClosed,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['type'] = Variable<String>(type);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || tableNumber != null) {
      map['table_number'] = Variable<int>(tableNumber);
    }
    if (!nullToAbsent || accountId != null) {
      map['account_id'] = Variable<int>(accountId);
    }
    if (!nullToAbsent || customerName != null) {
      map['customer_name'] = Variable<String>(customerName);
    }
    if (!nullToAbsent || customerPhone != null) {
      map['customer_phone'] = Variable<String>(customerPhone);
    }
    if (!nullToAbsent || deliveryAddress != null) {
      map['delivery_address'] = Variable<String>(deliveryAddress);
    }
    if (!nullToAbsent || deliveryReference != null) {
      map['delivery_reference'] = Variable<String>(deliveryReference);
    }
    map['delivery_fee'] = Variable<double>(deliveryFee);
    map['tax_rate'] = Variable<double>(taxRate);
    map['is_closed'] = Variable<bool>(isClosed);
    return map;
  }

  SalesCompanion toCompanion(bool nullToAbsent) {
    return SalesCompanion(
      id: Value(id),
      type: Value(type),
      createdAt: Value(createdAt),
      tableNumber: tableNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(tableNumber),
      accountId: accountId == null && nullToAbsent
          ? const Value.absent()
          : Value(accountId),
      customerName: customerName == null && nullToAbsent
          ? const Value.absent()
          : Value(customerName),
      customerPhone: customerPhone == null && nullToAbsent
          ? const Value.absent()
          : Value(customerPhone),
      deliveryAddress: deliveryAddress == null && nullToAbsent
          ? const Value.absent()
          : Value(deliveryAddress),
      deliveryReference: deliveryReference == null && nullToAbsent
          ? const Value.absent()
          : Value(deliveryReference),
      deliveryFee: Value(deliveryFee),
      taxRate: Value(taxRate),
      isClosed: Value(isClosed),
    );
  }

  factory Sale.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Sale(
      id: serializer.fromJson<int>(json['id']),
      type: serializer.fromJson<String>(json['type']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      tableNumber: serializer.fromJson<int?>(json['tableNumber']),
      accountId: serializer.fromJson<int?>(json['accountId']),
      customerName: serializer.fromJson<String?>(json['customerName']),
      customerPhone: serializer.fromJson<String?>(json['customerPhone']),
      deliveryAddress: serializer.fromJson<String?>(json['deliveryAddress']),
      deliveryReference: serializer.fromJson<String?>(
        json['deliveryReference'],
      ),
      deliveryFee: serializer.fromJson<double>(json['deliveryFee']),
      taxRate: serializer.fromJson<double>(json['taxRate']),
      isClosed: serializer.fromJson<bool>(json['isClosed']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'type': serializer.toJson<String>(type),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'tableNumber': serializer.toJson<int?>(tableNumber),
      'accountId': serializer.toJson<int?>(accountId),
      'customerName': serializer.toJson<String?>(customerName),
      'customerPhone': serializer.toJson<String?>(customerPhone),
      'deliveryAddress': serializer.toJson<String?>(deliveryAddress),
      'deliveryReference': serializer.toJson<String?>(deliveryReference),
      'deliveryFee': serializer.toJson<double>(deliveryFee),
      'taxRate': serializer.toJson<double>(taxRate),
      'isClosed': serializer.toJson<bool>(isClosed),
    };
  }

  Sale copyWith({
    int? id,
    String? type,
    DateTime? createdAt,
    Value<int?> tableNumber = const Value.absent(),
    Value<int?> accountId = const Value.absent(),
    Value<String?> customerName = const Value.absent(),
    Value<String?> customerPhone = const Value.absent(),
    Value<String?> deliveryAddress = const Value.absent(),
    Value<String?> deliveryReference = const Value.absent(),
    double? deliveryFee,
    double? taxRate,
    bool? isClosed,
  }) => Sale(
    id: id ?? this.id,
    type: type ?? this.type,
    createdAt: createdAt ?? this.createdAt,
    tableNumber: tableNumber.present ? tableNumber.value : this.tableNumber,
    accountId: accountId.present ? accountId.value : this.accountId,
    customerName: customerName.present ? customerName.value : this.customerName,
    customerPhone: customerPhone.present
        ? customerPhone.value
        : this.customerPhone,
    deliveryAddress: deliveryAddress.present
        ? deliveryAddress.value
        : this.deliveryAddress,
    deliveryReference: deliveryReference.present
        ? deliveryReference.value
        : this.deliveryReference,
    deliveryFee: deliveryFee ?? this.deliveryFee,
    taxRate: taxRate ?? this.taxRate,
    isClosed: isClosed ?? this.isClosed,
  );
  Sale copyWithCompanion(SalesCompanion data) {
    return Sale(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      tableNumber: data.tableNumber.present
          ? data.tableNumber.value
          : this.tableNumber,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      customerName: data.customerName.present
          ? data.customerName.value
          : this.customerName,
      customerPhone: data.customerPhone.present
          ? data.customerPhone.value
          : this.customerPhone,
      deliveryAddress: data.deliveryAddress.present
          ? data.deliveryAddress.value
          : this.deliveryAddress,
      deliveryReference: data.deliveryReference.present
          ? data.deliveryReference.value
          : this.deliveryReference,
      deliveryFee: data.deliveryFee.present
          ? data.deliveryFee.value
          : this.deliveryFee,
      taxRate: data.taxRate.present ? data.taxRate.value : this.taxRate,
      isClosed: data.isClosed.present ? data.isClosed.value : this.isClosed,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Sale(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('createdAt: $createdAt, ')
          ..write('tableNumber: $tableNumber, ')
          ..write('accountId: $accountId, ')
          ..write('customerName: $customerName, ')
          ..write('customerPhone: $customerPhone, ')
          ..write('deliveryAddress: $deliveryAddress, ')
          ..write('deliveryReference: $deliveryReference, ')
          ..write('deliveryFee: $deliveryFee, ')
          ..write('taxRate: $taxRate, ')
          ..write('isClosed: $isClosed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    type,
    createdAt,
    tableNumber,
    accountId,
    customerName,
    customerPhone,
    deliveryAddress,
    deliveryReference,
    deliveryFee,
    taxRate,
    isClosed,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Sale &&
          other.id == this.id &&
          other.type == this.type &&
          other.createdAt == this.createdAt &&
          other.tableNumber == this.tableNumber &&
          other.accountId == this.accountId &&
          other.customerName == this.customerName &&
          other.customerPhone == this.customerPhone &&
          other.deliveryAddress == this.deliveryAddress &&
          other.deliveryReference == this.deliveryReference &&
          other.deliveryFee == this.deliveryFee &&
          other.taxRate == this.taxRate &&
          other.isClosed == this.isClosed);
}

class SalesCompanion extends UpdateCompanion<Sale> {
  final Value<int> id;
  final Value<String> type;
  final Value<DateTime> createdAt;
  final Value<int?> tableNumber;
  final Value<int?> accountId;
  final Value<String?> customerName;
  final Value<String?> customerPhone;
  final Value<String?> deliveryAddress;
  final Value<String?> deliveryReference;
  final Value<double> deliveryFee;
  final Value<double> taxRate;
  final Value<bool> isClosed;
  const SalesCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.tableNumber = const Value.absent(),
    this.accountId = const Value.absent(),
    this.customerName = const Value.absent(),
    this.customerPhone = const Value.absent(),
    this.deliveryAddress = const Value.absent(),
    this.deliveryReference = const Value.absent(),
    this.deliveryFee = const Value.absent(),
    this.taxRate = const Value.absent(),
    this.isClosed = const Value.absent(),
  });
  SalesCompanion.insert({
    this.id = const Value.absent(),
    required String type,
    required DateTime createdAt,
    this.tableNumber = const Value.absent(),
    this.accountId = const Value.absent(),
    this.customerName = const Value.absent(),
    this.customerPhone = const Value.absent(),
    this.deliveryAddress = const Value.absent(),
    this.deliveryReference = const Value.absent(),
    this.deliveryFee = const Value.absent(),
    this.taxRate = const Value.absent(),
    this.isClosed = const Value.absent(),
  }) : type = Value(type),
       createdAt = Value(createdAt);
  static Insertable<Sale> custom({
    Expression<int>? id,
    Expression<String>? type,
    Expression<DateTime>? createdAt,
    Expression<int>? tableNumber,
    Expression<int>? accountId,
    Expression<String>? customerName,
    Expression<String>? customerPhone,
    Expression<String>? deliveryAddress,
    Expression<String>? deliveryReference,
    Expression<double>? deliveryFee,
    Expression<double>? taxRate,
    Expression<bool>? isClosed,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (createdAt != null) 'created_at': createdAt,
      if (tableNumber != null) 'table_number': tableNumber,
      if (accountId != null) 'account_id': accountId,
      if (customerName != null) 'customer_name': customerName,
      if (customerPhone != null) 'customer_phone': customerPhone,
      if (deliveryAddress != null) 'delivery_address': deliveryAddress,
      if (deliveryReference != null) 'delivery_reference': deliveryReference,
      if (deliveryFee != null) 'delivery_fee': deliveryFee,
      if (taxRate != null) 'tax_rate': taxRate,
      if (isClosed != null) 'is_closed': isClosed,
    });
  }

  SalesCompanion copyWith({
    Value<int>? id,
    Value<String>? type,
    Value<DateTime>? createdAt,
    Value<int?>? tableNumber,
    Value<int?>? accountId,
    Value<String?>? customerName,
    Value<String?>? customerPhone,
    Value<String?>? deliveryAddress,
    Value<String?>? deliveryReference,
    Value<double>? deliveryFee,
    Value<double>? taxRate,
    Value<bool>? isClosed,
  }) {
    return SalesCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      tableNumber: tableNumber ?? this.tableNumber,
      accountId: accountId ?? this.accountId,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      deliveryReference: deliveryReference ?? this.deliveryReference,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      taxRate: taxRate ?? this.taxRate,
      isClosed: isClosed ?? this.isClosed,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (tableNumber.present) {
      map['table_number'] = Variable<int>(tableNumber.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    if (customerName.present) {
      map['customer_name'] = Variable<String>(customerName.value);
    }
    if (customerPhone.present) {
      map['customer_phone'] = Variable<String>(customerPhone.value);
    }
    if (deliveryAddress.present) {
      map['delivery_address'] = Variable<String>(deliveryAddress.value);
    }
    if (deliveryReference.present) {
      map['delivery_reference'] = Variable<String>(deliveryReference.value);
    }
    if (deliveryFee.present) {
      map['delivery_fee'] = Variable<double>(deliveryFee.value);
    }
    if (taxRate.present) {
      map['tax_rate'] = Variable<double>(taxRate.value);
    }
    if (isClosed.present) {
      map['is_closed'] = Variable<bool>(isClosed.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SalesCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('createdAt: $createdAt, ')
          ..write('tableNumber: $tableNumber, ')
          ..write('accountId: $accountId, ')
          ..write('customerName: $customerName, ')
          ..write('customerPhone: $customerPhone, ')
          ..write('deliveryAddress: $deliveryAddress, ')
          ..write('deliveryReference: $deliveryReference, ')
          ..write('deliveryFee: $deliveryFee, ')
          ..write('taxRate: $taxRate, ')
          ..write('isClosed: $isClosed')
          ..write(')'))
        .toString();
  }
}

class $SaleItemsTable extends SaleItems
    with TableInfo<$SaleItemsTable, SaleItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SaleItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _saleIdMeta = const VerificationMeta('saleId');
  @override
  late final GeneratedColumn<int> saleId = GeneratedColumn<int>(
    'sale_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<int> productId = GeneratedColumn<int>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productNameMeta = const VerificationMeta(
    'productName',
  );
  @override
  late final GeneratedColumn<String> productName = GeneratedColumn<String>(
    'product_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productImagePathMeta = const VerificationMeta(
    'productImagePath',
  );
  @override
  late final GeneratedColumn<String> productImagePath = GeneratedColumn<String>(
    'product_image_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productCategoryMeta = const VerificationMeta(
    'productCategory',
  );
  @override
  late final GeneratedColumn<String> productCategory = GeneratedColumn<String>(
    'product_category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitPriceMeta = const VerificationMeta(
    'unitPrice',
  );
  @override
  late final GeneratedColumn<double> unitPrice = GeneratedColumn<double>(
    'unit_price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitCostMeta = const VerificationMeta(
    'unitCost',
  );
  @override
  late final GeneratedColumn<double> unitCost = GeneratedColumn<double>(
    'unit_cost',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    saleId,
    productId,
    productName,
    productImagePath,
    productCategory,
    unitPrice,
    unitCost,
    quantity,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sale_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<SaleItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('sale_id')) {
      context.handle(
        _saleIdMeta,
        saleId.isAcceptableOrUnknown(data['sale_id']!, _saleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_saleIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('product_name')) {
      context.handle(
        _productNameMeta,
        productName.isAcceptableOrUnknown(
          data['product_name']!,
          _productNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_productNameMeta);
    }
    if (data.containsKey('product_image_path')) {
      context.handle(
        _productImagePathMeta,
        productImagePath.isAcceptableOrUnknown(
          data['product_image_path']!,
          _productImagePathMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_productImagePathMeta);
    }
    if (data.containsKey('product_category')) {
      context.handle(
        _productCategoryMeta,
        productCategory.isAcceptableOrUnknown(
          data['product_category']!,
          _productCategoryMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_productCategoryMeta);
    }
    if (data.containsKey('unit_price')) {
      context.handle(
        _unitPriceMeta,
        unitPrice.isAcceptableOrUnknown(data['unit_price']!, _unitPriceMeta),
      );
    } else if (isInserting) {
      context.missing(_unitPriceMeta);
    }
    if (data.containsKey('unit_cost')) {
      context.handle(
        _unitCostMeta,
        unitCost.isAcceptableOrUnknown(data['unit_cost']!, _unitCostMeta),
      );
    } else if (isInserting) {
      context.missing(_unitCostMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SaleItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SaleItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      saleId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sale_id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}product_id'],
      )!,
      productName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_name'],
      )!,
      productImagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_image_path'],
      )!,
      productCategory: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_category'],
      )!,
      unitPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}unit_price'],
      )!,
      unitCost: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}unit_cost'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
    );
  }

  @override
  $SaleItemsTable createAlias(String alias) {
    return $SaleItemsTable(attachedDatabase, alias);
  }
}

class SaleItem extends DataClass implements Insertable<SaleItem> {
  final int id;
  final int saleId;
  final int productId;
  final String productName;
  final String productImagePath;
  final String productCategory;
  final double unitPrice;
  final double unitCost;
  final int quantity;
  const SaleItem({
    required this.id,
    required this.saleId,
    required this.productId,
    required this.productName,
    required this.productImagePath,
    required this.productCategory,
    required this.unitPrice,
    required this.unitCost,
    required this.quantity,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['sale_id'] = Variable<int>(saleId);
    map['product_id'] = Variable<int>(productId);
    map['product_name'] = Variable<String>(productName);
    map['product_image_path'] = Variable<String>(productImagePath);
    map['product_category'] = Variable<String>(productCategory);
    map['unit_price'] = Variable<double>(unitPrice);
    map['unit_cost'] = Variable<double>(unitCost);
    map['quantity'] = Variable<int>(quantity);
    return map;
  }

  SaleItemsCompanion toCompanion(bool nullToAbsent) {
    return SaleItemsCompanion(
      id: Value(id),
      saleId: Value(saleId),
      productId: Value(productId),
      productName: Value(productName),
      productImagePath: Value(productImagePath),
      productCategory: Value(productCategory),
      unitPrice: Value(unitPrice),
      unitCost: Value(unitCost),
      quantity: Value(quantity),
    );
  }

  factory SaleItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SaleItem(
      id: serializer.fromJson<int>(json['id']),
      saleId: serializer.fromJson<int>(json['saleId']),
      productId: serializer.fromJson<int>(json['productId']),
      productName: serializer.fromJson<String>(json['productName']),
      productImagePath: serializer.fromJson<String>(json['productImagePath']),
      productCategory: serializer.fromJson<String>(json['productCategory']),
      unitPrice: serializer.fromJson<double>(json['unitPrice']),
      unitCost: serializer.fromJson<double>(json['unitCost']),
      quantity: serializer.fromJson<int>(json['quantity']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'saleId': serializer.toJson<int>(saleId),
      'productId': serializer.toJson<int>(productId),
      'productName': serializer.toJson<String>(productName),
      'productImagePath': serializer.toJson<String>(productImagePath),
      'productCategory': serializer.toJson<String>(productCategory),
      'unitPrice': serializer.toJson<double>(unitPrice),
      'unitCost': serializer.toJson<double>(unitCost),
      'quantity': serializer.toJson<int>(quantity),
    };
  }

  SaleItem copyWith({
    int? id,
    int? saleId,
    int? productId,
    String? productName,
    String? productImagePath,
    String? productCategory,
    double? unitPrice,
    double? unitCost,
    int? quantity,
  }) => SaleItem(
    id: id ?? this.id,
    saleId: saleId ?? this.saleId,
    productId: productId ?? this.productId,
    productName: productName ?? this.productName,
    productImagePath: productImagePath ?? this.productImagePath,
    productCategory: productCategory ?? this.productCategory,
    unitPrice: unitPrice ?? this.unitPrice,
    unitCost: unitCost ?? this.unitCost,
    quantity: quantity ?? this.quantity,
  );
  SaleItem copyWithCompanion(SaleItemsCompanion data) {
    return SaleItem(
      id: data.id.present ? data.id.value : this.id,
      saleId: data.saleId.present ? data.saleId.value : this.saleId,
      productId: data.productId.present ? data.productId.value : this.productId,
      productName: data.productName.present
          ? data.productName.value
          : this.productName,
      productImagePath: data.productImagePath.present
          ? data.productImagePath.value
          : this.productImagePath,
      productCategory: data.productCategory.present
          ? data.productCategory.value
          : this.productCategory,
      unitPrice: data.unitPrice.present ? data.unitPrice.value : this.unitPrice,
      unitCost: data.unitCost.present ? data.unitCost.value : this.unitCost,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SaleItem(')
          ..write('id: $id, ')
          ..write('saleId: $saleId, ')
          ..write('productId: $productId, ')
          ..write('productName: $productName, ')
          ..write('productImagePath: $productImagePath, ')
          ..write('productCategory: $productCategory, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('unitCost: $unitCost, ')
          ..write('quantity: $quantity')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    saleId,
    productId,
    productName,
    productImagePath,
    productCategory,
    unitPrice,
    unitCost,
    quantity,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SaleItem &&
          other.id == this.id &&
          other.saleId == this.saleId &&
          other.productId == this.productId &&
          other.productName == this.productName &&
          other.productImagePath == this.productImagePath &&
          other.productCategory == this.productCategory &&
          other.unitPrice == this.unitPrice &&
          other.unitCost == this.unitCost &&
          other.quantity == this.quantity);
}

class SaleItemsCompanion extends UpdateCompanion<SaleItem> {
  final Value<int> id;
  final Value<int> saleId;
  final Value<int> productId;
  final Value<String> productName;
  final Value<String> productImagePath;
  final Value<String> productCategory;
  final Value<double> unitPrice;
  final Value<double> unitCost;
  final Value<int> quantity;
  const SaleItemsCompanion({
    this.id = const Value.absent(),
    this.saleId = const Value.absent(),
    this.productId = const Value.absent(),
    this.productName = const Value.absent(),
    this.productImagePath = const Value.absent(),
    this.productCategory = const Value.absent(),
    this.unitPrice = const Value.absent(),
    this.unitCost = const Value.absent(),
    this.quantity = const Value.absent(),
  });
  SaleItemsCompanion.insert({
    this.id = const Value.absent(),
    required int saleId,
    required int productId,
    required String productName,
    required String productImagePath,
    required String productCategory,
    required double unitPrice,
    required double unitCost,
    required int quantity,
  }) : saleId = Value(saleId),
       productId = Value(productId),
       productName = Value(productName),
       productImagePath = Value(productImagePath),
       productCategory = Value(productCategory),
       unitPrice = Value(unitPrice),
       unitCost = Value(unitCost),
       quantity = Value(quantity);
  static Insertable<SaleItem> custom({
    Expression<int>? id,
    Expression<int>? saleId,
    Expression<int>? productId,
    Expression<String>? productName,
    Expression<String>? productImagePath,
    Expression<String>? productCategory,
    Expression<double>? unitPrice,
    Expression<double>? unitCost,
    Expression<int>? quantity,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (saleId != null) 'sale_id': saleId,
      if (productId != null) 'product_id': productId,
      if (productName != null) 'product_name': productName,
      if (productImagePath != null) 'product_image_path': productImagePath,
      if (productCategory != null) 'product_category': productCategory,
      if (unitPrice != null) 'unit_price': unitPrice,
      if (unitCost != null) 'unit_cost': unitCost,
      if (quantity != null) 'quantity': quantity,
    });
  }

  SaleItemsCompanion copyWith({
    Value<int>? id,
    Value<int>? saleId,
    Value<int>? productId,
    Value<String>? productName,
    Value<String>? productImagePath,
    Value<String>? productCategory,
    Value<double>? unitPrice,
    Value<double>? unitCost,
    Value<int>? quantity,
  }) {
    return SaleItemsCompanion(
      id: id ?? this.id,
      saleId: saleId ?? this.saleId,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      productImagePath: productImagePath ?? this.productImagePath,
      productCategory: productCategory ?? this.productCategory,
      unitPrice: unitPrice ?? this.unitPrice,
      unitCost: unitCost ?? this.unitCost,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (saleId.present) {
      map['sale_id'] = Variable<int>(saleId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<int>(productId.value);
    }
    if (productName.present) {
      map['product_name'] = Variable<String>(productName.value);
    }
    if (productImagePath.present) {
      map['product_image_path'] = Variable<String>(productImagePath.value);
    }
    if (productCategory.present) {
      map['product_category'] = Variable<String>(productCategory.value);
    }
    if (unitPrice.present) {
      map['unit_price'] = Variable<double>(unitPrice.value);
    }
    if (unitCost.present) {
      map['unit_cost'] = Variable<double>(unitCost.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SaleItemsCompanion(')
          ..write('id: $id, ')
          ..write('saleId: $saleId, ')
          ..write('productId: $productId, ')
          ..write('productName: $productName, ')
          ..write('productImagePath: $productImagePath, ')
          ..write('productCategory: $productCategory, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('unitCost: $unitCost, ')
          ..write('quantity: $quantity')
          ..write(')'))
        .toString();
  }
}

class $PaymentsTable extends Payments with TableInfo<$PaymentsTable, Payment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PaymentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _saleIdMeta = const VerificationMeta('saleId');
  @override
  late final GeneratedColumn<int> saleId = GeneratedColumn<int>(
    'sale_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _methodMeta = const VerificationMeta('method');
  @override
  late final GeneratedColumn<String> method = GeneratedColumn<String>(
    'method',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _receivedAmountMeta = const VerificationMeta(
    'receivedAmount',
  );
  @override
  late final GeneratedColumn<double> receivedAmount = GeneratedColumn<double>(
    'received_amount',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _referenceMeta = const VerificationMeta(
    'reference',
  );
  @override
  late final GeneratedColumn<String> reference = GeneratedColumn<String>(
    'reference',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    saleId,
    method,
    amount,
    receivedAmount,
    reference,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'payments';
  @override
  VerificationContext validateIntegrity(
    Insertable<Payment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('sale_id')) {
      context.handle(
        _saleIdMeta,
        saleId.isAcceptableOrUnknown(data['sale_id']!, _saleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_saleIdMeta);
    }
    if (data.containsKey('method')) {
      context.handle(
        _methodMeta,
        method.isAcceptableOrUnknown(data['method']!, _methodMeta),
      );
    } else if (isInserting) {
      context.missing(_methodMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('received_amount')) {
      context.handle(
        _receivedAmountMeta,
        receivedAmount.isAcceptableOrUnknown(
          data['received_amount']!,
          _receivedAmountMeta,
        ),
      );
    }
    if (data.containsKey('reference')) {
      context.handle(
        _referenceMeta,
        reference.isAcceptableOrUnknown(data['reference']!, _referenceMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Payment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Payment(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      saleId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sale_id'],
      )!,
      method: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}method'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      receivedAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}received_amount'],
      ),
      reference: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reference'],
      ),
    );
  }

  @override
  $PaymentsTable createAlias(String alias) {
    return $PaymentsTable(attachedDatabase, alias);
  }
}

class Payment extends DataClass implements Insertable<Payment> {
  final int id;
  final int saleId;
  final String method;
  final double amount;
  final double? receivedAmount;
  final String? reference;
  const Payment({
    required this.id,
    required this.saleId,
    required this.method,
    required this.amount,
    this.receivedAmount,
    this.reference,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['sale_id'] = Variable<int>(saleId);
    map['method'] = Variable<String>(method);
    map['amount'] = Variable<double>(amount);
    if (!nullToAbsent || receivedAmount != null) {
      map['received_amount'] = Variable<double>(receivedAmount);
    }
    if (!nullToAbsent || reference != null) {
      map['reference'] = Variable<String>(reference);
    }
    return map;
  }

  PaymentsCompanion toCompanion(bool nullToAbsent) {
    return PaymentsCompanion(
      id: Value(id),
      saleId: Value(saleId),
      method: Value(method),
      amount: Value(amount),
      receivedAmount: receivedAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(receivedAmount),
      reference: reference == null && nullToAbsent
          ? const Value.absent()
          : Value(reference),
    );
  }

  factory Payment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Payment(
      id: serializer.fromJson<int>(json['id']),
      saleId: serializer.fromJson<int>(json['saleId']),
      method: serializer.fromJson<String>(json['method']),
      amount: serializer.fromJson<double>(json['amount']),
      receivedAmount: serializer.fromJson<double?>(json['receivedAmount']),
      reference: serializer.fromJson<String?>(json['reference']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'saleId': serializer.toJson<int>(saleId),
      'method': serializer.toJson<String>(method),
      'amount': serializer.toJson<double>(amount),
      'receivedAmount': serializer.toJson<double?>(receivedAmount),
      'reference': serializer.toJson<String?>(reference),
    };
  }

  Payment copyWith({
    int? id,
    int? saleId,
    String? method,
    double? amount,
    Value<double?> receivedAmount = const Value.absent(),
    Value<String?> reference = const Value.absent(),
  }) => Payment(
    id: id ?? this.id,
    saleId: saleId ?? this.saleId,
    method: method ?? this.method,
    amount: amount ?? this.amount,
    receivedAmount: receivedAmount.present
        ? receivedAmount.value
        : this.receivedAmount,
    reference: reference.present ? reference.value : this.reference,
  );
  Payment copyWithCompanion(PaymentsCompanion data) {
    return Payment(
      id: data.id.present ? data.id.value : this.id,
      saleId: data.saleId.present ? data.saleId.value : this.saleId,
      method: data.method.present ? data.method.value : this.method,
      amount: data.amount.present ? data.amount.value : this.amount,
      receivedAmount: data.receivedAmount.present
          ? data.receivedAmount.value
          : this.receivedAmount,
      reference: data.reference.present ? data.reference.value : this.reference,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Payment(')
          ..write('id: $id, ')
          ..write('saleId: $saleId, ')
          ..write('method: $method, ')
          ..write('amount: $amount, ')
          ..write('receivedAmount: $receivedAmount, ')
          ..write('reference: $reference')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, saleId, method, amount, receivedAmount, reference);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Payment &&
          other.id == this.id &&
          other.saleId == this.saleId &&
          other.method == this.method &&
          other.amount == this.amount &&
          other.receivedAmount == this.receivedAmount &&
          other.reference == this.reference);
}

class PaymentsCompanion extends UpdateCompanion<Payment> {
  final Value<int> id;
  final Value<int> saleId;
  final Value<String> method;
  final Value<double> amount;
  final Value<double?> receivedAmount;
  final Value<String?> reference;
  const PaymentsCompanion({
    this.id = const Value.absent(),
    this.saleId = const Value.absent(),
    this.method = const Value.absent(),
    this.amount = const Value.absent(),
    this.receivedAmount = const Value.absent(),
    this.reference = const Value.absent(),
  });
  PaymentsCompanion.insert({
    this.id = const Value.absent(),
    required int saleId,
    required String method,
    required double amount,
    this.receivedAmount = const Value.absent(),
    this.reference = const Value.absent(),
  }) : saleId = Value(saleId),
       method = Value(method),
       amount = Value(amount);
  static Insertable<Payment> custom({
    Expression<int>? id,
    Expression<int>? saleId,
    Expression<String>? method,
    Expression<double>? amount,
    Expression<double>? receivedAmount,
    Expression<String>? reference,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (saleId != null) 'sale_id': saleId,
      if (method != null) 'method': method,
      if (amount != null) 'amount': amount,
      if (receivedAmount != null) 'received_amount': receivedAmount,
      if (reference != null) 'reference': reference,
    });
  }

  PaymentsCompanion copyWith({
    Value<int>? id,
    Value<int>? saleId,
    Value<String>? method,
    Value<double>? amount,
    Value<double?>? receivedAmount,
    Value<String?>? reference,
  }) {
    return PaymentsCompanion(
      id: id ?? this.id,
      saleId: saleId ?? this.saleId,
      method: method ?? this.method,
      amount: amount ?? this.amount,
      receivedAmount: receivedAmount ?? this.receivedAmount,
      reference: reference ?? this.reference,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (saleId.present) {
      map['sale_id'] = Variable<int>(saleId.value);
    }
    if (method.present) {
      map['method'] = Variable<String>(method.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (receivedAmount.present) {
      map['received_amount'] = Variable<double>(receivedAmount.value);
    }
    if (reference.present) {
      map['reference'] = Variable<String>(reference.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PaymentsCompanion(')
          ..write('id: $id, ')
          ..write('saleId: $saleId, ')
          ..write('method: $method, ')
          ..write('amount: $amount, ')
          ..write('receivedAmount: $receivedAmount, ')
          ..write('reference: $reference')
          ..write(')'))
        .toString();
  }
}

class $TableAccountsTable extends TableAccounts
    with TableInfo<$TableAccountsTable, TableAccount> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TableAccountsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tableNumberMeta = const VerificationMeta(
    'tableNumber',
  );
  @override
  late final GeneratedColumn<int> tableNumber = GeneratedColumn<int>(
    'table_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _customerNameMeta = const VerificationMeta(
    'customerName',
  );
  @override
  late final GeneratedColumn<String> customerName = GeneratedColumn<String>(
    'customer_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _openedAtMeta = const VerificationMeta(
    'openedAt',
  );
  @override
  late final GeneratedColumn<DateTime> openedAt = GeneratedColumn<DateTime>(
    'opened_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isClosedMeta = const VerificationMeta(
    'isClosed',
  );
  @override
  late final GeneratedColumn<bool> isClosed = GeneratedColumn<bool>(
    'is_closed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_closed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tableNumber,
    customerName,
    openedAt,
    isClosed,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'table_accounts';
  @override
  VerificationContext validateIntegrity(
    Insertable<TableAccount> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('table_number')) {
      context.handle(
        _tableNumberMeta,
        tableNumber.isAcceptableOrUnknown(
          data['table_number']!,
          _tableNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_tableNumberMeta);
    }
    if (data.containsKey('customer_name')) {
      context.handle(
        _customerNameMeta,
        customerName.isAcceptableOrUnknown(
          data['customer_name']!,
          _customerNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_customerNameMeta);
    }
    if (data.containsKey('opened_at')) {
      context.handle(
        _openedAtMeta,
        openedAt.isAcceptableOrUnknown(data['opened_at']!, _openedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_openedAtMeta);
    }
    if (data.containsKey('is_closed')) {
      context.handle(
        _isClosedMeta,
        isClosed.isAcceptableOrUnknown(data['is_closed']!, _isClosedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TableAccount map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TableAccount(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      tableNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}table_number'],
      )!,
      customerName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_name'],
      )!,
      openedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}opened_at'],
      )!,
      isClosed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_closed'],
      )!,
    );
  }

  @override
  $TableAccountsTable createAlias(String alias) {
    return $TableAccountsTable(attachedDatabase, alias);
  }
}

class TableAccount extends DataClass implements Insertable<TableAccount> {
  final int id;
  final int tableNumber;
  final String customerName;
  final DateTime openedAt;
  final bool isClosed;
  const TableAccount({
    required this.id,
    required this.tableNumber,
    required this.customerName,
    required this.openedAt,
    required this.isClosed,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['table_number'] = Variable<int>(tableNumber);
    map['customer_name'] = Variable<String>(customerName);
    map['opened_at'] = Variable<DateTime>(openedAt);
    map['is_closed'] = Variable<bool>(isClosed);
    return map;
  }

  TableAccountsCompanion toCompanion(bool nullToAbsent) {
    return TableAccountsCompanion(
      id: Value(id),
      tableNumber: Value(tableNumber),
      customerName: Value(customerName),
      openedAt: Value(openedAt),
      isClosed: Value(isClosed),
    );
  }

  factory TableAccount.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TableAccount(
      id: serializer.fromJson<int>(json['id']),
      tableNumber: serializer.fromJson<int>(json['tableNumber']),
      customerName: serializer.fromJson<String>(json['customerName']),
      openedAt: serializer.fromJson<DateTime>(json['openedAt']),
      isClosed: serializer.fromJson<bool>(json['isClosed']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'tableNumber': serializer.toJson<int>(tableNumber),
      'customerName': serializer.toJson<String>(customerName),
      'openedAt': serializer.toJson<DateTime>(openedAt),
      'isClosed': serializer.toJson<bool>(isClosed),
    };
  }

  TableAccount copyWith({
    int? id,
    int? tableNumber,
    String? customerName,
    DateTime? openedAt,
    bool? isClosed,
  }) => TableAccount(
    id: id ?? this.id,
    tableNumber: tableNumber ?? this.tableNumber,
    customerName: customerName ?? this.customerName,
    openedAt: openedAt ?? this.openedAt,
    isClosed: isClosed ?? this.isClosed,
  );
  TableAccount copyWithCompanion(TableAccountsCompanion data) {
    return TableAccount(
      id: data.id.present ? data.id.value : this.id,
      tableNumber: data.tableNumber.present
          ? data.tableNumber.value
          : this.tableNumber,
      customerName: data.customerName.present
          ? data.customerName.value
          : this.customerName,
      openedAt: data.openedAt.present ? data.openedAt.value : this.openedAt,
      isClosed: data.isClosed.present ? data.isClosed.value : this.isClosed,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TableAccount(')
          ..write('id: $id, ')
          ..write('tableNumber: $tableNumber, ')
          ..write('customerName: $customerName, ')
          ..write('openedAt: $openedAt, ')
          ..write('isClosed: $isClosed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, tableNumber, customerName, openedAt, isClosed);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TableAccount &&
          other.id == this.id &&
          other.tableNumber == this.tableNumber &&
          other.customerName == this.customerName &&
          other.openedAt == this.openedAt &&
          other.isClosed == this.isClosed);
}

class TableAccountsCompanion extends UpdateCompanion<TableAccount> {
  final Value<int> id;
  final Value<int> tableNumber;
  final Value<String> customerName;
  final Value<DateTime> openedAt;
  final Value<bool> isClosed;
  const TableAccountsCompanion({
    this.id = const Value.absent(),
    this.tableNumber = const Value.absent(),
    this.customerName = const Value.absent(),
    this.openedAt = const Value.absent(),
    this.isClosed = const Value.absent(),
  });
  TableAccountsCompanion.insert({
    this.id = const Value.absent(),
    required int tableNumber,
    required String customerName,
    required DateTime openedAt,
    this.isClosed = const Value.absent(),
  }) : tableNumber = Value(tableNumber),
       customerName = Value(customerName),
       openedAt = Value(openedAt);
  static Insertable<TableAccount> custom({
    Expression<int>? id,
    Expression<int>? tableNumber,
    Expression<String>? customerName,
    Expression<DateTime>? openedAt,
    Expression<bool>? isClosed,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tableNumber != null) 'table_number': tableNumber,
      if (customerName != null) 'customer_name': customerName,
      if (openedAt != null) 'opened_at': openedAt,
      if (isClosed != null) 'is_closed': isClosed,
    });
  }

  TableAccountsCompanion copyWith({
    Value<int>? id,
    Value<int>? tableNumber,
    Value<String>? customerName,
    Value<DateTime>? openedAt,
    Value<bool>? isClosed,
  }) {
    return TableAccountsCompanion(
      id: id ?? this.id,
      tableNumber: tableNumber ?? this.tableNumber,
      customerName: customerName ?? this.customerName,
      openedAt: openedAt ?? this.openedAt,
      isClosed: isClosed ?? this.isClosed,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (tableNumber.present) {
      map['table_number'] = Variable<int>(tableNumber.value);
    }
    if (customerName.present) {
      map['customer_name'] = Variable<String>(customerName.value);
    }
    if (openedAt.present) {
      map['opened_at'] = Variable<DateTime>(openedAt.value);
    }
    if (isClosed.present) {
      map['is_closed'] = Variable<bool>(isClosed.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TableAccountsCompanion(')
          ..write('id: $id, ')
          ..write('tableNumber: $tableNumber, ')
          ..write('customerName: $customerName, ')
          ..write('openedAt: $openedAt, ')
          ..write('isClosed: $isClosed')
          ..write(')'))
        .toString();
  }
}

class $AccountItemsTable extends AccountItems
    with TableInfo<$AccountItemsTable, AccountItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AccountItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<int> productId = GeneratedColumn<int>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productNameMeta = const VerificationMeta(
    'productName',
  );
  @override
  late final GeneratedColumn<String> productName = GeneratedColumn<String>(
    'product_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productImagePathMeta = const VerificationMeta(
    'productImagePath',
  );
  @override
  late final GeneratedColumn<String> productImagePath = GeneratedColumn<String>(
    'product_image_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productCategoryMeta = const VerificationMeta(
    'productCategory',
  );
  @override
  late final GeneratedColumn<String> productCategory = GeneratedColumn<String>(
    'product_category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitPriceMeta = const VerificationMeta(
    'unitPrice',
  );
  @override
  late final GeneratedColumn<double> unitPrice = GeneratedColumn<double>(
    'unit_price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitCostMeta = const VerificationMeta(
    'unitCost',
  );
  @override
  late final GeneratedColumn<double> unitCost = GeneratedColumn<double>(
    'unit_cost',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    accountId,
    productId,
    productName,
    productImagePath,
    productCategory,
    unitPrice,
    unitCost,
    quantity,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'account_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<AccountItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('product_name')) {
      context.handle(
        _productNameMeta,
        productName.isAcceptableOrUnknown(
          data['product_name']!,
          _productNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_productNameMeta);
    }
    if (data.containsKey('product_image_path')) {
      context.handle(
        _productImagePathMeta,
        productImagePath.isAcceptableOrUnknown(
          data['product_image_path']!,
          _productImagePathMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_productImagePathMeta);
    }
    if (data.containsKey('product_category')) {
      context.handle(
        _productCategoryMeta,
        productCategory.isAcceptableOrUnknown(
          data['product_category']!,
          _productCategoryMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_productCategoryMeta);
    }
    if (data.containsKey('unit_price')) {
      context.handle(
        _unitPriceMeta,
        unitPrice.isAcceptableOrUnknown(data['unit_price']!, _unitPriceMeta),
      );
    } else if (isInserting) {
      context.missing(_unitPriceMeta);
    }
    if (data.containsKey('unit_cost')) {
      context.handle(
        _unitCostMeta,
        unitCost.isAcceptableOrUnknown(data['unit_cost']!, _unitCostMeta),
      );
    } else if (isInserting) {
      context.missing(_unitCostMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AccountItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AccountItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}account_id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}product_id'],
      )!,
      productName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_name'],
      )!,
      productImagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_image_path'],
      )!,
      productCategory: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_category'],
      )!,
      unitPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}unit_price'],
      )!,
      unitCost: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}unit_cost'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
    );
  }

  @override
  $AccountItemsTable createAlias(String alias) {
    return $AccountItemsTable(attachedDatabase, alias);
  }
}

class AccountItem extends DataClass implements Insertable<AccountItem> {
  final int id;
  final int accountId;
  final int productId;
  final String productName;
  final String productImagePath;
  final String productCategory;
  final double unitPrice;
  final double unitCost;
  final int quantity;
  const AccountItem({
    required this.id,
    required this.accountId,
    required this.productId,
    required this.productName,
    required this.productImagePath,
    required this.productCategory,
    required this.unitPrice,
    required this.unitCost,
    required this.quantity,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['account_id'] = Variable<int>(accountId);
    map['product_id'] = Variable<int>(productId);
    map['product_name'] = Variable<String>(productName);
    map['product_image_path'] = Variable<String>(productImagePath);
    map['product_category'] = Variable<String>(productCategory);
    map['unit_price'] = Variable<double>(unitPrice);
    map['unit_cost'] = Variable<double>(unitCost);
    map['quantity'] = Variable<int>(quantity);
    return map;
  }

  AccountItemsCompanion toCompanion(bool nullToAbsent) {
    return AccountItemsCompanion(
      id: Value(id),
      accountId: Value(accountId),
      productId: Value(productId),
      productName: Value(productName),
      productImagePath: Value(productImagePath),
      productCategory: Value(productCategory),
      unitPrice: Value(unitPrice),
      unitCost: Value(unitCost),
      quantity: Value(quantity),
    );
  }

  factory AccountItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AccountItem(
      id: serializer.fromJson<int>(json['id']),
      accountId: serializer.fromJson<int>(json['accountId']),
      productId: serializer.fromJson<int>(json['productId']),
      productName: serializer.fromJson<String>(json['productName']),
      productImagePath: serializer.fromJson<String>(json['productImagePath']),
      productCategory: serializer.fromJson<String>(json['productCategory']),
      unitPrice: serializer.fromJson<double>(json['unitPrice']),
      unitCost: serializer.fromJson<double>(json['unitCost']),
      quantity: serializer.fromJson<int>(json['quantity']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'accountId': serializer.toJson<int>(accountId),
      'productId': serializer.toJson<int>(productId),
      'productName': serializer.toJson<String>(productName),
      'productImagePath': serializer.toJson<String>(productImagePath),
      'productCategory': serializer.toJson<String>(productCategory),
      'unitPrice': serializer.toJson<double>(unitPrice),
      'unitCost': serializer.toJson<double>(unitCost),
      'quantity': serializer.toJson<int>(quantity),
    };
  }

  AccountItem copyWith({
    int? id,
    int? accountId,
    int? productId,
    String? productName,
    String? productImagePath,
    String? productCategory,
    double? unitPrice,
    double? unitCost,
    int? quantity,
  }) => AccountItem(
    id: id ?? this.id,
    accountId: accountId ?? this.accountId,
    productId: productId ?? this.productId,
    productName: productName ?? this.productName,
    productImagePath: productImagePath ?? this.productImagePath,
    productCategory: productCategory ?? this.productCategory,
    unitPrice: unitPrice ?? this.unitPrice,
    unitCost: unitCost ?? this.unitCost,
    quantity: quantity ?? this.quantity,
  );
  AccountItem copyWithCompanion(AccountItemsCompanion data) {
    return AccountItem(
      id: data.id.present ? data.id.value : this.id,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      productId: data.productId.present ? data.productId.value : this.productId,
      productName: data.productName.present
          ? data.productName.value
          : this.productName,
      productImagePath: data.productImagePath.present
          ? data.productImagePath.value
          : this.productImagePath,
      productCategory: data.productCategory.present
          ? data.productCategory.value
          : this.productCategory,
      unitPrice: data.unitPrice.present ? data.unitPrice.value : this.unitPrice,
      unitCost: data.unitCost.present ? data.unitCost.value : this.unitCost,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AccountItem(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('productId: $productId, ')
          ..write('productName: $productName, ')
          ..write('productImagePath: $productImagePath, ')
          ..write('productCategory: $productCategory, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('unitCost: $unitCost, ')
          ..write('quantity: $quantity')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    accountId,
    productId,
    productName,
    productImagePath,
    productCategory,
    unitPrice,
    unitCost,
    quantity,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AccountItem &&
          other.id == this.id &&
          other.accountId == this.accountId &&
          other.productId == this.productId &&
          other.productName == this.productName &&
          other.productImagePath == this.productImagePath &&
          other.productCategory == this.productCategory &&
          other.unitPrice == this.unitPrice &&
          other.unitCost == this.unitCost &&
          other.quantity == this.quantity);
}

class AccountItemsCompanion extends UpdateCompanion<AccountItem> {
  final Value<int> id;
  final Value<int> accountId;
  final Value<int> productId;
  final Value<String> productName;
  final Value<String> productImagePath;
  final Value<String> productCategory;
  final Value<double> unitPrice;
  final Value<double> unitCost;
  final Value<int> quantity;
  const AccountItemsCompanion({
    this.id = const Value.absent(),
    this.accountId = const Value.absent(),
    this.productId = const Value.absent(),
    this.productName = const Value.absent(),
    this.productImagePath = const Value.absent(),
    this.productCategory = const Value.absent(),
    this.unitPrice = const Value.absent(),
    this.unitCost = const Value.absent(),
    this.quantity = const Value.absent(),
  });
  AccountItemsCompanion.insert({
    this.id = const Value.absent(),
    required int accountId,
    required int productId,
    required String productName,
    required String productImagePath,
    required String productCategory,
    required double unitPrice,
    required double unitCost,
    required int quantity,
  }) : accountId = Value(accountId),
       productId = Value(productId),
       productName = Value(productName),
       productImagePath = Value(productImagePath),
       productCategory = Value(productCategory),
       unitPrice = Value(unitPrice),
       unitCost = Value(unitCost),
       quantity = Value(quantity);
  static Insertable<AccountItem> custom({
    Expression<int>? id,
    Expression<int>? accountId,
    Expression<int>? productId,
    Expression<String>? productName,
    Expression<String>? productImagePath,
    Expression<String>? productCategory,
    Expression<double>? unitPrice,
    Expression<double>? unitCost,
    Expression<int>? quantity,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accountId != null) 'account_id': accountId,
      if (productId != null) 'product_id': productId,
      if (productName != null) 'product_name': productName,
      if (productImagePath != null) 'product_image_path': productImagePath,
      if (productCategory != null) 'product_category': productCategory,
      if (unitPrice != null) 'unit_price': unitPrice,
      if (unitCost != null) 'unit_cost': unitCost,
      if (quantity != null) 'quantity': quantity,
    });
  }

  AccountItemsCompanion copyWith({
    Value<int>? id,
    Value<int>? accountId,
    Value<int>? productId,
    Value<String>? productName,
    Value<String>? productImagePath,
    Value<String>? productCategory,
    Value<double>? unitPrice,
    Value<double>? unitCost,
    Value<int>? quantity,
  }) {
    return AccountItemsCompanion(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      productImagePath: productImagePath ?? this.productImagePath,
      productCategory: productCategory ?? this.productCategory,
      unitPrice: unitPrice ?? this.unitPrice,
      unitCost: unitCost ?? this.unitCost,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<int>(productId.value);
    }
    if (productName.present) {
      map['product_name'] = Variable<String>(productName.value);
    }
    if (productImagePath.present) {
      map['product_image_path'] = Variable<String>(productImagePath.value);
    }
    if (productCategory.present) {
      map['product_category'] = Variable<String>(productCategory.value);
    }
    if (unitPrice.present) {
      map['unit_price'] = Variable<double>(unitPrice.value);
    }
    if (unitCost.present) {
      map['unit_cost'] = Variable<double>(unitCost.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccountItemsCompanion(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('productId: $productId, ')
          ..write('productName: $productName, ')
          ..write('productImagePath: $productImagePath, ')
          ..write('productCategory: $productCategory, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('unitCost: $unitCost, ')
          ..write('quantity: $quantity')
          ..write(')'))
        .toString();
  }
}

class $CashSessionsTable extends CashSessions
    with TableInfo<$CashSessionsTable, CashSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CashSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _openedAtMeta = const VerificationMeta(
    'openedAt',
  );
  @override
  late final GeneratedColumn<DateTime> openedAt = GeneratedColumn<DateTime>(
    'opened_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _openingAmountMeta = const VerificationMeta(
    'openingAmount',
  );
  @override
  late final GeneratedColumn<double> openingAmount = GeneratedColumn<double>(
    'opening_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _closedAtMeta = const VerificationMeta(
    'closedAt',
  );
  @override
  late final GeneratedColumn<DateTime> closedAt = GeneratedColumn<DateTime>(
    'closed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _closingAmountMeta = const VerificationMeta(
    'closingAmount',
  );
  @override
  late final GeneratedColumn<double> closingAmount = GeneratedColumn<double>(
    'closing_amount',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isOpenMeta = const VerificationMeta('isOpen');
  @override
  late final GeneratedColumn<bool> isOpen = GeneratedColumn<bool>(
    'is_open',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_open" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    openedAt,
    openingAmount,
    closedAt,
    closingAmount,
    isOpen,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cash_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<CashSession> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('opened_at')) {
      context.handle(
        _openedAtMeta,
        openedAt.isAcceptableOrUnknown(data['opened_at']!, _openedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_openedAtMeta);
    }
    if (data.containsKey('opening_amount')) {
      context.handle(
        _openingAmountMeta,
        openingAmount.isAcceptableOrUnknown(
          data['opening_amount']!,
          _openingAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_openingAmountMeta);
    }
    if (data.containsKey('closed_at')) {
      context.handle(
        _closedAtMeta,
        closedAt.isAcceptableOrUnknown(data['closed_at']!, _closedAtMeta),
      );
    }
    if (data.containsKey('closing_amount')) {
      context.handle(
        _closingAmountMeta,
        closingAmount.isAcceptableOrUnknown(
          data['closing_amount']!,
          _closingAmountMeta,
        ),
      );
    }
    if (data.containsKey('is_open')) {
      context.handle(
        _isOpenMeta,
        isOpen.isAcceptableOrUnknown(data['is_open']!, _isOpenMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CashSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CashSession(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      openedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}opened_at'],
      )!,
      openingAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}opening_amount'],
      )!,
      closedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}closed_at'],
      ),
      closingAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}closing_amount'],
      ),
      isOpen: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_open'],
      )!,
    );
  }

  @override
  $CashSessionsTable createAlias(String alias) {
    return $CashSessionsTable(attachedDatabase, alias);
  }
}

class CashSession extends DataClass implements Insertable<CashSession> {
  final int id;
  final DateTime openedAt;
  final double openingAmount;
  final DateTime? closedAt;
  final double? closingAmount;
  final bool isOpen;
  const CashSession({
    required this.id,
    required this.openedAt,
    required this.openingAmount,
    this.closedAt,
    this.closingAmount,
    required this.isOpen,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['opened_at'] = Variable<DateTime>(openedAt);
    map['opening_amount'] = Variable<double>(openingAmount);
    if (!nullToAbsent || closedAt != null) {
      map['closed_at'] = Variable<DateTime>(closedAt);
    }
    if (!nullToAbsent || closingAmount != null) {
      map['closing_amount'] = Variable<double>(closingAmount);
    }
    map['is_open'] = Variable<bool>(isOpen);
    return map;
  }

  CashSessionsCompanion toCompanion(bool nullToAbsent) {
    return CashSessionsCompanion(
      id: Value(id),
      openedAt: Value(openedAt),
      openingAmount: Value(openingAmount),
      closedAt: closedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(closedAt),
      closingAmount: closingAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(closingAmount),
      isOpen: Value(isOpen),
    );
  }

  factory CashSession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CashSession(
      id: serializer.fromJson<int>(json['id']),
      openedAt: serializer.fromJson<DateTime>(json['openedAt']),
      openingAmount: serializer.fromJson<double>(json['openingAmount']),
      closedAt: serializer.fromJson<DateTime?>(json['closedAt']),
      closingAmount: serializer.fromJson<double?>(json['closingAmount']),
      isOpen: serializer.fromJson<bool>(json['isOpen']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'openedAt': serializer.toJson<DateTime>(openedAt),
      'openingAmount': serializer.toJson<double>(openingAmount),
      'closedAt': serializer.toJson<DateTime?>(closedAt),
      'closingAmount': serializer.toJson<double?>(closingAmount),
      'isOpen': serializer.toJson<bool>(isOpen),
    };
  }

  CashSession copyWith({
    int? id,
    DateTime? openedAt,
    double? openingAmount,
    Value<DateTime?> closedAt = const Value.absent(),
    Value<double?> closingAmount = const Value.absent(),
    bool? isOpen,
  }) => CashSession(
    id: id ?? this.id,
    openedAt: openedAt ?? this.openedAt,
    openingAmount: openingAmount ?? this.openingAmount,
    closedAt: closedAt.present ? closedAt.value : this.closedAt,
    closingAmount: closingAmount.present
        ? closingAmount.value
        : this.closingAmount,
    isOpen: isOpen ?? this.isOpen,
  );
  CashSession copyWithCompanion(CashSessionsCompanion data) {
    return CashSession(
      id: data.id.present ? data.id.value : this.id,
      openedAt: data.openedAt.present ? data.openedAt.value : this.openedAt,
      openingAmount: data.openingAmount.present
          ? data.openingAmount.value
          : this.openingAmount,
      closedAt: data.closedAt.present ? data.closedAt.value : this.closedAt,
      closingAmount: data.closingAmount.present
          ? data.closingAmount.value
          : this.closingAmount,
      isOpen: data.isOpen.present ? data.isOpen.value : this.isOpen,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CashSession(')
          ..write('id: $id, ')
          ..write('openedAt: $openedAt, ')
          ..write('openingAmount: $openingAmount, ')
          ..write('closedAt: $closedAt, ')
          ..write('closingAmount: $closingAmount, ')
          ..write('isOpen: $isOpen')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, openedAt, openingAmount, closedAt, closingAmount, isOpen);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CashSession &&
          other.id == this.id &&
          other.openedAt == this.openedAt &&
          other.openingAmount == this.openingAmount &&
          other.closedAt == this.closedAt &&
          other.closingAmount == this.closingAmount &&
          other.isOpen == this.isOpen);
}

class CashSessionsCompanion extends UpdateCompanion<CashSession> {
  final Value<int> id;
  final Value<DateTime> openedAt;
  final Value<double> openingAmount;
  final Value<DateTime?> closedAt;
  final Value<double?> closingAmount;
  final Value<bool> isOpen;
  const CashSessionsCompanion({
    this.id = const Value.absent(),
    this.openedAt = const Value.absent(),
    this.openingAmount = const Value.absent(),
    this.closedAt = const Value.absent(),
    this.closingAmount = const Value.absent(),
    this.isOpen = const Value.absent(),
  });
  CashSessionsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime openedAt,
    required double openingAmount,
    this.closedAt = const Value.absent(),
    this.closingAmount = const Value.absent(),
    this.isOpen = const Value.absent(),
  }) : openedAt = Value(openedAt),
       openingAmount = Value(openingAmount);
  static Insertable<CashSession> custom({
    Expression<int>? id,
    Expression<DateTime>? openedAt,
    Expression<double>? openingAmount,
    Expression<DateTime>? closedAt,
    Expression<double>? closingAmount,
    Expression<bool>? isOpen,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (openedAt != null) 'opened_at': openedAt,
      if (openingAmount != null) 'opening_amount': openingAmount,
      if (closedAt != null) 'closed_at': closedAt,
      if (closingAmount != null) 'closing_amount': closingAmount,
      if (isOpen != null) 'is_open': isOpen,
    });
  }

  CashSessionsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? openedAt,
    Value<double>? openingAmount,
    Value<DateTime?>? closedAt,
    Value<double?>? closingAmount,
    Value<bool>? isOpen,
  }) {
    return CashSessionsCompanion(
      id: id ?? this.id,
      openedAt: openedAt ?? this.openedAt,
      openingAmount: openingAmount ?? this.openingAmount,
      closedAt: closedAt ?? this.closedAt,
      closingAmount: closingAmount ?? this.closingAmount,
      isOpen: isOpen ?? this.isOpen,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (openedAt.present) {
      map['opened_at'] = Variable<DateTime>(openedAt.value);
    }
    if (openingAmount.present) {
      map['opening_amount'] = Variable<double>(openingAmount.value);
    }
    if (closedAt.present) {
      map['closed_at'] = Variable<DateTime>(closedAt.value);
    }
    if (closingAmount.present) {
      map['closing_amount'] = Variable<double>(closingAmount.value);
    }
    if (isOpen.present) {
      map['is_open'] = Variable<bool>(isOpen.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CashSessionsCompanion(')
          ..write('id: $id, ')
          ..write('openedAt: $openedAt, ')
          ..write('openingAmount: $openingAmount, ')
          ..write('closedAt: $closedAt, ')
          ..write('closingAmount: $closingAmount, ')
          ..write('isOpen: $isOpen')
          ..write(')'))
        .toString();
  }
}

class $BusinessSettingsTable extends BusinessSettings
    with TableInfo<$BusinessSettingsTable, BusinessSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BusinessSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _enableTableSalesMeta = const VerificationMeta(
    'enableTableSales',
  );
  @override
  late final GeneratedColumn<bool> enableTableSales = GeneratedColumn<bool>(
    'enable_table_sales',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enable_table_sales" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _enableBarSalesMeta = const VerificationMeta(
    'enableBarSales',
  );
  @override
  late final GeneratedColumn<bool> enableBarSales = GeneratedColumn<bool>(
    'enable_bar_sales',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enable_bar_sales" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _enableQuickSaleMeta = const VerificationMeta(
    'enableQuickSale',
  );
  @override
  late final GeneratedColumn<bool> enableQuickSale = GeneratedColumn<bool>(
    'enable_quick_sale',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enable_quick_sale" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _enableTakeawayMeta = const VerificationMeta(
    'enableTakeaway',
  );
  @override
  late final GeneratedColumn<bool> enableTakeaway = GeneratedColumn<bool>(
    'enable_takeaway',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enable_takeaway" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _enableDeliveryMeta = const VerificationMeta(
    'enableDelivery',
  );
  @override
  late final GeneratedColumn<bool> enableDelivery = GeneratedColumn<bool>(
    'enable_delivery',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enable_delivery" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    enableTableSales,
    enableBarSales,
    enableQuickSale,
    enableTakeaway,
    enableDelivery,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'business_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<BusinessSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('enable_table_sales')) {
      context.handle(
        _enableTableSalesMeta,
        enableTableSales.isAcceptableOrUnknown(
          data['enable_table_sales']!,
          _enableTableSalesMeta,
        ),
      );
    }
    if (data.containsKey('enable_bar_sales')) {
      context.handle(
        _enableBarSalesMeta,
        enableBarSales.isAcceptableOrUnknown(
          data['enable_bar_sales']!,
          _enableBarSalesMeta,
        ),
      );
    }
    if (data.containsKey('enable_quick_sale')) {
      context.handle(
        _enableQuickSaleMeta,
        enableQuickSale.isAcceptableOrUnknown(
          data['enable_quick_sale']!,
          _enableQuickSaleMeta,
        ),
      );
    }
    if (data.containsKey('enable_takeaway')) {
      context.handle(
        _enableTakeawayMeta,
        enableTakeaway.isAcceptableOrUnknown(
          data['enable_takeaway']!,
          _enableTakeawayMeta,
        ),
      );
    }
    if (data.containsKey('enable_delivery')) {
      context.handle(
        _enableDeliveryMeta,
        enableDelivery.isAcceptableOrUnknown(
          data['enable_delivery']!,
          _enableDeliveryMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BusinessSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BusinessSetting(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      enableTableSales: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enable_table_sales'],
      )!,
      enableBarSales: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enable_bar_sales'],
      )!,
      enableQuickSale: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enable_quick_sale'],
      )!,
      enableTakeaway: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enable_takeaway'],
      )!,
      enableDelivery: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enable_delivery'],
      )!,
    );
  }

  @override
  $BusinessSettingsTable createAlias(String alias) {
    return $BusinessSettingsTable(attachedDatabase, alias);
  }
}

class BusinessSetting extends DataClass implements Insertable<BusinessSetting> {
  final int id;
  final bool enableTableSales;
  final bool enableBarSales;
  final bool enableQuickSale;
  final bool enableTakeaway;
  final bool enableDelivery;
  const BusinessSetting({
    required this.id,
    required this.enableTableSales,
    required this.enableBarSales,
    required this.enableQuickSale,
    required this.enableTakeaway,
    required this.enableDelivery,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['enable_table_sales'] = Variable<bool>(enableTableSales);
    map['enable_bar_sales'] = Variable<bool>(enableBarSales);
    map['enable_quick_sale'] = Variable<bool>(enableQuickSale);
    map['enable_takeaway'] = Variable<bool>(enableTakeaway);
    map['enable_delivery'] = Variable<bool>(enableDelivery);
    return map;
  }

  BusinessSettingsCompanion toCompanion(bool nullToAbsent) {
    return BusinessSettingsCompanion(
      id: Value(id),
      enableTableSales: Value(enableTableSales),
      enableBarSales: Value(enableBarSales),
      enableQuickSale: Value(enableQuickSale),
      enableTakeaway: Value(enableTakeaway),
      enableDelivery: Value(enableDelivery),
    );
  }

  factory BusinessSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BusinessSetting(
      id: serializer.fromJson<int>(json['id']),
      enableTableSales: serializer.fromJson<bool>(json['enableTableSales']),
      enableBarSales: serializer.fromJson<bool>(json['enableBarSales']),
      enableQuickSale: serializer.fromJson<bool>(json['enableQuickSale']),
      enableTakeaway: serializer.fromJson<bool>(json['enableTakeaway']),
      enableDelivery: serializer.fromJson<bool>(json['enableDelivery']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'enableTableSales': serializer.toJson<bool>(enableTableSales),
      'enableBarSales': serializer.toJson<bool>(enableBarSales),
      'enableQuickSale': serializer.toJson<bool>(enableQuickSale),
      'enableTakeaway': serializer.toJson<bool>(enableTakeaway),
      'enableDelivery': serializer.toJson<bool>(enableDelivery),
    };
  }

  BusinessSetting copyWith({
    int? id,
    bool? enableTableSales,
    bool? enableBarSales,
    bool? enableQuickSale,
    bool? enableTakeaway,
    bool? enableDelivery,
  }) => BusinessSetting(
    id: id ?? this.id,
    enableTableSales: enableTableSales ?? this.enableTableSales,
    enableBarSales: enableBarSales ?? this.enableBarSales,
    enableQuickSale: enableQuickSale ?? this.enableQuickSale,
    enableTakeaway: enableTakeaway ?? this.enableTakeaway,
    enableDelivery: enableDelivery ?? this.enableDelivery,
  );
  BusinessSetting copyWithCompanion(BusinessSettingsCompanion data) {
    return BusinessSetting(
      id: data.id.present ? data.id.value : this.id,
      enableTableSales: data.enableTableSales.present
          ? data.enableTableSales.value
          : this.enableTableSales,
      enableBarSales: data.enableBarSales.present
          ? data.enableBarSales.value
          : this.enableBarSales,
      enableQuickSale: data.enableQuickSale.present
          ? data.enableQuickSale.value
          : this.enableQuickSale,
      enableTakeaway: data.enableTakeaway.present
          ? data.enableTakeaway.value
          : this.enableTakeaway,
      enableDelivery: data.enableDelivery.present
          ? data.enableDelivery.value
          : this.enableDelivery,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BusinessSetting(')
          ..write('id: $id, ')
          ..write('enableTableSales: $enableTableSales, ')
          ..write('enableBarSales: $enableBarSales, ')
          ..write('enableQuickSale: $enableQuickSale, ')
          ..write('enableTakeaway: $enableTakeaway, ')
          ..write('enableDelivery: $enableDelivery')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    enableTableSales,
    enableBarSales,
    enableQuickSale,
    enableTakeaway,
    enableDelivery,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BusinessSetting &&
          other.id == this.id &&
          other.enableTableSales == this.enableTableSales &&
          other.enableBarSales == this.enableBarSales &&
          other.enableQuickSale == this.enableQuickSale &&
          other.enableTakeaway == this.enableTakeaway &&
          other.enableDelivery == this.enableDelivery);
}

class BusinessSettingsCompanion extends UpdateCompanion<BusinessSetting> {
  final Value<int> id;
  final Value<bool> enableTableSales;
  final Value<bool> enableBarSales;
  final Value<bool> enableQuickSale;
  final Value<bool> enableTakeaway;
  final Value<bool> enableDelivery;
  const BusinessSettingsCompanion({
    this.id = const Value.absent(),
    this.enableTableSales = const Value.absent(),
    this.enableBarSales = const Value.absent(),
    this.enableQuickSale = const Value.absent(),
    this.enableTakeaway = const Value.absent(),
    this.enableDelivery = const Value.absent(),
  });
  BusinessSettingsCompanion.insert({
    this.id = const Value.absent(),
    this.enableTableSales = const Value.absent(),
    this.enableBarSales = const Value.absent(),
    this.enableQuickSale = const Value.absent(),
    this.enableTakeaway = const Value.absent(),
    this.enableDelivery = const Value.absent(),
  });
  static Insertable<BusinessSetting> custom({
    Expression<int>? id,
    Expression<bool>? enableTableSales,
    Expression<bool>? enableBarSales,
    Expression<bool>? enableQuickSale,
    Expression<bool>? enableTakeaway,
    Expression<bool>? enableDelivery,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (enableTableSales != null) 'enable_table_sales': enableTableSales,
      if (enableBarSales != null) 'enable_bar_sales': enableBarSales,
      if (enableQuickSale != null) 'enable_quick_sale': enableQuickSale,
      if (enableTakeaway != null) 'enable_takeaway': enableTakeaway,
      if (enableDelivery != null) 'enable_delivery': enableDelivery,
    });
  }

  BusinessSettingsCompanion copyWith({
    Value<int>? id,
    Value<bool>? enableTableSales,
    Value<bool>? enableBarSales,
    Value<bool>? enableQuickSale,
    Value<bool>? enableTakeaway,
    Value<bool>? enableDelivery,
  }) {
    return BusinessSettingsCompanion(
      id: id ?? this.id,
      enableTableSales: enableTableSales ?? this.enableTableSales,
      enableBarSales: enableBarSales ?? this.enableBarSales,
      enableQuickSale: enableQuickSale ?? this.enableQuickSale,
      enableTakeaway: enableTakeaway ?? this.enableTakeaway,
      enableDelivery: enableDelivery ?? this.enableDelivery,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (enableTableSales.present) {
      map['enable_table_sales'] = Variable<bool>(enableTableSales.value);
    }
    if (enableBarSales.present) {
      map['enable_bar_sales'] = Variable<bool>(enableBarSales.value);
    }
    if (enableQuickSale.present) {
      map['enable_quick_sale'] = Variable<bool>(enableQuickSale.value);
    }
    if (enableTakeaway.present) {
      map['enable_takeaway'] = Variable<bool>(enableTakeaway.value);
    }
    if (enableDelivery.present) {
      map['enable_delivery'] = Variable<bool>(enableDelivery.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BusinessSettingsCompanion(')
          ..write('id: $id, ')
          ..write('enableTableSales: $enableTableSales, ')
          ..write('enableBarSales: $enableBarSales, ')
          ..write('enableQuickSale: $enableQuickSale, ')
          ..write('enableTakeaway: $enableTakeaway, ')
          ..write('enableDelivery: $enableDelivery')
          ..write(')'))
        .toString();
  }
}

class $OpenAccountsTable extends OpenAccounts
    with TableInfo<$OpenAccountsTable, OpenAccount> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OpenAccountsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _locationTypeMeta = const VerificationMeta(
    'locationType',
  );
  @override
  late final GeneratedColumn<String> locationType = GeneratedColumn<String>(
    'location_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tableNumberMeta = const VerificationMeta(
    'tableNumber',
  );
  @override
  late final GeneratedColumn<int> tableNumber = GeneratedColumn<int>(
    'table_number',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _customerNameMeta = const VerificationMeta(
    'customerName',
  );
  @override
  late final GeneratedColumn<String> customerName = GeneratedColumn<String>(
    'customer_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _openedAtMeta = const VerificationMeta(
    'openedAt',
  );
  @override
  late final GeneratedColumn<DateTime> openedAt = GeneratedColumn<DateTime>(
    'opened_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isClosedMeta = const VerificationMeta(
    'isClosed',
  );
  @override
  late final GeneratedColumn<bool> isClosed = GeneratedColumn<bool>(
    'is_closed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_closed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    locationType,
    tableNumber,
    customerName,
    openedAt,
    isClosed,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'open_accounts';
  @override
  VerificationContext validateIntegrity(
    Insertable<OpenAccount> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('location_type')) {
      context.handle(
        _locationTypeMeta,
        locationType.isAcceptableOrUnknown(
          data['location_type']!,
          _locationTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_locationTypeMeta);
    }
    if (data.containsKey('table_number')) {
      context.handle(
        _tableNumberMeta,
        tableNumber.isAcceptableOrUnknown(
          data['table_number']!,
          _tableNumberMeta,
        ),
      );
    }
    if (data.containsKey('customer_name')) {
      context.handle(
        _customerNameMeta,
        customerName.isAcceptableOrUnknown(
          data['customer_name']!,
          _customerNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_customerNameMeta);
    }
    if (data.containsKey('opened_at')) {
      context.handle(
        _openedAtMeta,
        openedAt.isAcceptableOrUnknown(data['opened_at']!, _openedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_openedAtMeta);
    }
    if (data.containsKey('is_closed')) {
      context.handle(
        _isClosedMeta,
        isClosed.isAcceptableOrUnknown(data['is_closed']!, _isClosedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OpenAccount map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OpenAccount(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      locationType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}location_type'],
      )!,
      tableNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}table_number'],
      ),
      customerName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_name'],
      )!,
      openedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}opened_at'],
      )!,
      isClosed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_closed'],
      )!,
    );
  }

  @override
  $OpenAccountsTable createAlias(String alias) {
    return $OpenAccountsTable(attachedDatabase, alias);
  }
}

class OpenAccount extends DataClass implements Insertable<OpenAccount> {
  final int id;
  final String locationType;
  final int? tableNumber;
  final String customerName;
  final DateTime openedAt;
  final bool isClosed;
  const OpenAccount({
    required this.id,
    required this.locationType,
    this.tableNumber,
    required this.customerName,
    required this.openedAt,
    required this.isClosed,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['location_type'] = Variable<String>(locationType);
    if (!nullToAbsent || tableNumber != null) {
      map['table_number'] = Variable<int>(tableNumber);
    }
    map['customer_name'] = Variable<String>(customerName);
    map['opened_at'] = Variable<DateTime>(openedAt);
    map['is_closed'] = Variable<bool>(isClosed);
    return map;
  }

  OpenAccountsCompanion toCompanion(bool nullToAbsent) {
    return OpenAccountsCompanion(
      id: Value(id),
      locationType: Value(locationType),
      tableNumber: tableNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(tableNumber),
      customerName: Value(customerName),
      openedAt: Value(openedAt),
      isClosed: Value(isClosed),
    );
  }

  factory OpenAccount.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OpenAccount(
      id: serializer.fromJson<int>(json['id']),
      locationType: serializer.fromJson<String>(json['locationType']),
      tableNumber: serializer.fromJson<int?>(json['tableNumber']),
      customerName: serializer.fromJson<String>(json['customerName']),
      openedAt: serializer.fromJson<DateTime>(json['openedAt']),
      isClosed: serializer.fromJson<bool>(json['isClosed']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'locationType': serializer.toJson<String>(locationType),
      'tableNumber': serializer.toJson<int?>(tableNumber),
      'customerName': serializer.toJson<String>(customerName),
      'openedAt': serializer.toJson<DateTime>(openedAt),
      'isClosed': serializer.toJson<bool>(isClosed),
    };
  }

  OpenAccount copyWith({
    int? id,
    String? locationType,
    Value<int?> tableNumber = const Value.absent(),
    String? customerName,
    DateTime? openedAt,
    bool? isClosed,
  }) => OpenAccount(
    id: id ?? this.id,
    locationType: locationType ?? this.locationType,
    tableNumber: tableNumber.present ? tableNumber.value : this.tableNumber,
    customerName: customerName ?? this.customerName,
    openedAt: openedAt ?? this.openedAt,
    isClosed: isClosed ?? this.isClosed,
  );
  OpenAccount copyWithCompanion(OpenAccountsCompanion data) {
    return OpenAccount(
      id: data.id.present ? data.id.value : this.id,
      locationType: data.locationType.present
          ? data.locationType.value
          : this.locationType,
      tableNumber: data.tableNumber.present
          ? data.tableNumber.value
          : this.tableNumber,
      customerName: data.customerName.present
          ? data.customerName.value
          : this.customerName,
      openedAt: data.openedAt.present ? data.openedAt.value : this.openedAt,
      isClosed: data.isClosed.present ? data.isClosed.value : this.isClosed,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OpenAccount(')
          ..write('id: $id, ')
          ..write('locationType: $locationType, ')
          ..write('tableNumber: $tableNumber, ')
          ..write('customerName: $customerName, ')
          ..write('openedAt: $openedAt, ')
          ..write('isClosed: $isClosed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    locationType,
    tableNumber,
    customerName,
    openedAt,
    isClosed,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OpenAccount &&
          other.id == this.id &&
          other.locationType == this.locationType &&
          other.tableNumber == this.tableNumber &&
          other.customerName == this.customerName &&
          other.openedAt == this.openedAt &&
          other.isClosed == this.isClosed);
}

class OpenAccountsCompanion extends UpdateCompanion<OpenAccount> {
  final Value<int> id;
  final Value<String> locationType;
  final Value<int?> tableNumber;
  final Value<String> customerName;
  final Value<DateTime> openedAt;
  final Value<bool> isClosed;
  const OpenAccountsCompanion({
    this.id = const Value.absent(),
    this.locationType = const Value.absent(),
    this.tableNumber = const Value.absent(),
    this.customerName = const Value.absent(),
    this.openedAt = const Value.absent(),
    this.isClosed = const Value.absent(),
  });
  OpenAccountsCompanion.insert({
    this.id = const Value.absent(),
    required String locationType,
    this.tableNumber = const Value.absent(),
    required String customerName,
    required DateTime openedAt,
    this.isClosed = const Value.absent(),
  }) : locationType = Value(locationType),
       customerName = Value(customerName),
       openedAt = Value(openedAt);
  static Insertable<OpenAccount> custom({
    Expression<int>? id,
    Expression<String>? locationType,
    Expression<int>? tableNumber,
    Expression<String>? customerName,
    Expression<DateTime>? openedAt,
    Expression<bool>? isClosed,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (locationType != null) 'location_type': locationType,
      if (tableNumber != null) 'table_number': tableNumber,
      if (customerName != null) 'customer_name': customerName,
      if (openedAt != null) 'opened_at': openedAt,
      if (isClosed != null) 'is_closed': isClosed,
    });
  }

  OpenAccountsCompanion copyWith({
    Value<int>? id,
    Value<String>? locationType,
    Value<int?>? tableNumber,
    Value<String>? customerName,
    Value<DateTime>? openedAt,
    Value<bool>? isClosed,
  }) {
    return OpenAccountsCompanion(
      id: id ?? this.id,
      locationType: locationType ?? this.locationType,
      tableNumber: tableNumber ?? this.tableNumber,
      customerName: customerName ?? this.customerName,
      openedAt: openedAt ?? this.openedAt,
      isClosed: isClosed ?? this.isClosed,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (locationType.present) {
      map['location_type'] = Variable<String>(locationType.value);
    }
    if (tableNumber.present) {
      map['table_number'] = Variable<int>(tableNumber.value);
    }
    if (customerName.present) {
      map['customer_name'] = Variable<String>(customerName.value);
    }
    if (openedAt.present) {
      map['opened_at'] = Variable<DateTime>(openedAt.value);
    }
    if (isClosed.present) {
      map['is_closed'] = Variable<bool>(isClosed.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OpenAccountsCompanion(')
          ..write('id: $id, ')
          ..write('locationType: $locationType, ')
          ..write('tableNumber: $tableNumber, ')
          ..write('customerName: $customerName, ')
          ..write('openedAt: $openedAt, ')
          ..write('isClosed: $isClosed')
          ..write(')'))
        .toString();
  }
}

class $AppUsersTable extends AppUsers with TableInfo<$AppUsersTable, AppUser> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppUsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _usernameMeta = const VerificationMeta(
    'username',
  );
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
    'username',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pinHashMeta = const VerificationMeta(
    'pinHash',
  );
  @override
  late final GeneratedColumn<String> pinHash = GeneratedColumn<String>(
    'pin_hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pinSaltMeta = const VerificationMeta(
    'pinSalt',
  );
  @override
  late final GeneratedColumn<String> pinSalt = GeneratedColumn<String>(
    'pin_salt',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pinHashVersionMeta = const VerificationMeta(
    'pinHashVersion',
  );
  @override
  late final GeneratedColumn<int> pinHashVersion = GeneratedColumn<int>(
    'pin_hash_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _requiresPinChangeMeta = const VerificationMeta(
    'requiresPinChange',
  );
  @override
  late final GeneratedColumn<bool> requiresPinChange = GeneratedColumn<bool>(
    'requires_pin_change',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("requires_pin_change" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _failedLoginAttemptsMeta =
      const VerificationMeta('failedLoginAttempts');
  @override
  late final GeneratedColumn<int> failedLoginAttempts = GeneratedColumn<int>(
    'failed_login_attempts',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lockedUntilMeta = const VerificationMeta(
    'lockedUntil',
  );
  @override
  late final GeneratedColumn<DateTime> lockedUntil = GeneratedColumn<DateTime>(
    'locked_until',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastLoginAtMeta = const VerificationMeta(
    'lastLoginAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastLoginAt = GeneratedColumn<DateTime>(
    'last_login_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    username,
    displayName,
    role,
    pinHash,
    pinSalt,
    pinHashVersion,
    isActive,
    requiresPinChange,
    failedLoginAttempts,
    lockedUntil,
    lastLoginAt,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_users';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppUser> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('username')) {
      context.handle(
        _usernameMeta,
        username.isAcceptableOrUnknown(data['username']!, _usernameMeta),
      );
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('pin_hash')) {
      context.handle(
        _pinHashMeta,
        pinHash.isAcceptableOrUnknown(data['pin_hash']!, _pinHashMeta),
      );
    } else if (isInserting) {
      context.missing(_pinHashMeta);
    }
    if (data.containsKey('pin_salt')) {
      context.handle(
        _pinSaltMeta,
        pinSalt.isAcceptableOrUnknown(data['pin_salt']!, _pinSaltMeta),
      );
    } else if (isInserting) {
      context.missing(_pinSaltMeta);
    }
    if (data.containsKey('pin_hash_version')) {
      context.handle(
        _pinHashVersionMeta,
        pinHashVersion.isAcceptableOrUnknown(
          data['pin_hash_version']!,
          _pinHashVersionMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('requires_pin_change')) {
      context.handle(
        _requiresPinChangeMeta,
        requiresPinChange.isAcceptableOrUnknown(
          data['requires_pin_change']!,
          _requiresPinChangeMeta,
        ),
      );
    }
    if (data.containsKey('failed_login_attempts')) {
      context.handle(
        _failedLoginAttemptsMeta,
        failedLoginAttempts.isAcceptableOrUnknown(
          data['failed_login_attempts']!,
          _failedLoginAttemptsMeta,
        ),
      );
    }
    if (data.containsKey('locked_until')) {
      context.handle(
        _lockedUntilMeta,
        lockedUntil.isAcceptableOrUnknown(
          data['locked_until']!,
          _lockedUntilMeta,
        ),
      );
    }
    if (data.containsKey('last_login_at')) {
      context.handle(
        _lastLoginAtMeta,
        lastLoginAt.isAcceptableOrUnknown(
          data['last_login_at']!,
          _lastLoginAtMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppUser map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppUser(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      username: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}username'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      )!,
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      pinHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pin_hash'],
      )!,
      pinSalt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pin_salt'],
      )!,
      pinHashVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pin_hash_version'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      requiresPinChange: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}requires_pin_change'],
      )!,
      failedLoginAttempts: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}failed_login_attempts'],
      )!,
      lockedUntil: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}locked_until'],
      ),
      lastLoginAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_login_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $AppUsersTable createAlias(String alias) {
    return $AppUsersTable(attachedDatabase, alias);
  }
}

class AppUser extends DataClass implements Insertable<AppUser> {
  final int id;
  final String username;
  final String displayName;
  final String role;
  final String pinHash;
  final String pinSalt;
  final int pinHashVersion;
  final bool isActive;
  final bool requiresPinChange;
  final int failedLoginAttempts;
  final DateTime? lockedUntil;
  final DateTime? lastLoginAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  const AppUser({
    required this.id,
    required this.username,
    required this.displayName,
    required this.role,
    required this.pinHash,
    required this.pinSalt,
    required this.pinHashVersion,
    required this.isActive,
    required this.requiresPinChange,
    required this.failedLoginAttempts,
    this.lockedUntil,
    this.lastLoginAt,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['username'] = Variable<String>(username);
    map['display_name'] = Variable<String>(displayName);
    map['role'] = Variable<String>(role);
    map['pin_hash'] = Variable<String>(pinHash);
    map['pin_salt'] = Variable<String>(pinSalt);
    map['pin_hash_version'] = Variable<int>(pinHashVersion);
    map['is_active'] = Variable<bool>(isActive);
    map['requires_pin_change'] = Variable<bool>(requiresPinChange);
    map['failed_login_attempts'] = Variable<int>(failedLoginAttempts);
    if (!nullToAbsent || lockedUntil != null) {
      map['locked_until'] = Variable<DateTime>(lockedUntil);
    }
    if (!nullToAbsent || lastLoginAt != null) {
      map['last_login_at'] = Variable<DateTime>(lastLoginAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AppUsersCompanion toCompanion(bool nullToAbsent) {
    return AppUsersCompanion(
      id: Value(id),
      username: Value(username),
      displayName: Value(displayName),
      role: Value(role),
      pinHash: Value(pinHash),
      pinSalt: Value(pinSalt),
      pinHashVersion: Value(pinHashVersion),
      isActive: Value(isActive),
      requiresPinChange: Value(requiresPinChange),
      failedLoginAttempts: Value(failedLoginAttempts),
      lockedUntil: lockedUntil == null && nullToAbsent
          ? const Value.absent()
          : Value(lockedUntil),
      lastLoginAt: lastLoginAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastLoginAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory AppUser.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppUser(
      id: serializer.fromJson<int>(json['id']),
      username: serializer.fromJson<String>(json['username']),
      displayName: serializer.fromJson<String>(json['displayName']),
      role: serializer.fromJson<String>(json['role']),
      pinHash: serializer.fromJson<String>(json['pinHash']),
      pinSalt: serializer.fromJson<String>(json['pinSalt']),
      pinHashVersion: serializer.fromJson<int>(json['pinHashVersion']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      requiresPinChange: serializer.fromJson<bool>(json['requiresPinChange']),
      failedLoginAttempts: serializer.fromJson<int>(
        json['failedLoginAttempts'],
      ),
      lockedUntil: serializer.fromJson<DateTime?>(json['lockedUntil']),
      lastLoginAt: serializer.fromJson<DateTime?>(json['lastLoginAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'username': serializer.toJson<String>(username),
      'displayName': serializer.toJson<String>(displayName),
      'role': serializer.toJson<String>(role),
      'pinHash': serializer.toJson<String>(pinHash),
      'pinSalt': serializer.toJson<String>(pinSalt),
      'pinHashVersion': serializer.toJson<int>(pinHashVersion),
      'isActive': serializer.toJson<bool>(isActive),
      'requiresPinChange': serializer.toJson<bool>(requiresPinChange),
      'failedLoginAttempts': serializer.toJson<int>(failedLoginAttempts),
      'lockedUntil': serializer.toJson<DateTime?>(lockedUntil),
      'lastLoginAt': serializer.toJson<DateTime?>(lastLoginAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  AppUser copyWith({
    int? id,
    String? username,
    String? displayName,
    String? role,
    String? pinHash,
    String? pinSalt,
    int? pinHashVersion,
    bool? isActive,
    bool? requiresPinChange,
    int? failedLoginAttempts,
    Value<DateTime?> lockedUntil = const Value.absent(),
    Value<DateTime?> lastLoginAt = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => AppUser(
    id: id ?? this.id,
    username: username ?? this.username,
    displayName: displayName ?? this.displayName,
    role: role ?? this.role,
    pinHash: pinHash ?? this.pinHash,
    pinSalt: pinSalt ?? this.pinSalt,
    pinHashVersion: pinHashVersion ?? this.pinHashVersion,
    isActive: isActive ?? this.isActive,
    requiresPinChange: requiresPinChange ?? this.requiresPinChange,
    failedLoginAttempts: failedLoginAttempts ?? this.failedLoginAttempts,
    lockedUntil: lockedUntil.present ? lockedUntil.value : this.lockedUntil,
    lastLoginAt: lastLoginAt.present ? lastLoginAt.value : this.lastLoginAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  AppUser copyWithCompanion(AppUsersCompanion data) {
    return AppUser(
      id: data.id.present ? data.id.value : this.id,
      username: data.username.present ? data.username.value : this.username,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      role: data.role.present ? data.role.value : this.role,
      pinHash: data.pinHash.present ? data.pinHash.value : this.pinHash,
      pinSalt: data.pinSalt.present ? data.pinSalt.value : this.pinSalt,
      pinHashVersion: data.pinHashVersion.present
          ? data.pinHashVersion.value
          : this.pinHashVersion,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      requiresPinChange: data.requiresPinChange.present
          ? data.requiresPinChange.value
          : this.requiresPinChange,
      failedLoginAttempts: data.failedLoginAttempts.present
          ? data.failedLoginAttempts.value
          : this.failedLoginAttempts,
      lockedUntil: data.lockedUntil.present
          ? data.lockedUntil.value
          : this.lockedUntil,
      lastLoginAt: data.lastLoginAt.present
          ? data.lastLoginAt.value
          : this.lastLoginAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppUser(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('displayName: $displayName, ')
          ..write('role: $role, ')
          ..write('pinHash: $pinHash, ')
          ..write('pinSalt: $pinSalt, ')
          ..write('pinHashVersion: $pinHashVersion, ')
          ..write('isActive: $isActive, ')
          ..write('requiresPinChange: $requiresPinChange, ')
          ..write('failedLoginAttempts: $failedLoginAttempts, ')
          ..write('lockedUntil: $lockedUntil, ')
          ..write('lastLoginAt: $lastLoginAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    username,
    displayName,
    role,
    pinHash,
    pinSalt,
    pinHashVersion,
    isActive,
    requiresPinChange,
    failedLoginAttempts,
    lockedUntil,
    lastLoginAt,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppUser &&
          other.id == this.id &&
          other.username == this.username &&
          other.displayName == this.displayName &&
          other.role == this.role &&
          other.pinHash == this.pinHash &&
          other.pinSalt == this.pinSalt &&
          other.pinHashVersion == this.pinHashVersion &&
          other.isActive == this.isActive &&
          other.requiresPinChange == this.requiresPinChange &&
          other.failedLoginAttempts == this.failedLoginAttempts &&
          other.lockedUntil == this.lockedUntil &&
          other.lastLoginAt == this.lastLoginAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class AppUsersCompanion extends UpdateCompanion<AppUser> {
  final Value<int> id;
  final Value<String> username;
  final Value<String> displayName;
  final Value<String> role;
  final Value<String> pinHash;
  final Value<String> pinSalt;
  final Value<int> pinHashVersion;
  final Value<bool> isActive;
  final Value<bool> requiresPinChange;
  final Value<int> failedLoginAttempts;
  final Value<DateTime?> lockedUntil;
  final Value<DateTime?> lastLoginAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const AppUsersCompanion({
    this.id = const Value.absent(),
    this.username = const Value.absent(),
    this.displayName = const Value.absent(),
    this.role = const Value.absent(),
    this.pinHash = const Value.absent(),
    this.pinSalt = const Value.absent(),
    this.pinHashVersion = const Value.absent(),
    this.isActive = const Value.absent(),
    this.requiresPinChange = const Value.absent(),
    this.failedLoginAttempts = const Value.absent(),
    this.lockedUntil = const Value.absent(),
    this.lastLoginAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  AppUsersCompanion.insert({
    this.id = const Value.absent(),
    required String username,
    required String displayName,
    required String role,
    required String pinHash,
    required String pinSalt,
    this.pinHashVersion = const Value.absent(),
    this.isActive = const Value.absent(),
    this.requiresPinChange = const Value.absent(),
    this.failedLoginAttempts = const Value.absent(),
    this.lockedUntil = const Value.absent(),
    this.lastLoginAt = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : username = Value(username),
       displayName = Value(displayName),
       role = Value(role),
       pinHash = Value(pinHash),
       pinSalt = Value(pinSalt),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<AppUser> custom({
    Expression<int>? id,
    Expression<String>? username,
    Expression<String>? displayName,
    Expression<String>? role,
    Expression<String>? pinHash,
    Expression<String>? pinSalt,
    Expression<int>? pinHashVersion,
    Expression<bool>? isActive,
    Expression<bool>? requiresPinChange,
    Expression<int>? failedLoginAttempts,
    Expression<DateTime>? lockedUntil,
    Expression<DateTime>? lastLoginAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (username != null) 'username': username,
      if (displayName != null) 'display_name': displayName,
      if (role != null) 'role': role,
      if (pinHash != null) 'pin_hash': pinHash,
      if (pinSalt != null) 'pin_salt': pinSalt,
      if (pinHashVersion != null) 'pin_hash_version': pinHashVersion,
      if (isActive != null) 'is_active': isActive,
      if (requiresPinChange != null) 'requires_pin_change': requiresPinChange,
      if (failedLoginAttempts != null)
        'failed_login_attempts': failedLoginAttempts,
      if (lockedUntil != null) 'locked_until': lockedUntil,
      if (lastLoginAt != null) 'last_login_at': lastLoginAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  AppUsersCompanion copyWith({
    Value<int>? id,
    Value<String>? username,
    Value<String>? displayName,
    Value<String>? role,
    Value<String>? pinHash,
    Value<String>? pinSalt,
    Value<int>? pinHashVersion,
    Value<bool>? isActive,
    Value<bool>? requiresPinChange,
    Value<int>? failedLoginAttempts,
    Value<DateTime?>? lockedUntil,
    Value<DateTime?>? lastLoginAt,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return AppUsersCompanion(
      id: id ?? this.id,
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      role: role ?? this.role,
      pinHash: pinHash ?? this.pinHash,
      pinSalt: pinSalt ?? this.pinSalt,
      pinHashVersion: pinHashVersion ?? this.pinHashVersion,
      isActive: isActive ?? this.isActive,
      requiresPinChange: requiresPinChange ?? this.requiresPinChange,
      failedLoginAttempts: failedLoginAttempts ?? this.failedLoginAttempts,
      lockedUntil: lockedUntil ?? this.lockedUntil,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (pinHash.present) {
      map['pin_hash'] = Variable<String>(pinHash.value);
    }
    if (pinSalt.present) {
      map['pin_salt'] = Variable<String>(pinSalt.value);
    }
    if (pinHashVersion.present) {
      map['pin_hash_version'] = Variable<int>(pinHashVersion.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (requiresPinChange.present) {
      map['requires_pin_change'] = Variable<bool>(requiresPinChange.value);
    }
    if (failedLoginAttempts.present) {
      map['failed_login_attempts'] = Variable<int>(failedLoginAttempts.value);
    }
    if (lockedUntil.present) {
      map['locked_until'] = Variable<DateTime>(lockedUntil.value);
    }
    if (lastLoginAt.present) {
      map['last_login_at'] = Variable<DateTime>(lastLoginAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppUsersCompanion(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('displayName: $displayName, ')
          ..write('role: $role, ')
          ..write('pinHash: $pinHash, ')
          ..write('pinSalt: $pinSalt, ')
          ..write('pinHashVersion: $pinHashVersion, ')
          ..write('isActive: $isActive, ')
          ..write('requiresPinChange: $requiresPinChange, ')
          ..write('failedLoginAttempts: $failedLoginAttempts, ')
          ..write('lockedUntil: $lockedUntil, ')
          ..write('lastLoginAt: $lastLoginAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProductsTable products = $ProductsTable(this);
  late final $SalesTable sales = $SalesTable(this);
  late final $SaleItemsTable saleItems = $SaleItemsTable(this);
  late final $PaymentsTable payments = $PaymentsTable(this);
  late final $TableAccountsTable tableAccounts = $TableAccountsTable(this);
  late final $AccountItemsTable accountItems = $AccountItemsTable(this);
  late final $CashSessionsTable cashSessions = $CashSessionsTable(this);
  late final $BusinessSettingsTable businessSettings = $BusinessSettingsTable(
    this,
  );
  late final $OpenAccountsTable openAccounts = $OpenAccountsTable(this);
  late final $AppUsersTable appUsers = $AppUsersTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    products,
    sales,
    saleItems,
    payments,
    tableAccounts,
    accountItems,
    cashSessions,
    businessSettings,
    openAccounts,
    appUsers,
  ];
}

typedef $$ProductsTableCreateCompanionBuilder =
    ProductsCompanion Function({
      Value<int> id,
      required String name,
      required double salePrice,
      required double purchasePrice,
      required String imagePath,
      required String category,
      Value<int> stock,
      Value<bool> isActive,
      Value<String> description,
      Value<String> barcode,
      Value<bool> favorite,
    });
typedef $$ProductsTableUpdateCompanionBuilder =
    ProductsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<double> salePrice,
      Value<double> purchasePrice,
      Value<String> imagePath,
      Value<String> category,
      Value<int> stock,
      Value<bool> isActive,
      Value<String> description,
      Value<String> barcode,
      Value<bool> favorite,
    });

class $$ProductsTableFilterComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get salePrice => $composableBuilder(
    column: $table.salePrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get purchasePrice => $composableBuilder(
    column: $table.purchasePrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get stock => $composableBuilder(
    column: $table.stock,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get favorite => $composableBuilder(
    column: $table.favorite,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProductsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get salePrice => $composableBuilder(
    column: $table.salePrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get purchasePrice => $composableBuilder(
    column: $table.purchasePrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get stock => $composableBuilder(
    column: $table.stock,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get favorite => $composableBuilder(
    column: $table.favorite,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProductsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get salePrice =>
      $composableBuilder(column: $table.salePrice, builder: (column) => column);

  GeneratedColumn<double> get purchasePrice => $composableBuilder(
    column: $table.purchasePrice,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<int> get stock =>
      $composableBuilder(column: $table.stock, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get barcode =>
      $composableBuilder(column: $table.barcode, builder: (column) => column);

  GeneratedColumn<bool> get favorite =>
      $composableBuilder(column: $table.favorite, builder: (column) => column);
}

class $$ProductsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProductsTable,
          Product,
          $$ProductsTableFilterComposer,
          $$ProductsTableOrderingComposer,
          $$ProductsTableAnnotationComposer,
          $$ProductsTableCreateCompanionBuilder,
          $$ProductsTableUpdateCompanionBuilder,
          (Product, BaseReferences<_$AppDatabase, $ProductsTable, Product>),
          Product,
          PrefetchHooks Function()
        > {
  $$ProductsTableTableManager(_$AppDatabase db, $ProductsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<double> salePrice = const Value.absent(),
                Value<double> purchasePrice = const Value.absent(),
                Value<String> imagePath = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<int> stock = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> barcode = const Value.absent(),
                Value<bool> favorite = const Value.absent(),
              }) => ProductsCompanion(
                id: id,
                name: name,
                salePrice: salePrice,
                purchasePrice: purchasePrice,
                imagePath: imagePath,
                category: category,
                stock: stock,
                isActive: isActive,
                description: description,
                barcode: barcode,
                favorite: favorite,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required double salePrice,
                required double purchasePrice,
                required String imagePath,
                required String category,
                Value<int> stock = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> barcode = const Value.absent(),
                Value<bool> favorite = const Value.absent(),
              }) => ProductsCompanion.insert(
                id: id,
                name: name,
                salePrice: salePrice,
                purchasePrice: purchasePrice,
                imagePath: imagePath,
                category: category,
                stock: stock,
                isActive: isActive,
                description: description,
                barcode: barcode,
                favorite: favorite,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProductsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProductsTable,
      Product,
      $$ProductsTableFilterComposer,
      $$ProductsTableOrderingComposer,
      $$ProductsTableAnnotationComposer,
      $$ProductsTableCreateCompanionBuilder,
      $$ProductsTableUpdateCompanionBuilder,
      (Product, BaseReferences<_$AppDatabase, $ProductsTable, Product>),
      Product,
      PrefetchHooks Function()
    >;
typedef $$SalesTableCreateCompanionBuilder =
    SalesCompanion Function({
      Value<int> id,
      required String type,
      required DateTime createdAt,
      Value<int?> tableNumber,
      Value<int?> accountId,
      Value<String?> customerName,
      Value<String?> customerPhone,
      Value<String?> deliveryAddress,
      Value<String?> deliveryReference,
      Value<double> deliveryFee,
      Value<double> taxRate,
      Value<bool> isClosed,
    });
typedef $$SalesTableUpdateCompanionBuilder =
    SalesCompanion Function({
      Value<int> id,
      Value<String> type,
      Value<DateTime> createdAt,
      Value<int?> tableNumber,
      Value<int?> accountId,
      Value<String?> customerName,
      Value<String?> customerPhone,
      Value<String?> deliveryAddress,
      Value<String?> deliveryReference,
      Value<double> deliveryFee,
      Value<double> taxRate,
      Value<bool> isClosed,
    });

class $$SalesTableFilterComposer extends Composer<_$AppDatabase, $SalesTable> {
  $$SalesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tableNumber => $composableBuilder(
    column: $table.tableNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customerPhone => $composableBuilder(
    column: $table.customerPhone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deliveryAddress => $composableBuilder(
    column: $table.deliveryAddress,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deliveryReference => $composableBuilder(
    column: $table.deliveryReference,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get deliveryFee => $composableBuilder(
    column: $table.deliveryFee,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get taxRate => $composableBuilder(
    column: $table.taxRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isClosed => $composableBuilder(
    column: $table.isClosed,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SalesTableOrderingComposer
    extends Composer<_$AppDatabase, $SalesTable> {
  $$SalesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tableNumber => $composableBuilder(
    column: $table.tableNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customerPhone => $composableBuilder(
    column: $table.customerPhone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deliveryAddress => $composableBuilder(
    column: $table.deliveryAddress,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deliveryReference => $composableBuilder(
    column: $table.deliveryReference,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get deliveryFee => $composableBuilder(
    column: $table.deliveryFee,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get taxRate => $composableBuilder(
    column: $table.taxRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isClosed => $composableBuilder(
    column: $table.isClosed,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SalesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SalesTable> {
  $$SalesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get tableNumber => $composableBuilder(
    column: $table.tableNumber,
    builder: (column) => column,
  );

  GeneratedColumn<int> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get customerPhone => $composableBuilder(
    column: $table.customerPhone,
    builder: (column) => column,
  );

  GeneratedColumn<String> get deliveryAddress => $composableBuilder(
    column: $table.deliveryAddress,
    builder: (column) => column,
  );

  GeneratedColumn<String> get deliveryReference => $composableBuilder(
    column: $table.deliveryReference,
    builder: (column) => column,
  );

  GeneratedColumn<double> get deliveryFee => $composableBuilder(
    column: $table.deliveryFee,
    builder: (column) => column,
  );

  GeneratedColumn<double> get taxRate =>
      $composableBuilder(column: $table.taxRate, builder: (column) => column);

  GeneratedColumn<bool> get isClosed =>
      $composableBuilder(column: $table.isClosed, builder: (column) => column);
}

class $$SalesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SalesTable,
          Sale,
          $$SalesTableFilterComposer,
          $$SalesTableOrderingComposer,
          $$SalesTableAnnotationComposer,
          $$SalesTableCreateCompanionBuilder,
          $$SalesTableUpdateCompanionBuilder,
          (Sale, BaseReferences<_$AppDatabase, $SalesTable, Sale>),
          Sale,
          PrefetchHooks Function()
        > {
  $$SalesTableTableManager(_$AppDatabase db, $SalesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SalesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SalesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SalesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int?> tableNumber = const Value.absent(),
                Value<int?> accountId = const Value.absent(),
                Value<String?> customerName = const Value.absent(),
                Value<String?> customerPhone = const Value.absent(),
                Value<String?> deliveryAddress = const Value.absent(),
                Value<String?> deliveryReference = const Value.absent(),
                Value<double> deliveryFee = const Value.absent(),
                Value<double> taxRate = const Value.absent(),
                Value<bool> isClosed = const Value.absent(),
              }) => SalesCompanion(
                id: id,
                type: type,
                createdAt: createdAt,
                tableNumber: tableNumber,
                accountId: accountId,
                customerName: customerName,
                customerPhone: customerPhone,
                deliveryAddress: deliveryAddress,
                deliveryReference: deliveryReference,
                deliveryFee: deliveryFee,
                taxRate: taxRate,
                isClosed: isClosed,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String type,
                required DateTime createdAt,
                Value<int?> tableNumber = const Value.absent(),
                Value<int?> accountId = const Value.absent(),
                Value<String?> customerName = const Value.absent(),
                Value<String?> customerPhone = const Value.absent(),
                Value<String?> deliveryAddress = const Value.absent(),
                Value<String?> deliveryReference = const Value.absent(),
                Value<double> deliveryFee = const Value.absent(),
                Value<double> taxRate = const Value.absent(),
                Value<bool> isClosed = const Value.absent(),
              }) => SalesCompanion.insert(
                id: id,
                type: type,
                createdAt: createdAt,
                tableNumber: tableNumber,
                accountId: accountId,
                customerName: customerName,
                customerPhone: customerPhone,
                deliveryAddress: deliveryAddress,
                deliveryReference: deliveryReference,
                deliveryFee: deliveryFee,
                taxRate: taxRate,
                isClosed: isClosed,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SalesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SalesTable,
      Sale,
      $$SalesTableFilterComposer,
      $$SalesTableOrderingComposer,
      $$SalesTableAnnotationComposer,
      $$SalesTableCreateCompanionBuilder,
      $$SalesTableUpdateCompanionBuilder,
      (Sale, BaseReferences<_$AppDatabase, $SalesTable, Sale>),
      Sale,
      PrefetchHooks Function()
    >;
typedef $$SaleItemsTableCreateCompanionBuilder =
    SaleItemsCompanion Function({
      Value<int> id,
      required int saleId,
      required int productId,
      required String productName,
      required String productImagePath,
      required String productCategory,
      required double unitPrice,
      required double unitCost,
      required int quantity,
    });
typedef $$SaleItemsTableUpdateCompanionBuilder =
    SaleItemsCompanion Function({
      Value<int> id,
      Value<int> saleId,
      Value<int> productId,
      Value<String> productName,
      Value<String> productImagePath,
      Value<String> productCategory,
      Value<double> unitPrice,
      Value<double> unitCost,
      Value<int> quantity,
    });

class $$SaleItemsTableFilterComposer
    extends Composer<_$AppDatabase, $SaleItemsTable> {
  $$SaleItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get saleId => $composableBuilder(
    column: $table.saleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productImagePath => $composableBuilder(
    column: $table.productImagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productCategory => $composableBuilder(
    column: $table.productCategory,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get unitPrice => $composableBuilder(
    column: $table.unitPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get unitCost => $composableBuilder(
    column: $table.unitCost,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SaleItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $SaleItemsTable> {
  $$SaleItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get saleId => $composableBuilder(
    column: $table.saleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productImagePath => $composableBuilder(
    column: $table.productImagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productCategory => $composableBuilder(
    column: $table.productCategory,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get unitPrice => $composableBuilder(
    column: $table.unitPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get unitCost => $composableBuilder(
    column: $table.unitCost,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SaleItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SaleItemsTable> {
  $$SaleItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get saleId =>
      $composableBuilder(column: $table.saleId, builder: (column) => column);

  GeneratedColumn<int> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get productImagePath => $composableBuilder(
    column: $table.productImagePath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get productCategory => $composableBuilder(
    column: $table.productCategory,
    builder: (column) => column,
  );

  GeneratedColumn<double> get unitPrice =>
      $composableBuilder(column: $table.unitPrice, builder: (column) => column);

  GeneratedColumn<double> get unitCost =>
      $composableBuilder(column: $table.unitCost, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);
}

class $$SaleItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SaleItemsTable,
          SaleItem,
          $$SaleItemsTableFilterComposer,
          $$SaleItemsTableOrderingComposer,
          $$SaleItemsTableAnnotationComposer,
          $$SaleItemsTableCreateCompanionBuilder,
          $$SaleItemsTableUpdateCompanionBuilder,
          (SaleItem, BaseReferences<_$AppDatabase, $SaleItemsTable, SaleItem>),
          SaleItem,
          PrefetchHooks Function()
        > {
  $$SaleItemsTableTableManager(_$AppDatabase db, $SaleItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SaleItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SaleItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SaleItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> saleId = const Value.absent(),
                Value<int> productId = const Value.absent(),
                Value<String> productName = const Value.absent(),
                Value<String> productImagePath = const Value.absent(),
                Value<String> productCategory = const Value.absent(),
                Value<double> unitPrice = const Value.absent(),
                Value<double> unitCost = const Value.absent(),
                Value<int> quantity = const Value.absent(),
              }) => SaleItemsCompanion(
                id: id,
                saleId: saleId,
                productId: productId,
                productName: productName,
                productImagePath: productImagePath,
                productCategory: productCategory,
                unitPrice: unitPrice,
                unitCost: unitCost,
                quantity: quantity,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int saleId,
                required int productId,
                required String productName,
                required String productImagePath,
                required String productCategory,
                required double unitPrice,
                required double unitCost,
                required int quantity,
              }) => SaleItemsCompanion.insert(
                id: id,
                saleId: saleId,
                productId: productId,
                productName: productName,
                productImagePath: productImagePath,
                productCategory: productCategory,
                unitPrice: unitPrice,
                unitCost: unitCost,
                quantity: quantity,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SaleItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SaleItemsTable,
      SaleItem,
      $$SaleItemsTableFilterComposer,
      $$SaleItemsTableOrderingComposer,
      $$SaleItemsTableAnnotationComposer,
      $$SaleItemsTableCreateCompanionBuilder,
      $$SaleItemsTableUpdateCompanionBuilder,
      (SaleItem, BaseReferences<_$AppDatabase, $SaleItemsTable, SaleItem>),
      SaleItem,
      PrefetchHooks Function()
    >;
typedef $$PaymentsTableCreateCompanionBuilder =
    PaymentsCompanion Function({
      Value<int> id,
      required int saleId,
      required String method,
      required double amount,
      Value<double?> receivedAmount,
      Value<String?> reference,
    });
typedef $$PaymentsTableUpdateCompanionBuilder =
    PaymentsCompanion Function({
      Value<int> id,
      Value<int> saleId,
      Value<String> method,
      Value<double> amount,
      Value<double?> receivedAmount,
      Value<String?> reference,
    });

class $$PaymentsTableFilterComposer
    extends Composer<_$AppDatabase, $PaymentsTable> {
  $$PaymentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get saleId => $composableBuilder(
    column: $table.saleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get method => $composableBuilder(
    column: $table.method,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get receivedAmount => $composableBuilder(
    column: $table.receivedAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reference => $composableBuilder(
    column: $table.reference,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PaymentsTableOrderingComposer
    extends Composer<_$AppDatabase, $PaymentsTable> {
  $$PaymentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get saleId => $composableBuilder(
    column: $table.saleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get method => $composableBuilder(
    column: $table.method,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get receivedAmount => $composableBuilder(
    column: $table.receivedAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reference => $composableBuilder(
    column: $table.reference,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PaymentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PaymentsTable> {
  $$PaymentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get saleId =>
      $composableBuilder(column: $table.saleId, builder: (column) => column);

  GeneratedColumn<String> get method =>
      $composableBuilder(column: $table.method, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<double> get receivedAmount => $composableBuilder(
    column: $table.receivedAmount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reference =>
      $composableBuilder(column: $table.reference, builder: (column) => column);
}

class $$PaymentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PaymentsTable,
          Payment,
          $$PaymentsTableFilterComposer,
          $$PaymentsTableOrderingComposer,
          $$PaymentsTableAnnotationComposer,
          $$PaymentsTableCreateCompanionBuilder,
          $$PaymentsTableUpdateCompanionBuilder,
          (Payment, BaseReferences<_$AppDatabase, $PaymentsTable, Payment>),
          Payment,
          PrefetchHooks Function()
        > {
  $$PaymentsTableTableManager(_$AppDatabase db, $PaymentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PaymentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PaymentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PaymentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> saleId = const Value.absent(),
                Value<String> method = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<double?> receivedAmount = const Value.absent(),
                Value<String?> reference = const Value.absent(),
              }) => PaymentsCompanion(
                id: id,
                saleId: saleId,
                method: method,
                amount: amount,
                receivedAmount: receivedAmount,
                reference: reference,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int saleId,
                required String method,
                required double amount,
                Value<double?> receivedAmount = const Value.absent(),
                Value<String?> reference = const Value.absent(),
              }) => PaymentsCompanion.insert(
                id: id,
                saleId: saleId,
                method: method,
                amount: amount,
                receivedAmount: receivedAmount,
                reference: reference,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PaymentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PaymentsTable,
      Payment,
      $$PaymentsTableFilterComposer,
      $$PaymentsTableOrderingComposer,
      $$PaymentsTableAnnotationComposer,
      $$PaymentsTableCreateCompanionBuilder,
      $$PaymentsTableUpdateCompanionBuilder,
      (Payment, BaseReferences<_$AppDatabase, $PaymentsTable, Payment>),
      Payment,
      PrefetchHooks Function()
    >;
typedef $$TableAccountsTableCreateCompanionBuilder =
    TableAccountsCompanion Function({
      Value<int> id,
      required int tableNumber,
      required String customerName,
      required DateTime openedAt,
      Value<bool> isClosed,
    });
typedef $$TableAccountsTableUpdateCompanionBuilder =
    TableAccountsCompanion Function({
      Value<int> id,
      Value<int> tableNumber,
      Value<String> customerName,
      Value<DateTime> openedAt,
      Value<bool> isClosed,
    });

class $$TableAccountsTableFilterComposer
    extends Composer<_$AppDatabase, $TableAccountsTable> {
  $$TableAccountsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tableNumber => $composableBuilder(
    column: $table.tableNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get openedAt => $composableBuilder(
    column: $table.openedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isClosed => $composableBuilder(
    column: $table.isClosed,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TableAccountsTableOrderingComposer
    extends Composer<_$AppDatabase, $TableAccountsTable> {
  $$TableAccountsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tableNumber => $composableBuilder(
    column: $table.tableNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get openedAt => $composableBuilder(
    column: $table.openedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isClosed => $composableBuilder(
    column: $table.isClosed,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TableAccountsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TableAccountsTable> {
  $$TableAccountsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get tableNumber => $composableBuilder(
    column: $table.tableNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get openedAt =>
      $composableBuilder(column: $table.openedAt, builder: (column) => column);

  GeneratedColumn<bool> get isClosed =>
      $composableBuilder(column: $table.isClosed, builder: (column) => column);
}

class $$TableAccountsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TableAccountsTable,
          TableAccount,
          $$TableAccountsTableFilterComposer,
          $$TableAccountsTableOrderingComposer,
          $$TableAccountsTableAnnotationComposer,
          $$TableAccountsTableCreateCompanionBuilder,
          $$TableAccountsTableUpdateCompanionBuilder,
          (
            TableAccount,
            BaseReferences<_$AppDatabase, $TableAccountsTable, TableAccount>,
          ),
          TableAccount,
          PrefetchHooks Function()
        > {
  $$TableAccountsTableTableManager(_$AppDatabase db, $TableAccountsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TableAccountsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TableAccountsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TableAccountsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> tableNumber = const Value.absent(),
                Value<String> customerName = const Value.absent(),
                Value<DateTime> openedAt = const Value.absent(),
                Value<bool> isClosed = const Value.absent(),
              }) => TableAccountsCompanion(
                id: id,
                tableNumber: tableNumber,
                customerName: customerName,
                openedAt: openedAt,
                isClosed: isClosed,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int tableNumber,
                required String customerName,
                required DateTime openedAt,
                Value<bool> isClosed = const Value.absent(),
              }) => TableAccountsCompanion.insert(
                id: id,
                tableNumber: tableNumber,
                customerName: customerName,
                openedAt: openedAt,
                isClosed: isClosed,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TableAccountsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TableAccountsTable,
      TableAccount,
      $$TableAccountsTableFilterComposer,
      $$TableAccountsTableOrderingComposer,
      $$TableAccountsTableAnnotationComposer,
      $$TableAccountsTableCreateCompanionBuilder,
      $$TableAccountsTableUpdateCompanionBuilder,
      (
        TableAccount,
        BaseReferences<_$AppDatabase, $TableAccountsTable, TableAccount>,
      ),
      TableAccount,
      PrefetchHooks Function()
    >;
typedef $$AccountItemsTableCreateCompanionBuilder =
    AccountItemsCompanion Function({
      Value<int> id,
      required int accountId,
      required int productId,
      required String productName,
      required String productImagePath,
      required String productCategory,
      required double unitPrice,
      required double unitCost,
      required int quantity,
    });
typedef $$AccountItemsTableUpdateCompanionBuilder =
    AccountItemsCompanion Function({
      Value<int> id,
      Value<int> accountId,
      Value<int> productId,
      Value<String> productName,
      Value<String> productImagePath,
      Value<String> productCategory,
      Value<double> unitPrice,
      Value<double> unitCost,
      Value<int> quantity,
    });

class $$AccountItemsTableFilterComposer
    extends Composer<_$AppDatabase, $AccountItemsTable> {
  $$AccountItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productImagePath => $composableBuilder(
    column: $table.productImagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productCategory => $composableBuilder(
    column: $table.productCategory,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get unitPrice => $composableBuilder(
    column: $table.unitPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get unitCost => $composableBuilder(
    column: $table.unitCost,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AccountItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $AccountItemsTable> {
  $$AccountItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productImagePath => $composableBuilder(
    column: $table.productImagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productCategory => $composableBuilder(
    column: $table.productCategory,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get unitPrice => $composableBuilder(
    column: $table.unitPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get unitCost => $composableBuilder(
    column: $table.unitCost,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AccountItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AccountItemsTable> {
  $$AccountItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<int> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get productImagePath => $composableBuilder(
    column: $table.productImagePath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get productCategory => $composableBuilder(
    column: $table.productCategory,
    builder: (column) => column,
  );

  GeneratedColumn<double> get unitPrice =>
      $composableBuilder(column: $table.unitPrice, builder: (column) => column);

  GeneratedColumn<double> get unitCost =>
      $composableBuilder(column: $table.unitCost, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);
}

class $$AccountItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AccountItemsTable,
          AccountItem,
          $$AccountItemsTableFilterComposer,
          $$AccountItemsTableOrderingComposer,
          $$AccountItemsTableAnnotationComposer,
          $$AccountItemsTableCreateCompanionBuilder,
          $$AccountItemsTableUpdateCompanionBuilder,
          (
            AccountItem,
            BaseReferences<_$AppDatabase, $AccountItemsTable, AccountItem>,
          ),
          AccountItem,
          PrefetchHooks Function()
        > {
  $$AccountItemsTableTableManager(_$AppDatabase db, $AccountItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AccountItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AccountItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AccountItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> accountId = const Value.absent(),
                Value<int> productId = const Value.absent(),
                Value<String> productName = const Value.absent(),
                Value<String> productImagePath = const Value.absent(),
                Value<String> productCategory = const Value.absent(),
                Value<double> unitPrice = const Value.absent(),
                Value<double> unitCost = const Value.absent(),
                Value<int> quantity = const Value.absent(),
              }) => AccountItemsCompanion(
                id: id,
                accountId: accountId,
                productId: productId,
                productName: productName,
                productImagePath: productImagePath,
                productCategory: productCategory,
                unitPrice: unitPrice,
                unitCost: unitCost,
                quantity: quantity,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int accountId,
                required int productId,
                required String productName,
                required String productImagePath,
                required String productCategory,
                required double unitPrice,
                required double unitCost,
                required int quantity,
              }) => AccountItemsCompanion.insert(
                id: id,
                accountId: accountId,
                productId: productId,
                productName: productName,
                productImagePath: productImagePath,
                productCategory: productCategory,
                unitPrice: unitPrice,
                unitCost: unitCost,
                quantity: quantity,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AccountItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AccountItemsTable,
      AccountItem,
      $$AccountItemsTableFilterComposer,
      $$AccountItemsTableOrderingComposer,
      $$AccountItemsTableAnnotationComposer,
      $$AccountItemsTableCreateCompanionBuilder,
      $$AccountItemsTableUpdateCompanionBuilder,
      (
        AccountItem,
        BaseReferences<_$AppDatabase, $AccountItemsTable, AccountItem>,
      ),
      AccountItem,
      PrefetchHooks Function()
    >;
typedef $$CashSessionsTableCreateCompanionBuilder =
    CashSessionsCompanion Function({
      Value<int> id,
      required DateTime openedAt,
      required double openingAmount,
      Value<DateTime?> closedAt,
      Value<double?> closingAmount,
      Value<bool> isOpen,
    });
typedef $$CashSessionsTableUpdateCompanionBuilder =
    CashSessionsCompanion Function({
      Value<int> id,
      Value<DateTime> openedAt,
      Value<double> openingAmount,
      Value<DateTime?> closedAt,
      Value<double?> closingAmount,
      Value<bool> isOpen,
    });

class $$CashSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $CashSessionsTable> {
  $$CashSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get openedAt => $composableBuilder(
    column: $table.openedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get openingAmount => $composableBuilder(
    column: $table.openingAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get closedAt => $composableBuilder(
    column: $table.closedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get closingAmount => $composableBuilder(
    column: $table.closingAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isOpen => $composableBuilder(
    column: $table.isOpen,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CashSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $CashSessionsTable> {
  $$CashSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get openedAt => $composableBuilder(
    column: $table.openedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get openingAmount => $composableBuilder(
    column: $table.openingAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get closedAt => $composableBuilder(
    column: $table.closedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get closingAmount => $composableBuilder(
    column: $table.closingAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isOpen => $composableBuilder(
    column: $table.isOpen,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CashSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CashSessionsTable> {
  $$CashSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get openedAt =>
      $composableBuilder(column: $table.openedAt, builder: (column) => column);

  GeneratedColumn<double> get openingAmount => $composableBuilder(
    column: $table.openingAmount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get closedAt =>
      $composableBuilder(column: $table.closedAt, builder: (column) => column);

  GeneratedColumn<double> get closingAmount => $composableBuilder(
    column: $table.closingAmount,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isOpen =>
      $composableBuilder(column: $table.isOpen, builder: (column) => column);
}

class $$CashSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CashSessionsTable,
          CashSession,
          $$CashSessionsTableFilterComposer,
          $$CashSessionsTableOrderingComposer,
          $$CashSessionsTableAnnotationComposer,
          $$CashSessionsTableCreateCompanionBuilder,
          $$CashSessionsTableUpdateCompanionBuilder,
          (
            CashSession,
            BaseReferences<_$AppDatabase, $CashSessionsTable, CashSession>,
          ),
          CashSession,
          PrefetchHooks Function()
        > {
  $$CashSessionsTableTableManager(_$AppDatabase db, $CashSessionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CashSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CashSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CashSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> openedAt = const Value.absent(),
                Value<double> openingAmount = const Value.absent(),
                Value<DateTime?> closedAt = const Value.absent(),
                Value<double?> closingAmount = const Value.absent(),
                Value<bool> isOpen = const Value.absent(),
              }) => CashSessionsCompanion(
                id: id,
                openedAt: openedAt,
                openingAmount: openingAmount,
                closedAt: closedAt,
                closingAmount: closingAmount,
                isOpen: isOpen,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime openedAt,
                required double openingAmount,
                Value<DateTime?> closedAt = const Value.absent(),
                Value<double?> closingAmount = const Value.absent(),
                Value<bool> isOpen = const Value.absent(),
              }) => CashSessionsCompanion.insert(
                id: id,
                openedAt: openedAt,
                openingAmount: openingAmount,
                closedAt: closedAt,
                closingAmount: closingAmount,
                isOpen: isOpen,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CashSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CashSessionsTable,
      CashSession,
      $$CashSessionsTableFilterComposer,
      $$CashSessionsTableOrderingComposer,
      $$CashSessionsTableAnnotationComposer,
      $$CashSessionsTableCreateCompanionBuilder,
      $$CashSessionsTableUpdateCompanionBuilder,
      (
        CashSession,
        BaseReferences<_$AppDatabase, $CashSessionsTable, CashSession>,
      ),
      CashSession,
      PrefetchHooks Function()
    >;
typedef $$BusinessSettingsTableCreateCompanionBuilder =
    BusinessSettingsCompanion Function({
      Value<int> id,
      Value<bool> enableTableSales,
      Value<bool> enableBarSales,
      Value<bool> enableQuickSale,
      Value<bool> enableTakeaway,
      Value<bool> enableDelivery,
    });
typedef $$BusinessSettingsTableUpdateCompanionBuilder =
    BusinessSettingsCompanion Function({
      Value<int> id,
      Value<bool> enableTableSales,
      Value<bool> enableBarSales,
      Value<bool> enableQuickSale,
      Value<bool> enableTakeaway,
      Value<bool> enableDelivery,
    });

class $$BusinessSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $BusinessSettingsTable> {
  $$BusinessSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get enableTableSales => $composableBuilder(
    column: $table.enableTableSales,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get enableBarSales => $composableBuilder(
    column: $table.enableBarSales,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get enableQuickSale => $composableBuilder(
    column: $table.enableQuickSale,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get enableTakeaway => $composableBuilder(
    column: $table.enableTakeaway,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get enableDelivery => $composableBuilder(
    column: $table.enableDelivery,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BusinessSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $BusinessSettingsTable> {
  $$BusinessSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get enableTableSales => $composableBuilder(
    column: $table.enableTableSales,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get enableBarSales => $composableBuilder(
    column: $table.enableBarSales,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get enableQuickSale => $composableBuilder(
    column: $table.enableQuickSale,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get enableTakeaway => $composableBuilder(
    column: $table.enableTakeaway,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get enableDelivery => $composableBuilder(
    column: $table.enableDelivery,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BusinessSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BusinessSettingsTable> {
  $$BusinessSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<bool> get enableTableSales => $composableBuilder(
    column: $table.enableTableSales,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get enableBarSales => $composableBuilder(
    column: $table.enableBarSales,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get enableQuickSale => $composableBuilder(
    column: $table.enableQuickSale,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get enableTakeaway => $composableBuilder(
    column: $table.enableTakeaway,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get enableDelivery => $composableBuilder(
    column: $table.enableDelivery,
    builder: (column) => column,
  );
}

class $$BusinessSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BusinessSettingsTable,
          BusinessSetting,
          $$BusinessSettingsTableFilterComposer,
          $$BusinessSettingsTableOrderingComposer,
          $$BusinessSettingsTableAnnotationComposer,
          $$BusinessSettingsTableCreateCompanionBuilder,
          $$BusinessSettingsTableUpdateCompanionBuilder,
          (
            BusinessSetting,
            BaseReferences<
              _$AppDatabase,
              $BusinessSettingsTable,
              BusinessSetting
            >,
          ),
          BusinessSetting,
          PrefetchHooks Function()
        > {
  $$BusinessSettingsTableTableManager(
    _$AppDatabase db,
    $BusinessSettingsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BusinessSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BusinessSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BusinessSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<bool> enableTableSales = const Value.absent(),
                Value<bool> enableBarSales = const Value.absent(),
                Value<bool> enableQuickSale = const Value.absent(),
                Value<bool> enableTakeaway = const Value.absent(),
                Value<bool> enableDelivery = const Value.absent(),
              }) => BusinessSettingsCompanion(
                id: id,
                enableTableSales: enableTableSales,
                enableBarSales: enableBarSales,
                enableQuickSale: enableQuickSale,
                enableTakeaway: enableTakeaway,
                enableDelivery: enableDelivery,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<bool> enableTableSales = const Value.absent(),
                Value<bool> enableBarSales = const Value.absent(),
                Value<bool> enableQuickSale = const Value.absent(),
                Value<bool> enableTakeaway = const Value.absent(),
                Value<bool> enableDelivery = const Value.absent(),
              }) => BusinessSettingsCompanion.insert(
                id: id,
                enableTableSales: enableTableSales,
                enableBarSales: enableBarSales,
                enableQuickSale: enableQuickSale,
                enableTakeaway: enableTakeaway,
                enableDelivery: enableDelivery,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BusinessSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BusinessSettingsTable,
      BusinessSetting,
      $$BusinessSettingsTableFilterComposer,
      $$BusinessSettingsTableOrderingComposer,
      $$BusinessSettingsTableAnnotationComposer,
      $$BusinessSettingsTableCreateCompanionBuilder,
      $$BusinessSettingsTableUpdateCompanionBuilder,
      (
        BusinessSetting,
        BaseReferences<_$AppDatabase, $BusinessSettingsTable, BusinessSetting>,
      ),
      BusinessSetting,
      PrefetchHooks Function()
    >;
typedef $$OpenAccountsTableCreateCompanionBuilder =
    OpenAccountsCompanion Function({
      Value<int> id,
      required String locationType,
      Value<int?> tableNumber,
      required String customerName,
      required DateTime openedAt,
      Value<bool> isClosed,
    });
typedef $$OpenAccountsTableUpdateCompanionBuilder =
    OpenAccountsCompanion Function({
      Value<int> id,
      Value<String> locationType,
      Value<int?> tableNumber,
      Value<String> customerName,
      Value<DateTime> openedAt,
      Value<bool> isClosed,
    });

class $$OpenAccountsTableFilterComposer
    extends Composer<_$AppDatabase, $OpenAccountsTable> {
  $$OpenAccountsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get locationType => $composableBuilder(
    column: $table.locationType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tableNumber => $composableBuilder(
    column: $table.tableNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get openedAt => $composableBuilder(
    column: $table.openedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isClosed => $composableBuilder(
    column: $table.isClosed,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OpenAccountsTableOrderingComposer
    extends Composer<_$AppDatabase, $OpenAccountsTable> {
  $$OpenAccountsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get locationType => $composableBuilder(
    column: $table.locationType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tableNumber => $composableBuilder(
    column: $table.tableNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get openedAt => $composableBuilder(
    column: $table.openedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isClosed => $composableBuilder(
    column: $table.isClosed,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OpenAccountsTableAnnotationComposer
    extends Composer<_$AppDatabase, $OpenAccountsTable> {
  $$OpenAccountsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get locationType => $composableBuilder(
    column: $table.locationType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get tableNumber => $composableBuilder(
    column: $table.tableNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get openedAt =>
      $composableBuilder(column: $table.openedAt, builder: (column) => column);

  GeneratedColumn<bool> get isClosed =>
      $composableBuilder(column: $table.isClosed, builder: (column) => column);
}

class $$OpenAccountsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OpenAccountsTable,
          OpenAccount,
          $$OpenAccountsTableFilterComposer,
          $$OpenAccountsTableOrderingComposer,
          $$OpenAccountsTableAnnotationComposer,
          $$OpenAccountsTableCreateCompanionBuilder,
          $$OpenAccountsTableUpdateCompanionBuilder,
          (
            OpenAccount,
            BaseReferences<_$AppDatabase, $OpenAccountsTable, OpenAccount>,
          ),
          OpenAccount,
          PrefetchHooks Function()
        > {
  $$OpenAccountsTableTableManager(_$AppDatabase db, $OpenAccountsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OpenAccountsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OpenAccountsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OpenAccountsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> locationType = const Value.absent(),
                Value<int?> tableNumber = const Value.absent(),
                Value<String> customerName = const Value.absent(),
                Value<DateTime> openedAt = const Value.absent(),
                Value<bool> isClosed = const Value.absent(),
              }) => OpenAccountsCompanion(
                id: id,
                locationType: locationType,
                tableNumber: tableNumber,
                customerName: customerName,
                openedAt: openedAt,
                isClosed: isClosed,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String locationType,
                Value<int?> tableNumber = const Value.absent(),
                required String customerName,
                required DateTime openedAt,
                Value<bool> isClosed = const Value.absent(),
              }) => OpenAccountsCompanion.insert(
                id: id,
                locationType: locationType,
                tableNumber: tableNumber,
                customerName: customerName,
                openedAt: openedAt,
                isClosed: isClosed,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OpenAccountsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OpenAccountsTable,
      OpenAccount,
      $$OpenAccountsTableFilterComposer,
      $$OpenAccountsTableOrderingComposer,
      $$OpenAccountsTableAnnotationComposer,
      $$OpenAccountsTableCreateCompanionBuilder,
      $$OpenAccountsTableUpdateCompanionBuilder,
      (
        OpenAccount,
        BaseReferences<_$AppDatabase, $OpenAccountsTable, OpenAccount>,
      ),
      OpenAccount,
      PrefetchHooks Function()
    >;
typedef $$AppUsersTableCreateCompanionBuilder =
    AppUsersCompanion Function({
      Value<int> id,
      required String username,
      required String displayName,
      required String role,
      required String pinHash,
      required String pinSalt,
      Value<int> pinHashVersion,
      Value<bool> isActive,
      Value<bool> requiresPinChange,
      Value<int> failedLoginAttempts,
      Value<DateTime?> lockedUntil,
      Value<DateTime?> lastLoginAt,
      required DateTime createdAt,
      required DateTime updatedAt,
    });
typedef $$AppUsersTableUpdateCompanionBuilder =
    AppUsersCompanion Function({
      Value<int> id,
      Value<String> username,
      Value<String> displayName,
      Value<String> role,
      Value<String> pinHash,
      Value<String> pinSalt,
      Value<int> pinHashVersion,
      Value<bool> isActive,
      Value<bool> requiresPinChange,
      Value<int> failedLoginAttempts,
      Value<DateTime?> lockedUntil,
      Value<DateTime?> lastLoginAt,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$AppUsersTableFilterComposer
    extends Composer<_$AppDatabase, $AppUsersTable> {
  $$AppUsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pinHash => $composableBuilder(
    column: $table.pinHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pinSalt => $composableBuilder(
    column: $table.pinSalt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pinHashVersion => $composableBuilder(
    column: $table.pinHashVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get requiresPinChange => $composableBuilder(
    column: $table.requiresPinChange,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get failedLoginAttempts => $composableBuilder(
    column: $table.failedLoginAttempts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lockedUntil => $composableBuilder(
    column: $table.lockedUntil,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastLoginAt => $composableBuilder(
    column: $table.lastLoginAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppUsersTableOrderingComposer
    extends Composer<_$AppDatabase, $AppUsersTable> {
  $$AppUsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pinHash => $composableBuilder(
    column: $table.pinHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pinSalt => $composableBuilder(
    column: $table.pinSalt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pinHashVersion => $composableBuilder(
    column: $table.pinHashVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get requiresPinChange => $composableBuilder(
    column: $table.requiresPinChange,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get failedLoginAttempts => $composableBuilder(
    column: $table.failedLoginAttempts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lockedUntil => $composableBuilder(
    column: $table.lockedUntil,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastLoginAt => $composableBuilder(
    column: $table.lastLoginAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppUsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppUsersTable> {
  $$AppUsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get pinHash =>
      $composableBuilder(column: $table.pinHash, builder: (column) => column);

  GeneratedColumn<String> get pinSalt =>
      $composableBuilder(column: $table.pinSalt, builder: (column) => column);

  GeneratedColumn<int> get pinHashVersion => $composableBuilder(
    column: $table.pinHashVersion,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<bool> get requiresPinChange => $composableBuilder(
    column: $table.requiresPinChange,
    builder: (column) => column,
  );

  GeneratedColumn<int> get failedLoginAttempts => $composableBuilder(
    column: $table.failedLoginAttempts,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lockedUntil => $composableBuilder(
    column: $table.lockedUntil,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastLoginAt => $composableBuilder(
    column: $table.lastLoginAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AppUsersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppUsersTable,
          AppUser,
          $$AppUsersTableFilterComposer,
          $$AppUsersTableOrderingComposer,
          $$AppUsersTableAnnotationComposer,
          $$AppUsersTableCreateCompanionBuilder,
          $$AppUsersTableUpdateCompanionBuilder,
          (AppUser, BaseReferences<_$AppDatabase, $AppUsersTable, AppUser>),
          AppUser,
          PrefetchHooks Function()
        > {
  $$AppUsersTableTableManager(_$AppDatabase db, $AppUsersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppUsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppUsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppUsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> username = const Value.absent(),
                Value<String> displayName = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<String> pinHash = const Value.absent(),
                Value<String> pinSalt = const Value.absent(),
                Value<int> pinHashVersion = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<bool> requiresPinChange = const Value.absent(),
                Value<int> failedLoginAttempts = const Value.absent(),
                Value<DateTime?> lockedUntil = const Value.absent(),
                Value<DateTime?> lastLoginAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => AppUsersCompanion(
                id: id,
                username: username,
                displayName: displayName,
                role: role,
                pinHash: pinHash,
                pinSalt: pinSalt,
                pinHashVersion: pinHashVersion,
                isActive: isActive,
                requiresPinChange: requiresPinChange,
                failedLoginAttempts: failedLoginAttempts,
                lockedUntil: lockedUntil,
                lastLoginAt: lastLoginAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String username,
                required String displayName,
                required String role,
                required String pinHash,
                required String pinSalt,
                Value<int> pinHashVersion = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<bool> requiresPinChange = const Value.absent(),
                Value<int> failedLoginAttempts = const Value.absent(),
                Value<DateTime?> lockedUntil = const Value.absent(),
                Value<DateTime?> lastLoginAt = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
              }) => AppUsersCompanion.insert(
                id: id,
                username: username,
                displayName: displayName,
                role: role,
                pinHash: pinHash,
                pinSalt: pinSalt,
                pinHashVersion: pinHashVersion,
                isActive: isActive,
                requiresPinChange: requiresPinChange,
                failedLoginAttempts: failedLoginAttempts,
                lockedUntil: lockedUntil,
                lastLoginAt: lastLoginAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppUsersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppUsersTable,
      AppUser,
      $$AppUsersTableFilterComposer,
      $$AppUsersTableOrderingComposer,
      $$AppUsersTableAnnotationComposer,
      $$AppUsersTableCreateCompanionBuilder,
      $$AppUsersTableUpdateCompanionBuilder,
      (AppUser, BaseReferences<_$AppDatabase, $AppUsersTable, AppUser>),
      AppUser,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProductsTableTableManager get products =>
      $$ProductsTableTableManager(_db, _db.products);
  $$SalesTableTableManager get sales =>
      $$SalesTableTableManager(_db, _db.sales);
  $$SaleItemsTableTableManager get saleItems =>
      $$SaleItemsTableTableManager(_db, _db.saleItems);
  $$PaymentsTableTableManager get payments =>
      $$PaymentsTableTableManager(_db, _db.payments);
  $$TableAccountsTableTableManager get tableAccounts =>
      $$TableAccountsTableTableManager(_db, _db.tableAccounts);
  $$AccountItemsTableTableManager get accountItems =>
      $$AccountItemsTableTableManager(_db, _db.accountItems);
  $$CashSessionsTableTableManager get cashSessions =>
      $$CashSessionsTableTableManager(_db, _db.cashSessions);
  $$BusinessSettingsTableTableManager get businessSettings =>
      $$BusinessSettingsTableTableManager(_db, _db.businessSettings);
  $$OpenAccountsTableTableManager get openAccounts =>
      $$OpenAccountsTableTableManager(_db, _db.openAccounts);
  $$AppUsersTableTableManager get appUsers =>
      $$AppUsersTableTableManager(_db, _db.appUsers);
}
