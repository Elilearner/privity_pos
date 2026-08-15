import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../models/invoice_item.dart';
import '../../models/open_account.dart';
import '../../services/service_locator.dart';
import '../../widgets/invoice/invoice_item_card.dart';
import '../../widgets/invoice/invoice_summary_card.dart';
import '../payment/payment_screen.dart';
import '../product_picker/product_picker_screen.dart';

class InvoiceScreen extends StatefulWidget {
  const InvoiceScreen({super.key, required this.account});

  final OpenAccount account;

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  OpenAccount get account => widget.account;

  String get _accountTitle {
    if (account.isBar) {
      return 'Barra - ${account.customerName}';
    }

    return 'Mesa ${account.tableNumber} - ${account.customerName}';
  }

  String get _locationName {
    if (account.isBar) {
      return 'Barra';
    }

    return 'Mesa ${account.tableNumber}';
  }

  bool get _canMoveToBar {
    return account.isTable && Services.settings.enableBarSales;
  }

  bool get _canMoveToTable {
    return Services.settings.enableTableSales;
  }

  bool get _hasMoveOptions {
    return _canMoveToBar || _canMoveToTable;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_accountTitle),
        actions: [
          if (_hasMoveOptions)
            PopupMenuButton<String>(
              tooltip: 'Opciones de la cuenta',
              onSelected: _handleAccountAction,
              itemBuilder: (context) {
                final items = <PopupMenuEntry<String>>[];

                if (_canMoveToTable) {
                  items.add(
                    PopupMenuItem<String>(
                      value: 'move_table',
                      child: Row(
                        children: [
                          const Icon(Icons.table_restaurant_outlined),
                          const SizedBox(width: 10),
                          Text(
                            account.isBar
                                ? 'Mover a una mesa'
                                : 'Mover a otra mesa',
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (_canMoveToBar) {
                  items.add(
                    const PopupMenuItem<String>(
                      value: 'move_bar',
                      child: Row(
                        children: [
                          Icon(Icons.local_bar_outlined),
                          SizedBox(width: 10),
                          Text('Mover a Barra'),
                        ],
                      ),
                    ),
                  );
                }

                return items;
              },
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cuenta: ${account.customerName}',
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              _locationName,
              style: const TextStyle(color: AppColors.textSecondary),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: account.items.isEmpty
                  ? const Center(
                      child: Text(
                        'Esta cuenta todavía no tiene productos.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    )
                  : ListView.separated(
                      itemCount: account.items.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final item = account.items[index];

                        return InvoiceItemCard(
                          item: item,
                          onIncrease: () async {
                            await _increaseItem(item);
                          },
                          onDecrease: () async {
                            if (item.quantity > 1) {
                              final changed = Services.sales
                                  .decreaseProductQuantity(
                                    account: account,
                                    productId: item.product.id,
                                  );

                              if (!changed) {
                                return;
                              }

                              await _saveAccount();

                              if (!mounted) {
                                return;
                              }

                              setState(() {});
                              return;
                            }

                            final shouldDelete = await _confirmDeleteProduct(
                              item,
                            );

                            if (!mounted || !shouldDelete) {
                              return;
                            }

                            final removed = Services.sales.removeProduct(
                              account: account,
                              productId: item.product.id,
                            );

                            if (!removed) {
                              return;
                            }

                            await _saveAccount();

                            if (!mounted) {
                              return;
                            }

                            setState(() {});
                          },
                          onDelete: () async {
                            final shouldDelete = await _confirmDeleteProduct(
                              item,
                            );

                            if (!mounted || !shouldDelete) {
                              return;
                            }

                            final removed = Services.sales.removeProduct(
                              account: account,
                              productId: item.product.id,
                            );

                            if (!removed) {
                              return;
                            }

                            await _saveAccount();

                            if (!mounted) {
                              return;
                            }

                            setState(() {});
                          },
                        );
                      },
                    ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton.icon(
                onPressed: _openProductPicker,
                icon: const Icon(Icons.add_shopping_cart),
                label: const Text('AGREGAR PRODUCTOS'),
              ),
            ),

            const SizedBox(height: 12),

            InvoiceSummaryCard(
              totalItems: account.totalItems,
              subtotal: account.subtotal,
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton.icon(
                onPressed: account.items.isEmpty ? null : _openPaymentScreen,
                icon: const Icon(Icons.payments_outlined),
                label: const Text('COBRAR'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleAccountAction(String action) async {
    switch (action) {
      case 'move_table':
        await _showMoveToTableDialog();
        break;

      case 'move_bar':
        await _moveToBar();
        break;
    }
  }

  Future<void> _showMoveToTableDialog() async {
    final tables = Services.tables.tables;

    if (tables.isEmpty) {
      _showMessage('No hay mesas configuradas.');
      return;
    }

    final selectedTableNumber = await showDialog<int>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            account.isBar ? 'Mover cuenta a Mesa' : 'Mover cuenta a otra Mesa',
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: tables.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final table = tables[index];

                final isCurrentTable =
                    account.isTable && account.tableNumber == table.number;

                return ListTile(
                  enabled: !isCurrentTable,
                  leading: Icon(
                    Icons.table_restaurant_outlined,
                    color: isCurrentTable
                        ? AppColors.textSecondary
                        : AppColors.goldLight,
                  ),
                  title: Text('Mesa ${table.number}'),
                  subtitle: Text(
                    _tableSubtitle(
                      table.name,
                      table.totalAccounts,
                      isCurrentTable,
                    ),
                  ),
                  trailing: isCurrentTable
                      ? const Icon(
                          Icons.check_circle,
                          color: AppColors.textSecondary,
                        )
                      : const Icon(Icons.chevron_right),
                  onTap: isCurrentTable
                      ? null
                      : () {
                          Navigator.pop(dialogContext, table.number);
                        },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('CANCELAR'),
            ),
          ],
        );
      },
    );

    if (!mounted || selectedTableNumber == null) {
      return;
    }

    final destinationTable = Services.tables.getTable(selectedTableNumber);

    if (destinationTable == null) {
      _showMessage('La mesa seleccionada no está disponible.');
      return;
    }

    final confirmed = await _confirmMove(
      title: 'Mover cuenta',
      message:
          '¿Deseas mover la cuenta de '
          '${account.customerName} a '
          'Mesa $selectedTableNumber?',
    );

    if (!mounted || !confirmed) {
      return;
    }

    final moved = await Services.tables.moveAccountToTable(
      accountId: account.id,
      tableNumber: selectedTableNumber,
    );

    if (!mounted) {
      return;
    }

    if (!moved) {
      _showMessage('No se pudo mover la cuenta a la mesa.');
      return;
    }

    setState(() {});

    _showMessage(
      '${account.customerName} fue movido a '
      'Mesa $selectedTableNumber.',
    );
  }

  Future<void> _moveToBar() async {
    if (!Services.settings.enableBarSales) {
      _showMessage('El módulo de Barra está desactivado.');
      return;
    }

    final confirmed = await _confirmMove(
      title: 'Mover a Barra',
      message:
          '¿Deseas mover la cuenta de '
          '${account.customerName} a Barra?',
    );

    if (!mounted || !confirmed) {
      return;
    }

    final moved = await Services.tables.moveAccountToBar(accountId: account.id);

    if (!mounted) {
      return;
    }

    if (!moved) {
      _showMessage('No se pudo mover la cuenta a Barra.');
      return;
    }

    setState(() {});

    _showMessage('${account.customerName} fue movido a Barra.');
  }

  String _tableSubtitle(
    String? tableName,
    int accountCount,
    bool isCurrentTable,
  ) {
    if (isCurrentTable) {
      return 'Ubicación actual';
    }

    final accountText = accountCount == 0
        ? 'Sin cuentas abiertas'
        : '$accountCount cuenta'
              '${accountCount == 1 ? '' : 's'} abierta'
              '${accountCount == 1 ? '' : 's'}';

    final cleanName = tableName?.trim();

    if (cleanName == null || cleanName.isEmpty) {
      return accountText;
    }

    return '$cleanName · $accountText';
  }

  Future<bool> _confirmMove({
    required String title,
    required String message,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('CANCELAR'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('MOVER'),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  Future<void> _increaseItem(InvoiceItem item) async {
    final currentProduct = Services.products.getProduct(item.product.id);

    if (currentProduct == null) {
      _showStockMessage(productName: item.product.name, availableStock: 0);
      return;
    }

    if (!currentProduct.isActive) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${currentProduct.name} está inactivo.')),
      );

      return;
    }

    final availableForThisAccount = Services.products.getAvailableStock(
      productId: currentProduct.id,
      excludeAccountId: account.id,
    );

    final desiredQuantity = item.quantity + 1;

    if (desiredQuantity > availableForThisAccount) {
      _showStockMessage(
        productName: currentProduct.name,
        availableStock: availableForThisAccount,
      );
      return;
    }

    final changed = Services.sales.increaseProductQuantity(
      account: account,
      productId: item.product.id,
    );

    if (!changed) {
      return;
    }

    await _saveAccount();

    if (!mounted) {
      return;
    }

    setState(() {});
  }

  Future<void> _openProductPicker() async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ProductPickerScreen(account: account)),
    );

    if (!mounted) {
      return;
    }

    await _saveAccount();

    if (!mounted) {
      return;
    }

    setState(() {});
  }

  Future<void> _openPaymentScreen() async {
    final paymentCompleted = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => PaymentScreen(account: account)),
    );

    if (!mounted) {
      return;
    }

    if (paymentCompleted == true) {
      Navigator.of(context).pop(true);
      return;
    }

    setState(() {});
  }

  Future<void> _saveAccount() async {
    await Services.openAccounts.saveAccount(account);
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

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<bool> _confirmDeleteProduct(InvoiceItem item) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Eliminar producto'),
          content: Text(
            '¿Deseas eliminar '
            '${item.product.name} '
            'de esta cuenta?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('CANCELAR'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('ELIMINAR'),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }
}
