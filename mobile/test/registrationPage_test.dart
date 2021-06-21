import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/pages/LoginPage.dart';
import 'package:mobile/pages/RegistrationPage.dart';

void main() {

  testWidgets('Check for existence of correct widgets on Registration Page', (WidgetTester tester) async {
    // Build a MaterialApp with the LoginPage.
    await tester.pumpWidget(MaterialApp(home: RegistrationPage()));

    //Verify register button exists
    expect(find.text('REGISTER'), findsOneWidget);

    //Verify both textfields exist
    expect(find.byType(TextField), findsNWidgets(3));
  });

  //need to mock User Service https://pub.dev/packages/mockito
  // testWidgets('Check for correct widget functionality on Registration Page', (WidgetTester tester) async {
  //   // Build a MaterialApp with the LoginPage.
  //   await tester.pumpWidget(MaterialApp(home: RegistrationPage()));
  //
  //   //Verify clicking on REGISTER button results in page navigation
  //   expect(find.text('LOGIN'), findsNothing);
  //   await tester.enterText(find.byType(TextField).at(0), 'name');
  //   await tester.enterText(find.byType(TextField).at(1), 'name');
  //   await tester.enterText(find.byType(TextField).at(2), 'name');
  //   await tester.pumpAndSettle();
  //   await tester.tap(find.text('REGISTER'));
  //   await tester.pumpAndSettle();
  //   expect(find.text('REGISTER'), findsOneWidget);
  //   expect(find.text('LOGIN'), findsOneWidget);
  // });
}