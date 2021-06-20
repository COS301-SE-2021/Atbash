import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/main.dart';

void main() {
  // Define a test. The TestWidgets function also provides a WidgetTester
  // to work with. The WidgetTester allows you to build and interact
  // with widgets in the test environment.
  testWidgets('Widget tests', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(AtbashApp());

    // Verify that our counter starts at 0.
    expect(find.text('garbageValue'), findsNothing);

    // await tester.tap(find.byIcon(Icons.send));
    // await tester.pump();
  });
}
