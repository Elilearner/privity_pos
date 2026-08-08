class CashSession {
  CashSession({
    required this.id,
    required this.openedAt,
    required this.openingAmount,
    this.closedAt,
    this.closingAmount,
    this.isOpen = true,
  });

  final int id;

  final DateTime openedAt;
  DateTime? closedAt;

  final double openingAmount;

  double? closingAmount;

  bool isOpen;

  double get difference {
    if (closingAmount == null) {
      return 0;
    }

    return closingAmount! - openingAmount;
  }

  void close({required double amount}) {
    closingAmount = amount;
    closedAt = DateTime.now();
    isOpen = false;
  }
}
