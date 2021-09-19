// Mocks generated by Mockito 5.0.15 from annotations
// in mobile/test/pages/AnalyticsPage/AnalyticsPage_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i7;

import 'package:mobile/domain/Chat.dart' as _i5;
import 'package:mobile/domain/Contact.dart' as _i3;
import 'package:mobile/domain/Message.dart' as _i4;
import 'package:mobile/services/ChatService.dart' as _i9;
import 'package:mobile/services/ContactService.dart' as _i6;
import 'package:mobile/services/DatabaseService.dart' as _i2;
import 'package:mobile/services/MessageService.dart' as _i8;
import 'package:mobile/util/Tuple.dart' as _i10;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis

class _FakeDatabaseService_0 extends _i1.Fake implements _i2.DatabaseService {}

class _FakeContact_1 extends _i1.Fake implements _i3.Contact {}

class _FakeMessage_2 extends _i1.Fake implements _i4.Message {}

class _FakeChat_3 extends _i1.Fake implements _i5.Chat {}

/// A class which mocks [ContactService].
///
/// See the documentation for Mockito's code generation for more information.
class MockContactService extends _i1.Mock implements _i6.ContactService {
  MockContactService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.DatabaseService get databaseService =>
      (super.noSuchMethod(Invocation.getter(#databaseService),
          returnValue: _FakeDatabaseService_0()) as _i2.DatabaseService);
  @override
  void onChanged(void Function()? cb) =>
      super.noSuchMethod(Invocation.method(#onChanged, [cb]),
          returnValueForMissingStub: null);
  @override
  void disposeOnChanged(void Function()? cb) =>
      super.noSuchMethod(Invocation.method(#disposeOnChanged, [cb]),
          returnValueForMissingStub: null);
  @override
  _i7.Future<List<_i3.Contact>> fetchAll() =>
      (super.noSuchMethod(Invocation.method(#fetchAll, []),
              returnValue: Future<List<_i3.Contact>>.value(<_i3.Contact>[]))
          as _i7.Future<List<_i3.Contact>>);
  @override
  _i7.Future<_i3.Contact> fetchByPhoneNumber(String? phoneNumber) =>
      (super.noSuchMethod(Invocation.method(#fetchByPhoneNumber, [phoneNumber]),
              returnValue: Future<_i3.Contact>.value(_FakeContact_1()))
          as _i7.Future<_i3.Contact>);
  @override
  _i7.Future<_i3.Contact> insert(_i3.Contact? contact) =>
      (super.noSuchMethod(Invocation.method(#insert, [contact]),
              returnValue: Future<_i3.Contact>.value(_FakeContact_1()))
          as _i7.Future<_i3.Contact>);
  @override
  _i7.Future<_i3.Contact> update(_i3.Contact? contact) =>
      (super.noSuchMethod(Invocation.method(#update, [contact]),
              returnValue: Future<_i3.Contact>.value(_FakeContact_1()))
          as _i7.Future<_i3.Contact>);
  @override
  _i7.Future<void> setContactStatus(
          String? contactPhoneNumber, String? status) =>
      (super.noSuchMethod(
          Invocation.method(#setContactStatus, [contactPhoneNumber, status]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i7.Future<void>);
  @override
  _i7.Future<void> setContactProfileImage(
          String? contactPhoneNumber, String? profileImage) =>
      (super.noSuchMethod(
          Invocation.method(
              #setContactProfileImage, [contactPhoneNumber, profileImage]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i7.Future<void>);
  @override
  _i7.Future<void> setContactBirthday(
          String? contactPhoneNumber, DateTime? birthday) =>
      (super.noSuchMethod(
          Invocation.method(
              #setContactBirthday, [contactPhoneNumber, birthday]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i7.Future<void>);
  @override
  _i7.Future<void> deleteByPhoneNumber(String? phoneNumber) => (super
      .noSuchMethod(Invocation.method(#deleteByPhoneNumber, [phoneNumber]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i7.Future<void>);
  @override
  String toString() => super.toString();
}

/// A class which mocks [MessageService].
///
/// See the documentation for Mockito's code generation for more information.
class MockMessageService extends _i1.Mock implements _i8.MessageService {
  MockMessageService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.DatabaseService get databaseService =>
      (super.noSuchMethod(Invocation.getter(#databaseService),
          returnValue: _FakeDatabaseService_0()) as _i2.DatabaseService);
  @override
  _i7.Future<List<_i4.Message>> fetchAllByChatId(String? chatId) =>
      (super.noSuchMethod(Invocation.method(#fetchAllByChatId, [chatId]),
              returnValue: Future<List<_i4.Message>>.value(<_i4.Message>[]))
          as _i7.Future<List<_i4.Message>>);
  @override
  _i7.Future<_i4.Message> fetchById(String? id) =>
      (super.noSuchMethod(Invocation.method(#fetchById, [id]),
              returnValue: Future<_i4.Message>.value(_FakeMessage_2()))
          as _i7.Future<_i4.Message>);
  @override
  _i7.Future<List<_i4.Message>> fetchAllById(List<String>? ids) =>
      (super.noSuchMethod(Invocation.method(#fetchAllById, [ids]),
              returnValue: Future<List<_i4.Message>>.value(<_i4.Message>[]))
          as _i7.Future<List<_i4.Message>>);
  @override
  _i7.Future<_i4.Message> insert(_i4.Message? message) =>
      (super.noSuchMethod(Invocation.method(#insert, [message]),
              returnValue: Future<_i4.Message>.value(_FakeMessage_2()))
          as _i7.Future<_i4.Message>);
  @override
  _i7.Future<_i4.Message> update(_i4.Message? message) =>
      (super.noSuchMethod(Invocation.method(#update, [message]),
              returnValue: Future<_i4.Message>.value(_FakeMessage_2()))
          as _i7.Future<_i4.Message>);
  @override
  _i7.Future<void> updateMessageContents(
          String? messageId, String? newMessage) =>
      (super.noSuchMethod(
          Invocation.method(#updateMessageContents, [messageId, newMessage]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i7.Future<void>);
  @override
  _i7.Future<void> setMessageDeleted(String? messageId) =>
      (super.noSuchMethod(Invocation.method(#setMessageDeleted, [messageId]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i7.Future<void>);
  @override
  _i7.Future<void> setMessageReadReceipt(
          String? messageId, _i4.ReadReceipt? readReceipt) =>
      (super.noSuchMethod(
          Invocation.method(#setMessageReadReceipt, [messageId, readReceipt]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i7.Future<void>);
  @override
  _i7.Future<void> deleteById(String? id) =>
      (super.noSuchMethod(Invocation.method(#deleteById, [id]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i7.Future<void>);
  @override
  _i7.Future<void> deleteAllByChatId(String? chatId) =>
      (super.noSuchMethod(Invocation.method(#deleteAllByChatId, [chatId]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i7.Future<void>);
  @override
  _i7.Future<void> setMessageLiked(String? messageId, bool? liked) => (super
      .noSuchMethod(Invocation.method(#setMessageLiked, [messageId, liked]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i7.Future<void>);
  @override
  String toString() => super.toString();
}

/// A class which mocks [ChatService].
///
/// See the documentation for Mockito's code generation for more information.
class MockChatService extends _i1.Mock implements _i9.ChatService {
  MockChatService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.DatabaseService get databaseService =>
      (super.noSuchMethod(Invocation.getter(#databaseService),
          returnValue: _FakeDatabaseService_0()) as _i2.DatabaseService);
  @override
  void onChanged(void Function()? cb) =>
      super.noSuchMethod(Invocation.method(#onChanged, [cb]),
          returnValueForMissingStub: null);
  @override
  void disposeOnChanged(void Function()? cb) =>
      super.noSuchMethod(Invocation.method(#disposeOnChanged, [cb]),
          returnValueForMissingStub: null);
  @override
  _i7.Future<List<_i5.Chat>> fetchAll() =>
      (super.noSuchMethod(Invocation.method(#fetchAll, []),
              returnValue: Future<List<_i5.Chat>>.value(<_i5.Chat>[]))
          as _i7.Future<List<_i5.Chat>>);
  @override
  _i7.Future<_i5.Chat> fetchById(String? chatId) =>
      (super.noSuchMethod(Invocation.method(#fetchById, [chatId]),
              returnValue: Future<_i5.Chat>.value(_FakeChat_3()))
          as _i7.Future<_i5.Chat>);
  @override
  _i7.Future<List<_i10.Tuple<String, String>>> fetchIdsByContactPhoneNumbers(
          List<String>? numbers) =>
      (super.noSuchMethod(
              Invocation.method(#fetchIdsByContactPhoneNumbers, [numbers]),
              returnValue: Future<List<_i10.Tuple<String, String>>>.value(
                  <_i10.Tuple<String, String>>[]))
          as _i7.Future<List<_i10.Tuple<String, String>>>);
  @override
  _i7.Future<List<_i5.Chat>> fetchByChatType(_i5.ChatType? chatType) =>
      (super.noSuchMethod(Invocation.method(#fetchByChatType, [chatType]),
              returnValue: Future<List<_i5.Chat>>.value(<_i5.Chat>[]))
          as _i7.Future<List<_i5.Chat>>);
  @override
  _i7.Future<_i5.Chat> insert(_i5.Chat? chat) =>
      (super.noSuchMethod(Invocation.method(#insert, [chat]),
              returnValue: Future<_i5.Chat>.value(_FakeChat_3()))
          as _i7.Future<_i5.Chat>);
  @override
  _i7.Future<_i5.Chat> update(_i5.Chat? chat) =>
      (super.noSuchMethod(Invocation.method(#update, [chat]),
              returnValue: Future<_i5.Chat>.value(_FakeChat_3()))
          as _i7.Future<_i5.Chat>);
  @override
  _i7.Future<void> deleteById(String? id) =>
      (super.noSuchMethod(Invocation.method(#deleteById, [id]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i7.Future<void>);
  @override
  _i7.Future<bool> existsById(String? id) =>
      (super.noSuchMethod(Invocation.method(#existsById, [id]),
          returnValue: Future<bool>.value(false)) as _i7.Future<bool>);
  @override
  _i7.Future<bool> existsByPhoneNumberAndChatType(
          String? phoneNumber, _i5.ChatType? chatType) =>
      (super.noSuchMethod(
          Invocation.method(
              #existsByPhoneNumberAndChatType, [phoneNumber, chatType]),
          returnValue: Future<bool>.value(false)) as _i7.Future<bool>);
  @override
  _i7.Future<String> findIdByPhoneNumberAndChatType(
          String? phoneNumber, _i5.ChatType? chatType) =>
      (super.noSuchMethod(
          Invocation.method(
              #findIdByPhoneNumberAndChatType, [phoneNumber, chatType]),
          returnValue: Future<String>.value('')) as _i7.Future<String>);
  @override
  String toString() => super.toString();
}