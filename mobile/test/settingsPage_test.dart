import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'mockingForPageTests.dart';

import 'package:mobile/pages/MainPage.dart';

void main() {
  mockingServicesSetup();
  mockFunctionsSetup();

  //Test Initializations
  //setUp((){}); Called before every test
  //tearDown((){}); Called after every test

  testWidgets(
      'Check for correct widget functionality for main screen navigation to other screens',
      (WidgetTester tester) async {
    //Build a MaterialApp with the LoginPage.
    final mockObserver = MockNavigatorObserver();
    await tester.pumpWidget(MaterialApp(
      home: MainPage(),
      navigatorObservers: [mockObserver],
    ));

    //Click menu button and verify settings button is now visible
    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle();
    expect(find.text('Settings'), findsOneWidget);

    //Navigate to settings
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();

    /// Verify that a push event happened
    verify(mockObserver.didPush(any, any));

    //Check for 'Settings' title
    expect(find.text('Settings'), findsOneWidget);

    //Check for text
    expect(find.text('Change profile picture:'), findsOneWidget);

  });
}
