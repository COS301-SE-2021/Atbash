import 'dart:async';
import 'dart:collection';

import 'package:mobile/services/MessageService.dart';
import 'package:uuid/uuid.dart';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/domain/Contact.dart';
import 'package:mobile/domain/Message.dart';
import 'package:mobile/domain/User.dart';
import 'package:mobile/pages/LoginPage.dart';
import 'package:mobile/pages/MainPage.dart';
import 'package:mobile/services/DatabaseAccess.dart';
import 'package:mobile/services/UserService.dart';
import 'package:mockito/mockito.dart';

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

  @override
  Future<UnmodifiableListView<Contact>> getContacts() =>
      super.noSuchMethod(Invocation.method(#getContacts, null),
          returnValue: Future<UnmodifiableListView<Contact>>.value(
              UnmodifiableListView([])));
}

class MockMessageService extends Mock implements MessageService {
  @override
  Future<List<Message>> fetchUnreadMessages(String? phoneNumber) =>
      super.noSuchMethod(Invocation.method(#fetchUnreadMessages, [phoneNumber]),
          returnValue: Future<List<Message>>.value([
          ]));
}

class MockDatabaseAccess extends Mock implements DatabaseAccess {
  @override
  Future<List<Message>> getChatWithContact(String? phoneNumber) =>
      super.noSuchMethod(Invocation.method(#getChatWithContact, [phoneNumber]),
          returnValue: Future<List<Message>>.value([
            Message((new Uuid()).v4(), "1234", "5678", "Message1_Content",
                DateTime.now().millisecondsSinceEpoch - 6000),
            Message((new Uuid()).v4(), "5678", "1234", "Message2_Content",
                DateTime.now().millisecondsSinceEpoch - 5000),
            Message((new Uuid()).v4(), "1234", "5678", "Message3_Content",
                DateTime.now().millisecondsSinceEpoch - 4000),
            Message((new Uuid()).v4(), "5678", "1234", "Message4_Content",
                DateTime.now().millisecondsSinceEpoch - 2000),
          ]));
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
  final MockDatabaseAccess mockDatabaseAccess = MockDatabaseAccess();
  GetIt.I.registerSingleton<DatabaseAccess>(mockDatabaseAccess);
  final MockMessageService mockMessageService = MockMessageService();

  final loggedInUserContact = User("5678", "name", "status", "");

  //Mock functions
  when(mockUserService.login(any, any))
      .thenAnswer((_) async => Future<bool>.value(true));
  final List<Contact> cList = [
    Contact("123", "name1", true),
    Contact("1234", "name2", true)
  ];
  //final UnmodifiableListView<Contact> uList = UnmodifiableListView(cList);
  when(mockUserService.getContactsWithChats()).thenAnswer(
      (_) async => Future<UnmodifiableListView<Contact>>.value(UnmodifiableListView(cList)));
  when(mockUserService.getContacts()).thenAnswer(
          (_) async => Future<UnmodifiableListView<Contact>>.value(UnmodifiableListView(cList)));
  when(mockUserService.getUser()).thenAnswer(
          (_) => loggedInUserContact);
  when(mockDatabaseAccess.getChatWithContact(any))
      .thenAnswer((_) async => Future<List<Message>>.value([
            Message(
                (new Uuid()).v4(),
                cList[0].phoneNumber,
                loggedInUserContact.phoneNumber,
                "Message1_Content",
                DateTime.now().millisecondsSinceEpoch - 6000),
            Message(
                (new Uuid()).v4(),
                loggedInUserContact.phoneNumber,
                cList[0].phoneNumber,
                "Message2_Content",
                DateTime.now().millisecondsSinceEpoch - 5000),
            Message(
                (new Uuid()).v4(),
                cList[0].phoneNumber,
                loggedInUserContact.phoneNumber,
                "Message3_Content",
                DateTime.now().millisecondsSinceEpoch - 4000),
            Message(
                (new Uuid()).v4(),
                loggedInUserContact.phoneNumber,
                cList[0].phoneNumber,
                "Message4_Content",
                DateTime.now().millisecondsSinceEpoch - 2000),
          ]));

  when(mockMessageService.fetchUnreadMessages(any))
      .thenAnswer((_) async => Future<List<Message>>.value([]));

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
    mockUserService.setLoggedInUser(loggedInUserContact);
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
    mockUserService.setLoggedInUser(loggedInUserContact);
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
    mockUserService.setLoggedInUser(loggedInUserContact);

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
