import 'package:flutter/material.dart';

import '../../core/app_colors.dart';

class MainNavigation extends StatelessWidget {
  const MainNavigation({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  @override
  Widget build(BuildContext context) {
    const items = ['Mesas', 'Factura', 'Historial', 'Ajustes'];

    return Container(
      height: 50,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.border),
          bottom: BorderSide(color: AppColors.border),
        ),
      ),
      child: Row(
        children: List.generate(items.length, (index) {
          final isSelected = selectedIndex == index;

          return Expanded(
            child: InkWell(
              onTap: () => onItemSelected(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.gold : Colors.transparent,
                ),
                child: Text(
                  items[index],
                  style: TextStyle(
                    color: isSelected ? Colors.black : AppColors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
