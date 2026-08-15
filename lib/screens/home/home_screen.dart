import 'package:flutter/material.dart';

import '../../core/business_config.dart';
import '../../models/app_permission.dart';
import '../../services/service_locator.dart';
import '../../widgets/navigation/main_navigation.dart';
import '../bar/bar_screen.dart';
import '../cash/cash_screen.dart';
import '../delivery/delivery_screen.dart';
import '../history/history_screen.dart';
import '../quick_sale/quick_sale_screen.dart';
import '../settings/settings_screen.dart';
import '../tables/tables_screen.dart';
import '../takeaway/takeaway_screen.dart';

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

    Services.settings.addListener(_handleStateChanged);
    Services.auth.addListener(_handleStateChanged);
  }

  @override
  void dispose() {
    Services.settings.removeListener(_handleStateChanged);
    Services.auth.removeListener(_handleStateChanged);

    super.dispose();
  }

  void _handleStateChanged() {
    if (!mounted) {
      return;
    }

    setState(() {});
  }

  List<_HomeNavigationItem> get navigationItems {
    final items = <_HomeNavigationItem>[];

    final settings = Services.settings;
    final permissions = Services.permissions;

    if (settings.enableTableSales &&
        permissions.hasPermission(AppPermission.viewTables)) {
      items.add(
        const _HomeNavigationItem(title: 'Mesas', page: TablesScreen()),
      );
    }

    if (settings.enableBarSales &&
        permissions.hasPermission(AppPermission.viewBar)) {
      items.add(const _HomeNavigationItem(title: 'Barra', page: BarScreen()));
    }

    if (settings.enableQuickSale &&
        permissions.hasPermission(AppPermission.processSales)) {
      items.add(
        const _HomeNavigationItem(
          title: 'Venta rápida',
          page: QuickSaleScreen(),
        ),
      );
    }

    if (settings.enableTakeaway &&
        permissions.hasPermission(AppPermission.processSales)) {
      items.add(
        const _HomeNavigationItem(title: 'Para llevar', page: TakeawayScreen()),
      );
    }

    if (settings.enableDelivery &&
        permissions.hasPermission(AppPermission.processSales)) {
      items.add(
        const _HomeNavigationItem(title: 'Delivery', page: DeliveryScreen()),
      );
    }

    if (permissions.hasPermission(AppPermission.processSales)) {
      items.add(
        const _HomeNavigationItem(
          title: 'Factura',
          page: _InvoicePlaceholder(),
        ),
      );
    }

    if (permissions.canViewSalesHistory) {
      items.add(
        const _HomeNavigationItem(title: 'Historial', page: HistoryScreen()),
      );
    }

    if (permissions.canViewCash) {
      items.add(const _HomeNavigationItem(title: 'Caja', page: CashScreen()));
    }

    if (permissions.canViewSettings) {
      items.add(
        const _HomeNavigationItem(title: 'Ajustes', page: SettingsScreen()),
      );
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    final items = navigationItems;

    if (items.isEmpty) {
      return const Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'Este usuario no tiene módulos disponibles.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

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
          if (Services.permissions.hasPermission(AppPermission.managePrinter))
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
              'o una cuenta de Barra '
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
