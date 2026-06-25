import 'package:flutter_test/flutter_test.dart';
import 'package:flirtmate/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const FlirtMateApp());

    // Verify that the splash screen shows the app name.
    expect(find.text('FlirtMate'), findsOneWidget);
  });
}
