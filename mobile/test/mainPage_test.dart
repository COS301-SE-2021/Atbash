import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'mockingForPageTests.dart';

import 'package:mobile/pages/LoginPage.dart';
import 'package:mobile/pages/MainPage.dart';

void main() {
  mockingServicesSetup();
  mockFunctionsSetup();

  //Test Initializations
  //setUp((){}); Called before every test
  //tearDown((){}); Called after every test

  testWidgets(
      'Check for correct widget functionality for Logging in and Logging out',
      (WidgetTester tester) async {
    //Build a MaterialApp with the LoginPage.
    final mockObserver = MockNavigatorObserver();
    await tester.pumpWidget(MaterialApp(
      home: LoginPage(),
      navigatorObservers: [mockObserver],
    ));

    await tester.tap(find.text('LOGIN'));
    await tester.pumpAndSettle();

    /// Verify that a push event happened
    verify(mockObserver.didPush(any, any));

    //Verify menu button exist and menu buttons aren't visible
    expect(find.byIcon(Icons.more_vert), findsOneWidget);
    expect(find.text('Logout'), findsNothing);
    expect(find.text('Settings'), findsNothing);

    //Click button and verify menu buttons are now visible
    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle();
    expect(find.text('Logout'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);

    //Click logout button and check push occurs
    await tester.tap(find.text('Logout'));
    await tester.pumpAndSettle();
    verify(mockObserver.didPush(any, any));
  });

  testWidgets('Check for correct widget functionality for main screen display',
      (WidgetTester tester) async {
    //Build a MaterialApp with the LoginPage.
    final mockObserver = MockNavigatorObserver();
    await tester.pumpWidget(MaterialApp(
      home: LoginPage(),
      navigatorObservers: [mockObserver],
    ));

    await tester.tap(find.text('LOGIN'));
    await tester.pumpAndSettle();

    /// Verify that a push event happened
    verify(mockObserver.didPush(any, any));

    //Verify display name
    expect(find.text(loggedInUserContact.displayName), findsOneWidget);

    //Verify chats
    expect(find.text(cList[0].displayName), findsOneWidget);
    expect(find.text(cList[1].displayName), findsOneWidget);
  });

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

    //Navigate back
    await tester.pageBack();
    await tester.pumpAndSettle();

    //Verify chat
    expect(find.text(cList[0].displayName), findsOneWidget);

    //Navigate to chat
    await tester.tap(find.text(cList[0].displayName));
    await tester.pumpAndSettle();

    /// Verify that a push event happened
    verify(mockObserver.didPush(any, any));

    //Navigate back
    await tester.pageBack();
    await tester.pumpAndSettle();

    //Navigate to new chat
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    /// Verify that a push event happened
    verify(mockObserver.didPush(any, any));
  });
}
