import 'package:flutter/material.dart';

import '../../core/business_config.dart';
import '../../widgets/navigation/main_navigation.dart';
import '../history/history_screen.dart';
import '../settings/settings_screen.dart';
import '../tables/tables_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  final List<Widget> pages = const [
    TablesScreen(),
    _InvoicePlaceholder(),
    HistoryScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            debugPrint('Abrir menú');
          },
          icon: const Icon(Icons.menu),
        ),
        title: const Text(
          BusinessConfig.businessName,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              debugPrint('Abrir configuración de impresora');
            },
            icon: const Icon(Icons.print_outlined),
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: Column(
        children: [
          MainNavigation(
            selectedIndex: selectedIndex,
            onItemSelected: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
          ),
          Expanded(
            child: IndexedStack(index: selectedIndex, children: pages),
          ),
        ],
      ),
    );
  }
}

class _InvoicePlaceholder extends StatelessWidget {
  const _InvoicePlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.receipt_long_outlined, size: 54),
            SizedBox(height: 14),
            Text(
              'Selecciona una mesa y una cuenta '
              'para abrir la factura.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
