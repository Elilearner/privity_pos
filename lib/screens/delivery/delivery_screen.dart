import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/currency_formatter.dart';
import '../../models/invoice_item.dart';
import '../../models/sale_draft.dart';
import '../../models/sale_type.dart';
import '../../services/service_locator.dart';
import '../../widgets/invoice/invoice_item_card.dart';
import '../../widgets/products/product_card.dart';
import '../payment/payment_screen.dart';

class DeliveryScreen extends StatefulWidget {
  const DeliveryScreen({super.key});

  @override
  State<DeliveryScreen> createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends State<DeliveryScreen> {
  final SaleDraft _draft = SaleDraft(type: SaleType.delivery);

  final TextEditingController _customerNameController = TextEditingController();

  final TextEditingController _phoneController = TextEditingController();

  final TextEditingController _addressController = TextEditingController();

  final TextEditingController _referenceController = TextEditingController();

  final TextEditingController _deliveryFeeController = TextEditingController();

  String _searchQuery = '';

  @override
  void dispose() {
    _customerNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _referenceController.dispose();
    _deliveryFeeController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final products = Services.products.search(_searchQuery);

    return Scaffold(
      appBar: AppBar(title: const Text('Delivery')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            _buildCustomerSection(),

            const SizedBox(height: 18),

            const Text(
              'PRODUCTOS',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

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

            SizedBox(
              height: 340,
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

            const SizedBox(height: 18),

            const Text(
              'PEDIDO',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            if (_draft.items.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 30),
                child: Text(
                  'Agrega productos para iniciar el delivery.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
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

            const SizedBox(height: 16),

            _buildTotalsCard(),

            const SizedBox(height: 14),

            SizedBox(
              height: 52,
              child: FilledButton.icon(
                onPressed: _draft.isEmpty ? null : _openPaymentScreen,
                icon: const Icon(Icons.delivery_dining),
                label: const Text('COBRAR DELIVERY'),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerSection() {
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
          const Text(
            'DATOS DEL CLIENTE',
            style: TextStyle(
              color: AppColors.goldLight,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 14),

          TextField(
            controller: _customerNameController,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: 'Nombre del cliente',
              prefixIcon: Icon(Icons.person_outline),
            ),
          ),

          const SizedBox(height: 12),

          TextField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: 'Teléfono',
              prefixIcon: Icon(Icons.phone_outlined),
            ),
          ),

          const SizedBox(height: 12),

          TextField(
            controller: _addressController,
            textCapitalization: TextCapitalization.sentences,
            maxLines: 2,
            decoration: const InputDecoration(
              labelText: 'Dirección de entrega',
              prefixIcon: Icon(Icons.location_on_outlined),
            ),
          ),

          const SizedBox(height: 12),

          TextField(
            controller: _referenceController,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              labelText: 'Referencia de ubicación',
              hintText: 'Opcional',
              prefixIcon: Icon(Icons.place_outlined),
            ),
          ),

          const SizedBox(height: 12),

          TextField(
            controller: _deliveryFeeController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Costo de delivery',
              hintText: '0.00',
              prefixIcon: Icon(Icons.delivery_dining),
            ),
            onChanged: (value) {
              final amount = _parseAmount(value);

              setState(() {
                _draft.deliveryFee = amount ?? 0;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTotalsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _DeliveryTotalRow(
            label: 'Productos',
            value: CurrencyFormatter.format(_draft.subtotal),
          ),

          const SizedBox(height: 10),

          _DeliveryTotalRow(
            label: 'Delivery',
            value: CurrencyFormatter.format(_draft.deliveryFee),
          ),

          if (_draft.tax > 0) ...[
            const SizedBox(height: 10),
            _DeliveryTotalRow(
              label: 'Impuestos',
              value: CurrencyFormatter.format(_draft.tax),
            ),
          ],

          const Divider(height: 28),

          _DeliveryTotalRow(
            label: 'TOTAL',
            value: CurrencyFormatter.format(_draft.total),
            highlighted: true,
          ),

          const SizedBox(height: 10),

          _DeliveryTotalRow(label: 'Productos', value: '${_draft.totalItems}'),
        ],
      ),
    );
  }

  Future<void> _openPaymentScreen() async {
    final customerName = _customerNameController.text.trim();

    final phone = _phoneController.text.trim();

    final address = _addressController.text.trim();

    final reference = _referenceController.text.trim();

    if (customerName.isEmpty) {
      _showValidationMessage('Ingresa el nombre del cliente.');

      return;
    }

    if (phone.isEmpty) {
      _showValidationMessage('Ingresa el teléfono del cliente.');

      return;
    }

    if (address.isEmpty) {
      _showValidationMessage('Ingresa la dirección de entrega.');

      return;
    }

    _draft.customerName = customerName;

    _draft.customerPhone = phone;

    _draft.deliveryAddress = address;

    _draft.deliveryReference = reference.isEmpty ? null : reference;

    final paymentCompleted = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => PaymentScreen(draft: _draft)),
    );

    if (!mounted) {
      return;
    }

    if (paymentCompleted == true) {
      _resetForm();

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Delivery completado.')));

      return;
    }

    setState(() {});
  }

  void _resetForm() {
    _customerNameController.clear();
    _phoneController.clear();
    _addressController.clear();
    _referenceController.clear();
    _deliveryFeeController.clear();

    setState(() {
      _searchQuery = '';
      _draft.customerName = null;
      _draft.customerPhone = null;
      _draft.deliveryAddress = null;
      _draft.deliveryReference = null;
      _draft.deliveryFee = 0;
      _draft.taxRate = 0;
    });
  }

  void _showValidationMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  double? _parseAmount(String value) {
    final cleaned = value.replaceAll(',', '').trim();

    if (cleaned.isEmpty) {
      return null;
    }

    final amount = double.tryParse(cleaned);

    if (amount == null || amount < 0) {
      return null;
    }

    return amount;
  }
}

class _DeliveryTotalRow extends StatelessWidget {
  const _DeliveryTotalRow({
    required this.label,
    required this.value,
    this.highlighted = false,
  });

  final String label;
  final String value;

  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: highlighted
                  ? AppColors.goldLight
                  : AppColors.textSecondary,
              fontSize: highlighted ? 16 : 14,
              fontWeight: highlighted ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: highlighted ? AppColors.goldLight : AppColors.textPrimary,
            fontSize: highlighted ? 18 : 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
