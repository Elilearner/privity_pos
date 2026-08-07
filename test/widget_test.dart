import 'package:flutter_test/flutter_test.dart';
import 'package:privity_pos/app/app.dart';

void main() {
  testWidgets('PRIVITY DRINK app loads', (WidgetTester tester) async {
    await tester.pumpWidget(const PrivityDrinkApp());

    await tester.pumpAndSettle();

    expect(find.text('PRIVITY DRINK'), findsOneWidget);
  });
}
