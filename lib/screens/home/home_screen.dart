import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/business_config.dart';
import '../../models/app_permission.dart';
import '../../models/user_role.dart';
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
        _HomeNavigationItem(
          title: settings.tablePluralLabel,
          page: const TablesScreen(),
        ),
      );
    }

    if (settings.enableBarSales &&
        permissions.hasPermission(AppPermission.viewBar)) {
      items.add(
        _HomeNavigationItem(title: settings.barLabel, page: const BarScreen()),
      );
    }

    if (settings.enableQuickSale &&
        permissions.hasPermission(AppPermission.processSales)) {
      items.add(
        _HomeNavigationItem(
          title: settings.quickSaleLabel,
          page: const QuickSaleScreen(),
        ),
      );
    }

    if (settings.enableTakeaway &&
        permissions.hasPermission(AppPermission.processSales)) {
      items.add(
        _HomeNavigationItem(
          title: settings.takeawayLabel,
          page: const TakeawayScreen(),
        ),
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
        _HomeNavigationItem(
          title: 'Factura',
          page: _InvoicePlaceholder(
            tableSingularLabel: settings.tableSingularLabel,
            barLabel: settings.barLabel,
          ),
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
      return Scaffold(
        appBar: AppBar(
          titleSpacing: 4,
          title: const _BusinessTitle(),
          actions: [_buildUserMenu(), const SizedBox(width: 4)],
        ),
        body: const Center(
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
        titleSpacing: 4,
        title: const _BusinessTitle(),
        actions: [
          if (Services.permissions.hasPermission(AppPermission.managePrinter))
            IconButton(
              onPressed: () {
                debugPrint('Abrir configuración de impresora');
              },
              tooltip: 'Impresora',
              icon: const Icon(Icons.print_outlined),
            ),
          _buildUserMenu(),
          const SizedBox(width: 4),
        ],
      ),
      body: Column(
        children: [
          MainNavigation(
            key: ValueKey(
              '${Services.settings.tablePluralLabel}|'
              '${Services.settings.barLabel}|'
              '${Services.settings.quickSaleLabel}|'
              '${Services.settings.takeawayLabel}|'
              '${Services.settings.enableTableSales}|'
              '${Services.settings.enableBarSales}|'
              '${Services.settings.enableQuickSale}|'
              '${Services.settings.enableTakeaway}|'
              '${Services.settings.enableDelivery}',
            ),
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

  Widget _buildUserMenu() {
    final user = Services.auth.currentUser;

    if (user == null) {
      return const SizedBox.shrink();
    }

    return PopupMenuButton<_UserMenuAction>(
      tooltip: 'Usuario actual',
      onSelected: (action) {
        switch (action) {
          case _UserMenuAction.logout:
            _confirmLogout();
            break;
        }
      },
      itemBuilder: (context) {
        return [
          PopupMenuItem<_UserMenuAction>(
            enabled: false,
            child: SizedBox(
              width: 210,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.displayName,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '@${user.username}',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _roleName(user.role),
                    style: const TextStyle(
                      color: AppColors.goldLight,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const PopupMenuDivider(),
          const PopupMenuItem<_UserMenuAction>(
            value: _UserMenuAction.logout,
            child: Row(
              children: [
                Icon(Icons.logout),
                SizedBox(width: 10),
                Text('Cerrar sesión'),
              ],
            ),
          ),
        ];
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.account_circle_outlined, size: 22),
            const SizedBox(width: 5),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 90),
              child: Text(
                user.displayName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Icon(Icons.arrow_drop_down, size: 18),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmLogout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Cerrar sesión'),
          content: const Text('¿Deseas cerrar la sesión actual?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('CANCELAR'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text('CERRAR SESIÓN'),
            ),
          ],
        );
      },
    );

    if (shouldLogout != true) {
      return;
    }

    Services.auth.logout();
  }

  String _roleName(UserRole role) {
    switch (role) {
      case UserRole.administrator:
        return 'Administrador';

      case UserRole.cashier:
        return 'Cajero';

      case UserRole.waiter:
        return 'Mesero';
    }
  }
}

class _BusinessTitle extends StatelessWidget {
  const _BusinessTitle();

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          BusinessConfig.businessName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          'Vendra',
          maxLines: 1,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.normal,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

enum _UserMenuAction { logout }

class _HomeNavigationItem {
  const _HomeNavigationItem({required this.title, required this.page});

  final String title;
  final Widget page;
}

class _InvoicePlaceholder extends StatelessWidget {
  const _InvoicePlaceholder({
    required this.tableSingularLabel,
    required this.barLabel,
  });

  final String tableSingularLabel;
  final String barLabel;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.receipt_long_outlined, size: 54),
            const SizedBox(height: 14),
            Text(
              'Selecciona una cuenta de '
              '$tableSingularLabel '
              'o una cuenta de $barLabel '
              'para abrir la factura.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
