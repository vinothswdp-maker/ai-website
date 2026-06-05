import 'package:flutter_test/flutter_test.dart';
import 'package:ai_website/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const PulseApp());
    expect(find.text('Plivo'), findsAny);
  });
}
