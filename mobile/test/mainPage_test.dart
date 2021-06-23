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
  Future<bool> login(
      String? number, String? password) =>
      super.noSuchMethod(
          Invocation.method(#login, [number, password]),
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
          Invocation.method(#didPop, [route, previousRoute]));
}


void main() {
  final MockUserService mockUserService = MockUserService();
  GetIt.I.registerSingleton<UserService>(mockUserService);

  //Mock functions
  when(mockUserService.register(any, any, any))
      .thenAnswer((_) => Future<bool>.value(true));

  //Test Initializations
  //setUp((){}); Called before every test
  //tearDown((){}); Called after every test

  testWidgets('Check for correct widget functionality for Logining in and Loging out',
          (WidgetTester tester) async {
        //Build a MaterialApp with the LoginPage.
        final mockObserver = MockNavigatorObserver();
        await tester.pumpWidget(MaterialApp(
          // home: RegistrationPage(),
          home: LoginPage(),
          navigatorObservers: [mockObserver],
        ));
        await tester.tap(find.text('LOGIN'));
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