import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/domain/Contact.dart';
import 'package:mobile/domain/Message.dart';
import 'package:mobile/domain/User.dart';
import 'package:mobile/services/DatabaseAccess.dart';
import 'package:mobile/services/UserService.dart';
import 'package:mockito/mockito.dart';

class MockUserService extends Mock implements UserService {
  @override
  Future<bool> login(String? number, String? password) =>
      super.noSuchMethod(Invocation.method(#login, [number, password]),
          returnValue: Future<bool>.value(true));

  @override
  Future<bool> register(
          String? number, String? deviceToken, String? password) =>
      super.noSuchMethod(
          Invocation.method(#register, [number, deviceToken, password]),
          returnValue: Future<bool>.value(true));
}

class MockDatabaseAccess extends Mock implements DatabaseAccess {
  @override
  Future<List<Message>> getChatWithContact(String? phoneNumber) =>
      super.noSuchMethod(Invocation.method(#getChatWithContact, [phoneNumber]),
          returnValue: Future<List<Message>>.value([
            Message("1234", "5678", "Message1_Content",
                DateTime.now().add(Duration(seconds: -6))),
            Message("5678", "1234", "Message2_Content",
                DateTime.now().add(Duration(seconds: -5))),
            Message("1234", "5678", "Message3_Content",
                DateTime.now().add(Duration(seconds: -4))),
            Message("5678", "1234", "Message4_Content",
                DateTime.now().add(Duration(seconds: -2))),
          ]));
}

class MockNavigatorObserver extends Mock implements NavigatorObserver {
  @override
  void didPop(Route<dynamic>? route, Route<dynamic>? previousRoute) =>
      super.noSuchMethod(Invocation.method(#didPop, [route, previousRoute]));

  @override
  void didPush(Route<dynamic>? route, Route<dynamic>? previousRoute) =>
      super.noSuchMethod(Invocation.method(#didPush, [route, previousRoute]));

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) =>
      super.noSuchMethod(Invocation.method(#didReplace, [newRoute, newRoute]));
}

final MockUserService mockUserService = MockUserService();
final MockDatabaseAccess mockDatabaseAccess = MockDatabaseAccess();

final loggedInUserContact = User("5678", "name", "status", "");
final List<Contact> cList = [
  Contact("123", "name1", true),
  Contact("1234", "name2", true)
];

void mockingServicesSetup() {
  GetIt.I.registerSingleton<UserService>(mockUserService);
  GetIt.I.registerSingleton<DatabaseAccess>(mockDatabaseAccess);
}

void mockFunctionsSetup() {
  when(mockUserService.login(any, any))
      .thenAnswer((_) async => Future<bool>.value(true));
  when(mockUserService.register(any, any, any))
      .thenAnswer((_) async => Future<bool>.value(true));

  when(mockDatabaseAccess.getChatWithContact(any))
      .thenAnswer((_) async => Future<List<Message>>.value([
            Message(
              cList[0].phoneNumber,
              loggedInUserContact.phoneNumber,
              "Message1_Content",
              DateTime.now().add(Duration(seconds: -6)),
            ),
            Message(
              loggedInUserContact.phoneNumber,
              cList[0].phoneNumber,
              "Message2_Content",
              DateTime.now().add(Duration(seconds: -5)),
            ),
            Message(
              cList[0].phoneNumber,
              loggedInUserContact.phoneNumber,
              "Message3_Content",
              DateTime.now().add(Duration(seconds: -4)),
            ),
            Message(
              loggedInUserContact.phoneNumber,
              cList[0].phoneNumber,
              "Message4_Content",
              DateTime.now().add(Duration(seconds: -2)),
            ),
          ]));

}
