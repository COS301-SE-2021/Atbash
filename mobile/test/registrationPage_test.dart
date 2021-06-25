import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_messaging_platform_interface/firebase_messaging_platform_interface.dart';

import 'firebaseMessagingMock.dart';
import 'mockingForPageTests.dart';

import 'package:mobile/pages/LoginPage.dart';
import 'package:mobile/pages/RegistrationPage.dart';

void main() {
  mockingServicesSetup();
  mockFunctionsSetup();
  setupFirebaseMessagingMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
    FirebaseMessagingPlatform.instance = kMockMessagingPlatform;
  });
  //setUp((){}); Called before every test
  //tearDown((){}); Called after every test

  testWidgets('Check for existence of correct widgets on Registration Page',
      (WidgetTester tester) async {
    // Build a MaterialApp with the LoginPage.
    await tester.pumpWidget(MaterialApp(home: RegistrationPage()));

    //Verify register button exists
    expect(find.text('REGISTER'), findsOneWidget);

    //Verify both textfields exist
    expect(find.byType(TextField), findsNWidgets(3));
  });

  testWidgets('Check for correct widget functionality on Registration Page',
      (WidgetTester tester) async {
    //Build a MaterialApp with the LoginPage.
    final mockObserver = MockNavigatorObserver();
    //NavigatorObserver mockObserver = MockNavigatorObserver();
    await tester.pumpWidget(MaterialApp(
      // home: RegistrationPage(),
      home: LoginPage(),
      navigatorObservers: [mockObserver],
    ));
    await tester.tap(find.text('REGISTER'));
    await tester.pumpAndSettle();

    /// Verify that a push event happened
    verify(mockObserver.didPush(any, any));

    //Verify clicking on REGISTER button results in page navigation
    expect(find.text('LOGIN'), findsNothing);
    await tester.enterText(find.byType(TextField).at(0), 'name');
    await tester.enterText(find.byType(TextField).at(1), 'name');
    await tester.enterText(find.byType(TextField).at(2), 'name');
    await tester.pumpAndSettle();
    await tester.tap(find.text('REGISTER'));
    await tester.pumpAndSettle();
    expect(find.text('REGISTER'), findsOneWidget);

    /// Verify that a pop event happened
    verify(mockObserver.didPop(any, any));
  });
}
