import 'package:flutter/material.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

import '../../core/app_colors.dart';
import '../../services/printer_service.dart';
import '../../services/service_locator.dart';
import '../product_management/product_management_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _searchingPrinters = false;
  bool _printingTest = false;
  bool _savingModule = false;

  PrinterPaperSize get _paperSize {
    return Services.printer.paperSize;
  }

  String? get _selectedPrinterName {
    return Services.printer.printerName;
  }

  String? get _selectedPrinterMacAddress {
    return Services.printer.printerMacAddress;
  }

  bool get _hasSelectedPrinter {
    return Services.printer.hasSelectedPrinter;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(14),
      children: [
        const Text(
          'AJUSTES',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 20),

        const _SettingsSectionTitle(title: 'MÓDULOS DEL NEGOCIO'),

        const SizedBox(height: 10),

        _buildBusinessModulesCard(),

        const SizedBox(height: 8),

        const Text(
          'Activa únicamente las formas de venta que utiliza el negocio.',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
        ),

        const SizedBox(height: 24),

        const _SettingsSectionTitle(title: 'PRODUCTOS E INVENTARIO'),

        const SizedBox(height: 10),

        _buildProductManagementCard(),

        const SizedBox(height: 24),

        const _SettingsSectionTitle(title: 'IMPRESORA'),

        const SizedBox(height: 10),

        _buildPrinterCard(),

        const SizedBox(height: 20),

        const _SettingsSectionTitle(title: 'TAMAÑO DEL PAPEL'),

        const SizedBox(height: 10),

        _buildPaperSizeCard(),

        const SizedBox(height: 20),

        SizedBox(
          height: 50,
          child: FilledButton.icon(
            onPressed: _searchingPrinters ? null : _searchPrinters,
            icon: _searchingPrinters
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.bluetooth_searching),
            label: Text(
              _searchingPrinters ? 'BUSCANDO...' : 'BUSCAR IMPRESORAS',
            ),
          ),
        ),

        const SizedBox(height: 12),

        SizedBox(
          height: 50,
          child: OutlinedButton.icon(
            onPressed: !_hasSelectedPrinter || _printingTest
                ? null
                : _printTest,
            icon: _printingTest
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.print_outlined),
            label: Text(_printingTest ? 'IMPRIMIENDO...' : 'IMPRIMIR PRUEBA'),
          ),
        ),

        if (_hasSelectedPrinter) ...[
          const SizedBox(height: 12),

          SizedBox(
            height: 48,
            child: TextButton.icon(
              onPressed: _clearPrinter,
              icon: const Icon(Icons.link_off),
              label: const Text('QUITAR IMPRESORA'),
            ),
          ),
        ],

        const SizedBox(height: 24),

        const Text(
          'La conexión e impresión física '
          'debe probarse en un dispositivo real '
          'con una impresora térmica Bluetooth.',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
        ),

        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildBusinessModulesCard() {
    final settings = Services.settings;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _ModuleSwitchTile(
            icon: Icons.table_restaurant_outlined,
            title: 'Mesas',
            subtitle: 'Ventas y cuentas abiertas por mesa',
            value: settings.enableTableSales,
            enabled: !_savingModule,
            onChanged: (value) {
              _updateModule(() => settings.setTableSalesEnabled(value));
            },
          ),

          const Divider(height: 1),

          _ModuleSwitchTile(
            icon: Icons.local_bar_outlined,
            title: 'Barra',
            subtitle: 'Cuentas abiertas para clientes en barra',
            value: settings.enableBarSales,
            enabled: !_savingModule,
            onChanged: (value) {
              _updateModule(() => settings.setBarSalesEnabled(value));
            },
          ),

          const Divider(height: 1),

          _ModuleSwitchTile(
            icon: Icons.point_of_sale_outlined,
            title: 'Venta rápida',
            subtitle: 'Ventas cobradas inmediatamente',
            value: settings.enableQuickSale,
            enabled: !_savingModule,
            onChanged: (value) {
              _updateModule(() => settings.setQuickSaleEnabled(value));
            },
          ),

          const Divider(height: 1),

          _ModuleSwitchTile(
            icon: Icons.shopping_bag_outlined,
            title: 'Para llevar',
            subtitle: 'Pedidos para recoger o llevar',
            value: settings.enableTakeaway,
            enabled: !_savingModule,
            onChanged: (value) {
              _updateModule(() => settings.setTakeawayEnabled(value));
            },
          ),

          const Divider(height: 1),

          _ModuleSwitchTile(
            icon: Icons.delivery_dining_outlined,
            title: 'Delivery',
            subtitle: 'Pedidos con entrega a domicilio',
            value: settings.enableDelivery,
            enabled: !_savingModule,
            onChanged: (value) {
              _updateModule(() => settings.setDeliveryEnabled(value));
            },
          ),
        ],
      ),
    );
  }

  Future<void> _updateModule(Future<void> Function() update) async {
    if (_savingModule) {
      return;
    }

    setState(() {
      _savingModule = true;
    });

    try {
      await update();
    } catch (_) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudo guardar la configuración del módulo.'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _savingModule = false;
        });
      }
    }
  }

  Widget _buildProductManagementCard() {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const ProductManagementScreen()),
          );

          if (!mounted) {
            return;
          }

          setState(() {});
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: const Row(
            children: [
              Icon(
                Icons.inventory_2_outlined,
                color: AppColors.goldLight,
                size: 34,
              ),

              SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Administrar productos',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 5),

                    Text(
                      'Productos, precios, inventario y categorías',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              Icon(Icons.chevron_right, color: AppColors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPrinterCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.print_outlined,
            color: AppColors.goldLight,
            size: 34,
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Impresora térmica',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  _hasSelectedPrinter
                      ? _selectedPrinterName!
                      : 'No configurada',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),

                if (_hasSelectedPrinter &&
                    _selectedPrinterMacAddress != null) ...[
                  const SizedBox(height: 3),

                  Text(
                    _selectedPrinterMacAddress!,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ],
            ),
          ),

          Icon(
            _hasSelectedPrinter
                ? Icons.check_circle
                : Icons.radio_button_unchecked,
            color: _hasSelectedPrinter
                ? AppColors.goldLight
                : AppColors.textSecondary,
          ),
        ],
      ),
    );
  }

  Widget _buildPaperSizeCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: RadioGroup<PrinterPaperSize>(
        groupValue: _paperSize,
        onChanged: (value) {
          if (value == null) {
            return;
          }

          Services.printer.setPaperSize(value);

          setState(() {});
        },
        child: const Column(
          children: [
            RadioListTile<PrinterPaperSize>(
              value: PrinterPaperSize.mm58,
              activeColor: AppColors.goldLight,
              title: Text(
                '58 mm',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                'Ticket compacto',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),

            Divider(height: 1),

            RadioListTile<PrinterPaperSize>(
              value: PrinterPaperSize.mm80,
              activeColor: AppColors.goldLight,
              title: Text(
                '80 mm',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                'Recomendado para facturas completas',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _searchPrinters() async {
    if (_searchingPrinters) {
      return;
    }

    setState(() {
      _searchingPrinters = true;
    });

    try {
      final bluetoothEnabled = await PrintBluetoothThermal.bluetoothEnabled;

      if (!mounted) {
        return;
      }

      if (!bluetoothEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Bluetooth está apagado. '
              'Actívalo e inténtalo nuevamente.',
            ),
          ),
        );

        return;
      }

      final List<BluetoothInfo> devices =
          await PrintBluetoothThermal.pairedBluetooths;

      if (!mounted) {
        return;
      }

      if (devices.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No hay dispositivos Bluetooth emparejados.'),
          ),
        );

        return;
      }

      await showModalBottomSheet<void>(
        context: context,
        builder: (bottomSheetContext) {
          return SafeArea(
            child: ListView(
              shrinkWrap: true,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'DISPOSITIVOS BLUETOOTH',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),

                const Divider(height: 1),

                for (final device in devices)
                  ListTile(
                    leading: const Icon(Icons.print_outlined),
                    title: Text(
                      device.name.isEmpty
                          ? 'Dispositivo Bluetooth'
                          : device.name,
                    ),
                    subtitle: Text(device.macAdress),
                    trailing: _selectedPrinterMacAddress == device.macAdress
                        ? const Icon(
                            Icons.check_circle,
                            color: AppColors.goldLight,
                          )
                        : null,
                    onTap: () {
                      Services.printer.selectPrinter(
                        name: device.name.isEmpty
                            ? device.macAdress
                            : device.name,
                        macAddress: device.macAdress,
                      );

                      setState(() {});

                      Navigator.of(bottomSheetContext).pop();
                    },
                  ),
              ],
            ),
          );
        },
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'No se pudieron obtener los '
            'dispositivos Bluetooth: $error',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _searchingPrinters = false;
        });
      }
    }
  }

  Future<void> _printTest() async {
    if (_printingTest || !_hasSelectedPrinter) {
      return;
    }

    setState(() {
      _printingTest = true;
    });

    final printed = await Services.printer.printTest();

    if (!mounted) {
      return;
    }

    setState(() {
      _printingTest = false;
    });

    if (printed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Prueba enviada correctamente a la impresora.'),
        ),
      );

      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'No se pudo conectar o imprimir. '
          'Verifica que la impresora esté encendida '
          'y emparejada.',
        ),
      ),
    );
  }

  Future<void> _clearPrinter() async {
    await Services.printer.disconnect();

    Services.printer.clearPrinter();

    if (!mounted) {
      return;
    }

    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Impresora eliminada de la configuración.')),
    );
  }
}

class _ModuleSwitchTile extends StatelessWidget {
  const _ModuleSwitchTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.enabled,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final bool enabled;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      value: value,
      onChanged: enabled ? onChanged : null,
      activeThumbColor: AppColors.goldLight,
      secondary: Icon(
        icon,
        color: value ? AppColors.goldLight : AppColors.textSecondary,
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
      ),
    );
  }
}

class _SettingsSectionTitle extends StatelessWidget {
  const _SettingsSectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: AppColors.textSecondary,
        fontSize: 13,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
