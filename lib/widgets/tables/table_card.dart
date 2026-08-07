import 'package:flutter/material.dart';

import '../../core/app_colors.dart';

class TableCard extends StatelessWidget {
  const TableCard({
    super.key,
    required this.tableNumber,
    required this.zoneName,
    required this.zoneColor,
    required this.isOccupied,
    required this.accountCount,
    required this.total,
    required this.onTap,
    this.customerName,
    this.openingTime,
    this.productCount = 0,
  });

  final int tableNumber;
  final String zoneName;
  final Color zoneColor;
  final bool isOccupied;
  final int accountCount;
  final double total;
  final VoidCallback onTap;

  final String? customerName;
  final String? openingTime;
  final int productCount;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ZoneHeader(
                zoneName: zoneName,
                zoneColor: zoneColor,
                isOccupied: isOccupied,
              ),
              const SizedBox(height: 8),
              Text(
                'Mesa $tableNumber',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              _StatusLabel(isOccupied: isOccupied),
              const SizedBox(height: 8),
              if (!isOccupied)
                const Expanded(
                  child: Center(
                    child: Text(
                      'DISPONIBLE',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                )
              else ...[
                if (customerName != null)
                  Text(
                    customerName!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                if (openingTime != null) ...[
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(
                        Icons.schedule,
                        size: 15,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        openingTime!,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
                const Spacer(),
                Text(
                  '$accountCount cuenta${accountCount == 1 ? '' : 's'}',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '$productCount producto${productCount == 1 ? '' : 's'}',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _formatCurrency(total),
                  style: const TextStyle(
                    color: AppColors.goldLight,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  static String _formatCurrency(double amount) {
    final value = amount.round().toString();
    final buffer = StringBuffer();

    for (var index = 0; index < value.length; index++) {
      final positionFromEnd = value.length - index;

      buffer.write(value[index]);

      if (positionFromEnd > 1 && positionFromEnd % 3 == 1) {
        buffer.write(',');
      }
    }

    return 'RD\$ ${buffer.toString()}';
  }
}

class _ZoneHeader extends StatelessWidget {
  const _ZoneHeader({
    required this.zoneName,
    required this.zoneColor,
    required this.isOccupied,
  });

  final String zoneName;
  final Color zoneColor;
  final bool isOccupied;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: zoneColor, shape: BoxShape.circle),
        ),
        const SizedBox(width: 7),
        Expanded(
          child: Text(
            zoneName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: zoneColor,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
        Icon(
          isOccupied ? Icons.people_alt_outlined : Icons.event_seat_outlined,
          size: 18,
          color: isOccupied ? AppColors.gold : AppColors.textSecondary,
        ),
      ],
    );
  }
}

class _StatusLabel extends StatelessWidget {
  const _StatusLabel({required this.isOccupied});

  final bool isOccupied;

  @override
  Widget build(BuildContext context) {
    final statusColor = isOccupied ? AppColors.error : const Color(0xFF58B368);

    return Row(
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          isOccupied ? 'Ocupada' : 'Libre',
          style: TextStyle(
            color: statusColor,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
