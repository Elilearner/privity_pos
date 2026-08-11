import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/table_names.dart';
import '../../services/service_locator.dart';
import '../../widgets/tables/table_card.dart';
import '../accounts/accounts_screen.dart';

class TablesScreen extends StatefulWidget {
  const TablesScreen({super.key});

  @override
  State<TablesScreen> createState() => _TablesScreenState();
}

class _TablesScreenState extends State<TablesScreen> {
  @override
  void initState() {
    super.initState();

    Services.tables.addListener(_onTablesChanged);
  }

  @override
  void dispose() {
    Services.tables.removeListener(_onTablesChanged);

    super.dispose();
  }

  void _onTablesChanged() {
    if (!mounted) {
      return;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final tables = Services.tables.tables;

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          const _TablesHeader(),
          const SizedBox(height: 12),
          Expanded(
            child: GridView.builder(
              itemCount: tables.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.80,
              ),
              itemBuilder: (context, index) {
                final table = tables[index];

                final firstAccount = table.firstAccount;

                return TableCard(
                  tableNumber: table.number,
                  zoneName: table.name ?? TableNames.getName(table.number),
                  zoneColor: _zoneColorForTable(table.number),
                  isOccupied: table.isOccupied,
                  accountCount: table.totalAccounts,
                  total: table.total,
                  customerName: firstAccount?.customerName,
                  openingTime: firstAccount == null
                      ? null
                      : _formatTime(firstAccount.openedAt),
                  productCount: table.totalItems,
                  onTap: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => AccountsScreen(
                          tableNumber: table.number,
                          zoneName:
                              table.name ?? TableNames.getName(table.number),
                        ),
                      ),
                    );

                    if (!mounted) {
                      return;
                    }

                    setState(() {});
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Color _zoneColorForTable(int tableNumber) {
    if (tableNumber <= 5) {
      return const Color(0xFF58B368);
    }

    if (tableNumber <= 10) {
      return const Color(0xFF4A90E2);
    }

    if (tableNumber <= 15) {
      return const Color(0xFF9B59B6);
    }

    return const Color(0xFFF39C4A);
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;

    final minute = dateTime.minute.toString().padLeft(2, '0');

    final period = dateTime.hour >= 12 ? 'PM' : 'AM';

    return '$hour:$minute $period';
  }
}

class _TablesHeader extends StatelessWidget {
  const _TablesHeader();

  @override
  Widget build(BuildContext context) {
    final tableService = Services.tables;

    return Row(
      children: [
        const Expanded(
          child: Text(
            'MESAS',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border),
          ),
          child: Text(
            '${tableService.totalTables} mesas',
            style: const TextStyle(
              color: AppColors.goldLight,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
