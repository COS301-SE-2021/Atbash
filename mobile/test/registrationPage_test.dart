import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/pages/LoginPage.dart';
import 'package:mobile/pages/RegistrationPage.dart';
import 'package:mobile/services/UserService.dart';
import 'package:mockito/mockito.dart';
import 'firebaseMessagingMock.dart';
import 'package:firebase_messaging_platform_interface/firebase_messaging_platform_interface.dart';

class MockUserService extends Mock implements UserService {
  @override
  Future<bool> register(
          String? number, String? deviceToken, String? password) =>
      super.noSuchMethod(
          Invocation.method(#register, [number, deviceToken, password]),
          returnValue: Future<bool>.value(true));
}

class MockNavigatorObserver extends Mock implements NavigatorObserver {
  @override
  void didPop(Route<dynamic>? route, Route<dynamic>? previousRoute) =>
      super.noSuchMethod(
          Invocation.method(#didPop, [route, previousRoute]));

  @override
  void didPush(Route<dynamic>? route, Route<dynamic>? previousRoute) =>
      super.noSuchMethod(
          Invocation.method(#didPush, [route, previousRoute]));
}


void main() {
  setupFirebaseMessagingMocks();
  final MockUserService mockUserService = MockUserService();
  //final MockFirebaseMessaging mockFirebaseMessaging = MockFirebaseMessaging();

  GetIt.I.registerSingleton<UserService>(mockUserService);
  when(kMockMessagingPlatform.getToken())
      .thenAnswer((_) async => Future<String>.value("12345"));
  when(mockUserService.register(any, any, any))
      .thenAnswer((_) async => Future<bool>.value(true));
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
