class TableNames {
  TableNames._();

  static const Map<int, String> names = {
    1: 'Terraza',
    2: 'Terraza',
    3: 'VIP',
    4: 'VIP',
    5: 'Barra',
  };

  static String getName(int tableNumber) {
    return names[tableNumber] ?? 'Mesa';
  }
}
