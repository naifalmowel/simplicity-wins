import 'package:flutter_test/flutter_test.dart';
import 'package:simplicty_wins/main.dart';

void main() {
  testWidgets('Simplicity Wins app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const SimplicityApp());
    expect(find.text('Simplicity Wins'), findsWidgets);
  });
}
