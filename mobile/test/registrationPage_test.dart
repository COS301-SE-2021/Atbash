import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/pages/LoginPage.dart';
import 'package:mobile/pages/RegistrationPage.dart';
import 'package:mobile/services/UserService.dart';
import 'package:mockito/mockito.dart';
import 'firebaseMock.dart';

class MockUserService extends Mock implements UserService {
  @override
  Future<bool> register(String number, String deviceToken, String password) {
    return Future.delayed(
      Duration(milliseconds: 50),
      () => true,
    );
  }
}

class MockFirebaseMessaging extends Mock implements FirebaseMessaging {
  @override
  Future<String?> getToken({String? vapidKey}) {
    return Future.delayed(
      Duration(milliseconds: 50),
      () => "12345",
    );
  }
}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  // TestWidgetsFlutterBinding.ensureInitialized(); Gets called in setupFirebaseAuthMocks()
  setupFirebaseAuthMocks(); //https://stackoverflow.com/questions/63662031/how-to-mock-the-firebaseapp-in-flutter
  Firebase.initializeApp();
  final MockUserService mockUserService = MockUserService();
  final MockFirebaseMessaging mockFirebaseMessaging = MockFirebaseMessaging();

  GetIt.I.registerSingleton<UserService>(MockUserService());
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

  //need to mock User Service https://pub.dev/packages/mockito
  testWidgets('Check for correct widget functionality on Registration Page',
      (WidgetTester tester) async {
    // Build a MaterialApp with the LoginPage.
    await tester.pumpWidget(MaterialApp(home: RegistrationPage()));

    // Build a MaterialApp with the LoginPage.
    final mockObserver = MockNavigatorObserver();
    await tester.pumpWidget(MaterialApp(
      home: RegistrationPage(),
      navigatorObservers: [mockObserver],
    ));

    //Verify clicking on REGISTER button results in page navigation
    expect(find.text('LOGIN'), findsNothing);
    await tester.enterText(find.byType(TextField).at(0), 'name');
    await tester.enterText(find.byType(TextField).at(1), 'name');
    await tester.enterText(find.byType(TextField).at(2), 'name');
    await tester.pumpAndSettle();
    await tester.tap(find.text('REGISTER'));
    await tester.pumpAndSettle();
    expect(find.text('REGISTER'), findsOneWidget);
    //expect(find.text('LOGIN'), findsOneWidget);
    /// Verify that a push event happened
    verify(mockObserver.didPop(any, any));
  });
}
