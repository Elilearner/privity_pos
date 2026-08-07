import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../models/sale.dart';
import '../../services/service_locator.dart';
import '../../widgets/history/sale_history_card.dart';
import '../../widgets/history/today_sales_summary.dart';
import 'sale_detail_screen.dart';

enum _HistoryFilter { today, all }

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  _HistoryFilter selectedFilter = _HistoryFilter.today;

  final TextEditingController _searchController = TextEditingController();

  String searchText = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allSales = Services.sales.sales.reversed.toList();

    final filteredSales = _applyFilters(allSales);

    return Scaffold(
      appBar: AppBar(title: const Text('Historial de ventas')),
      body: allSales.isEmpty
          ? _buildEmptyHistory()
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 14, 14, 8),
                  child: Column(
                    children: [
                      TodaySalesSummary(sales: allSales),
                      const SizedBox(height: 12),
                      _buildFilterSelector(),
                      const SizedBox(height: 12),
                      _buildSearchField(),
                    ],
                  ),
                ),
                Expanded(
                  child: filteredSales.isEmpty
                      ? _buildNoResults()
                      : _buildSalesList(filteredSales),
                ),
              ],
            ),
    );
  }

  List<Sale> _applyFilters(List<Sale> sales) {
    var result = sales;

    if (selectedFilter == _HistoryFilter.today) {
      final now = DateTime.now();

      result = result.where((sale) {
        final date = sale.createdAt;

        return date.year == now.year &&
            date.month == now.month &&
            date.day == now.day;
      }).toList();
    }

    final query = searchText.trim().toLowerCase();

    if (query.isEmpty) {
      return result;
    }

    return result.where((sale) {
      final saleNumber = sale.id.toString().toLowerCase();

      final customer = sale.customerName?.toLowerCase() ?? '';

      final tableNumber = sale.tableNumber?.toString() ?? '';

      final tableText = sale.tableNumber != null
          ? 'mesa ${sale.tableNumber}'.toLowerCase()
          : '';

      return saleNumber.contains(query) ||
          customer.contains(query) ||
          tableNumber.contains(query) ||
          tableText.contains(query);
    }).toList();
  }

  Widget _buildFilterSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: _HistoryFilterButton(
              title: 'HOY',
              selected: selectedFilter == _HistoryFilter.today,
              onTap: () {
                setState(() {
                  selectedFilter = _HistoryFilter.today;
                });
              },
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: _HistoryFilterButton(
              title: 'TODAS',
              selected: selectedFilter == _HistoryFilter.all,
              onTap: () {
                setState(() {
                  selectedFilter = _HistoryFilter.all;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Buscar venta, cliente o mesa...',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: searchText.isEmpty
            ? null
            : IconButton(
                onPressed: () {
                  _searchController.clear();

                  setState(() {
                    searchText = '';
                  });
                },
                icon: const Icon(Icons.close),
              ),
      ),
      onChanged: (value) {
        setState(() {
          searchText = value;
        });
      },
    );
  }

  Widget _buildEmptyHistory() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 64,
              color: AppColors.textSecondary,
            ),
            SizedBox(height: 16),
            Text(
              'No hay ventas registradas',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Las ventas completadas aparecerán aquí.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoResults() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 52, color: AppColors.textSecondary),
            SizedBox(height: 12),
            Text(
              'No se encontraron ventas.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSalesList(List<Sale> sales) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(14, 6, 14, 14),
      itemCount: sales.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final sale = sales[index];

        return SaleHistoryCard(
          sale: sale,
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => SaleDetailScreen(sale: sale)),
            );

            if (!context.mounted) {
              return;
            }

            setState(() {});
          },
        );
      },
    );
  }
}

class _HistoryFilterButton extends StatelessWidget {
  const _HistoryFilterButton({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected
          ? AppColors.goldLight.withValues(alpha: 0.14)
          : Colors.transparent,
      borderRadius: BorderRadius.circular(9),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(9),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 11),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: selected ? AppColors.goldLight : AppColors.textSecondary,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}
