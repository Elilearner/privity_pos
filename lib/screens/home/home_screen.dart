import 'package:flutter/material.dart';

import '../../core/business_config.dart';
import '../../services/service_locator.dart';
import '../../widgets/navigation/main_navigation.dart';
import '../cash/cash_screen.dart';
import '../delivery/delivery_screen.dart';
import '../history/history_screen.dart';
import '../quick_sale/quick_sale_screen.dart';
import '../settings/settings_screen.dart';
import '../tables/tables_screen.dart';
import '../takeaway/takeaway_screen.dart';
import '../bar/bar_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    Services.settings.addListener(_handleSettingsChanged);
  }

  @override
  void dispose() {
    Services.settings.removeListener(_handleSettingsChanged);

    super.dispose();
  }

  void _handleSettingsChanged() {
    if (!mounted) {
      return;
    }

    setState(() {});
  }

  List<_HomeNavigationItem> get navigationItems {
    final items = <_HomeNavigationItem>[];

    final settings = Services.settings;

    if (settings.enableTableSales) {
      items.add(
        const _HomeNavigationItem(title: 'Mesas', page: TablesScreen()),
      );
    }
    if (settings.enableBarSales) {
      items.add(const _HomeNavigationItem(title: 'Barra', page: BarScreen()));
    }

    if (settings.enableQuickSale) {
      items.add(
        const _HomeNavigationItem(
          title: 'Venta rápida',
          page: QuickSaleScreen(),
        ),
      );
    }

    if (settings.enableTakeaway) {
      items.add(
        const _HomeNavigationItem(title: 'Para llevar', page: TakeawayScreen()),
      );
    }

    if (settings.enableDelivery) {
      items.add(
        const _HomeNavigationItem(title: 'Delivery', page: DeliveryScreen()),
      );
    }

    items.add(
      const _HomeNavigationItem(title: 'Factura', page: _InvoicePlaceholder()),
    );

    items.add(
      const _HomeNavigationItem(title: 'Historial', page: HistoryScreen()),
    );

    items.add(const _HomeNavigationItem(title: 'Caja', page: CashScreen()));

    items.add(
      const _HomeNavigationItem(title: 'Ajustes', page: SettingsScreen()),
    );

    return items;
  }

  @override
  Widget build(BuildContext context) {
    final items = navigationItems;

    if (selectedIndex >= items.length) {
      selectedIndex = 0;
    }

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
            items: items.map((item) => item.title).toList(),
            selectedIndex: selectedIndex,
            onItemSelected: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
          ),
          Expanded(
            child: IndexedStack(
              index: selectedIndex,
              children: items.map((item) => item.page).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeNavigationItem {
  const _HomeNavigationItem({required this.title, required this.page});

  final String title;
  final Widget page;
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
              'Selecciona una mesa '
              'y una cuenta para '
              'abrir la factura.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
