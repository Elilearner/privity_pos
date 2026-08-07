class CurrencyFormatter {
  CurrencyFormatter._();

  static String format(num value) {
    final integer = value.round();

    final text = integer.toString();

    final buffer = StringBuffer();

    int counter = 0;

    for (int i = text.length - 1; i >= 0; i--) {
      buffer.write(text[i]);

      counter++;

      if (counter == 3 && i != 0) {
        buffer.write(',');
        counter = 0;
      }
    }

    return 'RD\$ ${buffer.toString().split('').reversed.join()}';
  }
}
