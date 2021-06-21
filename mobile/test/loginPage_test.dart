import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/pages/LoginPage.dart';

void main() {
  // Define a test. The TestWidgets function also provides a WidgetTester
  // to work with. The WidgetTester allows you to build and interact
  // with widgets in the test environment.
  testWidgets('Check for existence of correct widgets on Login Page', (WidgetTester tester) async {
    // Build a MaterialApp with the LoginPage.
    await tester.pumpWidget(MaterialApp(home: LoginPage()));

    // Verify that our counter starts at 0.
    expect(find.text('garbageValue'), findsNothing);

    //Verify login and register buttons exist
    expect(find.text('LOGIN'), findsOneWidget);
    expect(find.text('REGISTER'), findsOneWidget);

    //Verify both textfields exist
    expect(find.byType(TextField), findsNWidgets(2));

    //Verify clicking on REGISTER button results in page navigation
    await tester.tap(find.text('REGISTER'));
    await tester.pumpAndSettle();
    expect(find.text('REGISTER'), findsOneWidget);
    expect(find.text('LOGIN'), findsNothing);
  });

  testWidgets('Check for correct widget functionality on Login Page', (WidgetTester tester) async {
    // Build a MaterialApp with the LoginPage.
    await tester.pumpWidget(MaterialApp(home: LoginPage()));

    //Verify clicking on REGISTER button results in page navigation
    await tester.tap(find.text('REGISTER'));
    await tester.pumpAndSettle();
    expect(find.text('REGISTER'), findsOneWidget);
    expect(find.text('LOGIN'), findsNothing);
  });
}