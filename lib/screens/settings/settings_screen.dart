import 'package:flutter/material.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

import '../../core/app_colors.dart';
import '../../services/printer_service.dart';
import '../../services/service_locator.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _searchingPrinters = false;
  bool _printingTest = false;

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
