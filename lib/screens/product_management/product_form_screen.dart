import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../core/app_colors.dart';
import '../../models/product.dart';
import '../../services/service_locator.dart';

class ProductFormScreen extends StatefulWidget {
  const ProductFormScreen({super.key, this.product});

  final Product? product;

  bool get isEditing => product != null;

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final ImagePicker _imagePicker = ImagePicker();

  late final TextEditingController _nameController;
  late final TextEditingController _categoryController;
  late final TextEditingController _purchasePriceController;
  late final TextEditingController _salePriceController;
  late final TextEditingController _stockController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _barcodeController;

  bool _isActive = true;
  bool _favorite = false;

  bool _saving = false;
  bool _selectingImage = false;

  String _currentImagePath = '';
  String? _pickedImagePath;

  bool _imageRemoved = false;

  @override
  void initState() {
    super.initState();

    final product = widget.product;

    _nameController = TextEditingController(text: product?.name ?? '');

    _categoryController = TextEditingController(text: product?.category ?? '');

    _purchasePriceController = TextEditingController(
      text: product == null ? '' : product.purchasePrice.toStringAsFixed(2),
    );

    _salePriceController = TextEditingController(
      text: product == null ? '' : product.salePrice.toStringAsFixed(2),
    );

    _stockController = TextEditingController(
      text: product?.stock.toString() ?? '0',
    );

    _descriptionController = TextEditingController(
      text: product?.description ?? '',
    );

    _barcodeController = TextEditingController(text: product?.barcode ?? '');

    _isActive = product?.isActive ?? true;
    _favorite = product?.favorite ?? false;

    _currentImagePath = product?.imagePath.trim() ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _purchasePriceController.dispose();
    _salePriceController.dispose();
    _stockController.dispose();
    _descriptionController.dispose();
    _barcodeController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Editar producto' : 'Agregar producto'),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(14),
            children: [
              _buildImageSection(),

              const SizedBox(height: 20),

              _buildBasicInfoCard(),

              const SizedBox(height: 16),

              _buildPricesCard(),

              const SizedBox(height: 16),

              _buildInventoryCard(),

              const SizedBox(height: 16),

              _buildAdditionalInfoCard(),

              const SizedBox(height: 20),

              SizedBox(
                height: 52,
                child: FilledButton.icon(
                  onPressed: _saving ? null : _saveProduct,
                  icon: _saving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.save_outlined),
                  label: Text(
                    _saving
                        ? 'GUARDANDO...'
                        : widget.isEditing
                        ? 'GUARDAR CAMBIOS'
                        : 'AGREGAR PRODUCTO',
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    final displayPath = _pickedImagePath ?? _currentImagePath;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(11),
              child: displayPath.isEmpty
                  ? const Center(
                      child: Icon(
                        Icons.add_a_photo_outlined,
                        color: AppColors.goldLight,
                        size: 46,
                      ),
                    )
                  : _buildImagePreview(displayPath),
            ),
          ),

          const SizedBox(height: 12),

          const Text(
            'Foto del producto',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            'La imagen se optimizará '
            'automáticamente al guardar.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _selectingImage
                      ? null
                      : () {
                          _pickImage(ImageSource.camera);
                        },
                  icon: const Icon(Icons.photo_camera_outlined),
                  label: const Text('CÁMARA'),
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _selectingImage
                      ? null
                      : () {
                          _pickImage(ImageSource.gallery);
                        },
                  icon: const Icon(Icons.photo_library_outlined),
                  label: const Text('GALERÍA'),
                ),
              ),
            ],
          ),

          if (_selectingImage) ...[
            const SizedBox(height: 12),
            const LinearProgressIndicator(),
          ],

          if (displayPath.isNotEmpty) ...[
            const SizedBox(height: 8),

            TextButton.icon(
              onPressed: _selectingImage ? null : _removeImage,
              icon: const Icon(Icons.delete_outline),
              label: const Text('QUITAR FOTO'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildImagePreview(String path) {
    if (_isAssetPath(path)) {
      return Padding(
        padding: const EdgeInsets.all(8),
        child: Image.asset(
          path,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return const Center(
              child: Icon(
                Icons.image_not_supported_outlined,
                color: AppColors.goldLight,
                size: 44,
              ),
            );
          },
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Image.file(
        File(path),
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return const Center(
            child: Icon(
              Icons.image_not_supported_outlined,
              color: AppColors.goldLight,
              size: 44,
            ),
          );
        },
      ),
    );
  }

  Widget _buildBasicInfoCard() {
    return _FormSection(
      title: 'INFORMACIÓN BÁSICA',
      children: [
        TextFormField(
          controller: _nameController,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            labelText: 'Nombre del producto',
            prefixIcon: Icon(Icons.inventory_2_outlined),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Ingresa el nombre del producto.';
            }

            return null;
          },
        ),

        const SizedBox(height: 12),

        TextFormField(
          controller: _categoryController,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            labelText: 'Categoría',
            prefixIcon: Icon(Icons.category_outlined),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Ingresa una categoría.';
            }

            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPricesCard() {
    return _FormSection(
      title: 'PRECIOS',
      children: [
        TextFormField(
          controller: _purchasePriceController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: 'Precio de compra',
            prefixIcon: Icon(Icons.shopping_cart_outlined),
          ),
          validator: (value) {
            final amount = _parseDouble(value);

            if (amount == null || amount < 0) {
              return 'Ingresa un precio válido.';
            }

            return null;
          },
        ),

        const SizedBox(height: 12),

        TextFormField(
          controller: _salePriceController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: 'Precio de venta',
            prefixIcon: Icon(Icons.sell_outlined),
          ),
          validator: (value) {
            final amount = _parseDouble(value);

            if (amount == null || amount <= 0) {
              return 'Ingresa un precio de venta válido.';
            }

            return null;
          },
        ),
      ],
    );
  }

  Widget _buildInventoryCard() {
    return _FormSection(
      title: 'INVENTARIO',
      children: [
        TextFormField(
          controller: _stockController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Cantidad existente',
            prefixIcon: Icon(Icons.inventory_outlined),
          ),
          validator: (value) {
            final stock = int.tryParse(value?.trim() ?? '');

            if (stock == null || stock < 0) {
              return 'Ingresa una cantidad válida.';
            }

            return null;
          },
        ),

        const SizedBox(height: 12),

        SwitchListTile(
          value: _isActive,
          contentPadding: EdgeInsets.zero,
          activeThumbColor: AppColors.goldLight,
          title: const Text(
            'Producto activo',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: const Text(
            'Si está desactivado, no debería '
            'aparecer en las pantallas de venta.',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
          ),
          onChanged: (value) {
            setState(() {
              _isActive = value;
            });
          },
        ),

        SwitchListTile(
          value: _favorite,
          contentPadding: EdgeInsets.zero,
          activeThumbColor: AppColors.goldLight,
          title: const Text(
            'Favorito',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: const Text(
            'Podrá utilizarse más adelante '
            'para accesos rápidos.',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
          ),
          onChanged: (value) {
            setState(() {
              _favorite = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildAdditionalInfoCard() {
    return _FormSection(
      title: 'INFORMACIÓN ADICIONAL',
      children: [
        TextFormField(
          controller: _barcodeController,
          keyboardType: TextInputType.text,
          decoration: const InputDecoration(
            labelText: 'Código de barras',
            hintText: 'Opcional',
            prefixIcon: Icon(Icons.qr_code_scanner),
          ),
        ),

        const SizedBox(height: 12),

        TextFormField(
          controller: _descriptionController,
          textCapitalization: TextCapitalization.sentences,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'Descripción',
            hintText: 'Opcional',
            alignLabelWithHint: true,
            prefixIcon: Icon(Icons.description_outlined),
          ),
        ),
      ],
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    if (_selectingImage) {
      return;
    }

    setState(() {
      _selectingImage = true;
    });

    try {
      final pickedFile = await _imagePicker.pickImage(
        source: source,

        // Primera reducción antes de
        // hacer nuestra optimización final.
        maxWidth: 1600,
        maxHeight: 1600,
        imageQuality: 90,
      );

      if (!mounted) {
        return;
      }

      if (pickedFile == null) {
        return;
      }

      setState(() {
        _pickedImagePath = pickedFile.path;

        _imageRemoved = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'No se pudo seleccionar la imagen: '
            '$error',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _selectingImage = false;
        });
      }
    }
  }

  void _removeImage() {
    setState(() {
      _pickedImagePath = null;
      _currentImagePath = '';
      _imageRemoved = true;
    });
  }

  Future<String> _optimizeAndSaveImage({
    required String sourcePath,
    required int productId,
  }) async {
    final sourceFile = File(sourcePath);

    final originalBytes = await sourceFile.readAsBytes();

    final decoded = img.decodeImage(originalBytes);

    if (decoded == null) {
      throw Exception('No se pudo procesar la imagen.');
    }

    // Corrige automáticamente fotos
    // que fueron tomadas rotadas.
    final oriented = img.bakeOrientation(decoded);

    img.Image resized = oriented;

    const maxDimension = 600;

    if (oriented.width > maxDimension || oriented.height > maxDimension) {
      if (oriented.width >= oriented.height) {
        resized = img.copyResize(oriented, width: maxDimension);
      } else {
        resized = img.copyResize(oriented, height: maxDimension);
      }
    }

    final jpgBytes = img.encodeJpg(resized, quality: 78);

    final appDirectory = await getApplicationDocumentsDirectory();

    final imagesDirectory = Directory(
      '${appDirectory.path}'
      '${Platform.pathSeparator}'
      'product_images',
    );

    if (!await imagesDirectory.exists()) {
      await imagesDirectory.create(recursive: true);
    }

    final timestamp = DateTime.now().millisecondsSinceEpoch;

    final destinationPath =
        '${imagesDirectory.path}'
        '${Platform.pathSeparator}'
        'product_${productId}_$timestamp.jpg';

    final destinationFile = File(destinationPath);

    await destinationFile.writeAsBytes(jpgBytes, flush: true);

    return destinationPath;
  }

  Future<void> _saveProduct() async {
    if (_saving) {
      return;
    }

    final valid = _formKey.currentState?.validate() ?? false;

    if (!valid) {
      return;
    }

    final purchasePrice = _parseDouble(_purchasePriceController.text);

    final salePrice = _parseDouble(_salePriceController.text);

    final stock = int.tryParse(_stockController.text.trim());

    if (purchasePrice == null || salePrice == null || stock == null) {
      return;
    }

    setState(() {
      _saving = true;
    });

    final existingProduct = widget.product;

    final productId = existingProduct?.id ?? _generateNextProductId();

    String imagePath = _currentImagePath;

    String? newlySavedImagePath;

    try {
      if (_pickedImagePath != null) {
        newlySavedImagePath = await _optimizeAndSaveImage(
          sourcePath: _pickedImagePath!,
          productId: productId,
        );

        imagePath = newlySavedImagePath;
      } else if (_imageRemoved) {
        imagePath = '';
      }

      final product = Product(
        id: productId,
        name: _nameController.text.trim(),
        salePrice: salePrice,
        purchasePrice: purchasePrice,
        imagePath: imagePath,
        category: _categoryController.text.trim(),
        stock: stock,
        isActive: _isActive,
        description: _descriptionController.text.trim(),
        barcode: _barcodeController.text.trim(),
        favorite: _favorite,
      );

      await Services.products.saveProduct(product);

      final oldImagePath = existingProduct?.imagePath.trim();

      final imageChanged =
          oldImagePath != null &&
          oldImagePath.isNotEmpty &&
          oldImagePath != imagePath;

      if (imageChanged && !_isAssetPath(oldImagePath)) {
        await _deleteLocalImage(oldImagePath);
      }
    } catch (error) {
      if (newlySavedImagePath != null) {
        await _deleteLocalImage(newlySavedImagePath);
      }

      if (!mounted) {
        return;
      }

      setState(() {
        _saving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'No se pudo guardar el producto: '
            '$error',
          ),
        ),
      );

      return;
    }

    if (!mounted) {
      return;
    }

    Navigator.of(context).pop(true);
  }

  Future<void> _deleteLocalImage(String path) async {
    if (path.trim().isEmpty || _isAssetPath(path)) {
      return;
    }

    try {
      final file = File(path);

      if (await file.exists()) {
        await file.delete();
      }
    } catch (_) {
      // Si la imagen no puede eliminarse,
      // no impedimos guardar el producto.
    }
  }

  bool _isAssetPath(String path) {
    return path.startsWith('assets/');
  }

  int _generateNextProductId() {
    var highestId = 0;

    for (final product in Services.products.products) {
      if (product.id > highestId) {
        highestId = product.id;
      }
    }

    return highestId + 1;
  }

  double? _parseDouble(String? value) {
    if (value == null) {
      return null;
    }

    final cleanValue = value.replaceAll(',', '').trim();

    if (cleanValue.isEmpty) {
      return null;
    }

    return double.tryParse(cleanValue);
  }
}

class _FormSection extends StatelessWidget {
  const _FormSection({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.goldLight,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 14),

          ...children,
        ],
      ),
    );
  }
}
