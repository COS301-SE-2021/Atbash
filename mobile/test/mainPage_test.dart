import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/domain/Contact.dart';
import 'package:mobile/domain/User.dart';
import 'package:mobile/pages/LoginPage.dart';
import 'package:mobile/pages/MainPage.dart';
import 'package:mobile/pages/RegistrationPage.dart';
import 'package:mobile/services/UserService.dart';
import 'package:mockito/mockito.dart';
import 'firebaseMessagingMock.dart';
import 'package:firebase_messaging_platform_interface/firebase_messaging_platform_interface.dart';

class MockUserService extends Mock implements UserService {
  @override
  Future<bool> login(String? number, String? password) =>
      super.noSuchMethod(Invocation.method(#login, [number, password]),
          returnValue: Future<bool>.value(true));

  @override
  Future<UnmodifiableListView<Contact>> getContactsWithChats() =>
      super.noSuchMethod(Invocation.method(#getContactsWithChats, null),
          returnValue: Future<UnmodifiableListView<Contact>>.value(
              UnmodifiableListView([
            Contact("123", "name1", true),
            Contact("1234", "name2", true)
          ])));
}

class MockNavigatorObserver extends Mock implements NavigatorObserver {
  @override
  void didPop(Route<dynamic>? route, Route<dynamic>? previousRoute) =>
      super.noSuchMethod(Invocation.method(#didPop, [route, previousRoute]));

  @override
  void didPush(Route<dynamic>? route, Route<dynamic>? previousRoute) =>
      super.noSuchMethod(Invocation.method(#didPush, [route, previousRoute]));
}

void main() {
  final MockUserService mockUserService = MockUserService();
  GetIt.I.registerSingleton<UserService>(mockUserService);

  //Mock functions
  when(mockUserService.login(any, any))
      .thenAnswer((_) => Future<bool>.value(true));
  final List<Contact> cList = [
    Contact("123", "name1", true),
    Contact("1234", "name2", true)
  ];
  final UnmodifiableListView<Contact> uList = UnmodifiableListView(cList);
  when(mockUserService.getContactsWithChats())
      .thenAnswer((_) => Future<UnmodifiableListView<Contact>>.value(uList));

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
    mockUserService.setLoggedInUser(User("number", "name", "status", ""));
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

  testWidgets(
      'Check for correct widget functionality for main screen display',
      (WidgetTester tester) async {
    //Build a MaterialApp with the LoginPage.
    final mockObserver = MockNavigatorObserver();
    await tester.pumpWidget(MaterialApp(
      home: LoginPage(),
      navigatorObservers: [mockObserver],
    ));
    final contact = User("number", "test_name", "status", "");
    mockUserService.setLoggedInUser(contact);
    await tester.tap(find.text('LOGIN'));
    await tester.pumpAndSettle();

    /// Verify that a push event happened
    verify(mockObserver.didPush(any, any));

    //Verify display name
    expect(find.text(contact.displayName), findsOneWidget);

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
        final contact = User("number", "test_name", "status", "");
        mockUserService.setLoggedInUser(contact);

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
        tester.pageBack();

        //Verify chats
        expect(find.text(cList[0].displayName), findsOneWidget);
        expect(find.text(cList[1].displayName), findsOneWidget);
      });
}
