// Mocks generated by Mockito 5.0.15 from annotations
// in mobile/test/pages/ProfileSettingsPage/ProfileSettingsPage_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i17;
import 'dart:typed_data' as _i18;

import 'package:crypton/crypton.dart' as _i2;
import 'package:mobile/domain/Chat.dart' as _i22;
import 'package:mobile/domain/Contact.dart' as _i4;
import 'package:mobile/domain/Message.dart' as _i21;
import 'package:mobile/services/BlockedNumbersService.dart' as _i5;
import 'package:mobile/services/ChatService.dart' as _i8;
import 'package:mobile/services/CommunicationService.dart' as _i19;
import 'package:mobile/services/ContactService.dart' as _i9;
import 'package:mobile/services/DatabaseService.dart' as _i3;
import 'package:mobile/services/EncryptionService.dart' as _i6;
import 'package:mobile/services/MediaService.dart' as _i12;
import 'package:mobile/services/MemoryStoreService.dart' as _i13;
import 'package:mobile/services/MessageboxService.dart' as _i15;
import 'package:mobile/services/MessageService.dart' as _i10;
import 'package:mobile/services/NotificationService.dart' as _i14;
import 'package:mobile/services/SettingsService.dart' as _i11;
import 'package:mobile/services/UserService.dart' as _i7;
import 'package:mockito/mockito.dart' as _i1;
import 'package:synchronized/synchronized.dart' as _i16;
import 'package:web_socket_channel/io.dart' as _i20;

// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis

class _FakeRSAKeypair_0 extends _i1.Fake implements _i2.RSAKeypair {}

class _FakeDatabaseService_1 extends _i1.Fake implements _i3.DatabaseService {}

class _FakeContact_2 extends _i1.Fake implements _i4.Contact {}

class _FakeBlockedNumbersService_3 extends _i1.Fake
    implements _i5.BlockedNumbersService {}

class _FakeEncryptionService_4 extends _i1.Fake
    implements _i6.EncryptionService {}

class _FakeUserService_5 extends _i1.Fake implements _i7.UserService {}

class _FakeChatService_6 extends _i1.Fake implements _i8.ChatService {}

class _FakeContactService_7 extends _i1.Fake implements _i9.ContactService {}

class _FakeMessageService_8 extends _i1.Fake implements _i10.MessageService {}

class _FakeSettingsService_9 extends _i1.Fake implements _i11.SettingsService {}

class _FakeMediaService_10 extends _i1.Fake implements _i12.MediaService {}

class _FakeMemoryStoreService_11 extends _i1.Fake
    implements _i13.MemoryStoreService {}

class _FakeNotificationService_12 extends _i1.Fake
    implements _i14.NotificationService {}

class _FakeMessageboxService_13 extends _i1.Fake
    implements _i15.MessageboxService {}

class _FakeLock_14 extends _i1.Fake implements _i16.Lock {}

/// A class which mocks [UserService].
///
/// See the documentation for Mockito's code generation for more information.
class MockUserService extends _i1.Mock implements _i7.UserService {
  MockUserService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i17.Future<String> getPhoneNumber() =>
      (super.noSuchMethod(Invocation.method(#getPhoneNumber, []),
          returnValue: Future<String>.value('')) as _i17.Future<String>);
  @override
  _i17.Future<void> setPhoneNumber(String? phoneNumber) => (super.noSuchMethod(
      Invocation.method(#setPhoneNumber, [phoneNumber]),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value()) as _i17.Future<void>);
  @override
  _i17.Future<String> getDisplayName() =>
      (super.noSuchMethod(Invocation.method(#getDisplayName, []),
          returnValue: Future<String>.value('')) as _i17.Future<String>);
  @override
  _i17.Future<void> setDisplayName(String? displayName) => (super.noSuchMethod(
      Invocation.method(#setDisplayName, [displayName]),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value()) as _i17.Future<void>);
  @override
  _i17.Future<String> getStatus() =>
      (super.noSuchMethod(Invocation.method(#getStatus, []),
          returnValue: Future<String>.value('')) as _i17.Future<String>);
  @override
  _i17.Future<void> setStatus(String? status) => (super.noSuchMethod(
      Invocation.method(#setStatus, [status]),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value()) as _i17.Future<void>);
  @override
  _i17.Future<_i18.Uint8List?> getProfileImage() =>
      (super.noSuchMethod(Invocation.method(#getProfileImage, []),
              returnValue: Future<_i18.Uint8List?>.value())
          as _i17.Future<_i18.Uint8List?>);
  @override
  _i17.Future<void> setProfileImage(_i18.Uint8List? profileImage) =>
      (super.noSuchMethod(Invocation.method(#setProfileImage, [profileImage]),
              returnValue: Future<void>.value(),
              returnValueForMissingStub: Future<void>.value())
          as _i17.Future<void>);
  @override
  _i17.Future<DateTime?> getBirthday() =>
      (super.noSuchMethod(Invocation.method(#getBirthday, []),
          returnValue: Future<DateTime?>.value()) as _i17.Future<DateTime?>);
  @override
  _i17.Future<void> setBirthday(DateTime? birthday) => (super.noSuchMethod(
      Invocation.method(#setBirthday, [birthday]),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value()) as _i17.Future<void>);
  @override
  _i17.Future<String> getDeviceAuthTokenEncoded() =>
      (super.noSuchMethod(Invocation.method(#getDeviceAuthTokenEncoded, []),
          returnValue: Future<String>.value('')) as _i17.Future<String>);
  @override
  _i17.Future<void> storeRSAKeyPair(_i2.RSAKeypair? rsaKeypair) =>
      (super.noSuchMethod(Invocation.method(#storeRSAKeyPair, [rsaKeypair]),
              returnValue: Future<void>.value(),
              returnValueForMissingStub: Future<void>.value())
          as _i17.Future<void>);
  @override
  _i17.Future<_i2.RSAKeypair> fetchRSAKeyPair() =>
      (super.noSuchMethod(Invocation.method(#fetchRSAKeyPair, []),
              returnValue: Future<_i2.RSAKeypair>.value(_FakeRSAKeypair_0()))
          as _i17.Future<_i2.RSAKeypair>);
  @override
  String toString() => super.toString();
}

/// A class which mocks [ContactService].
///
/// See the documentation for Mockito's code generation for more information.
class MockContactService extends _i1.Mock implements _i9.ContactService {
  MockContactService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.DatabaseService get databaseService =>
      (super.noSuchMethod(Invocation.getter(#databaseService),
          returnValue: _FakeDatabaseService_1()) as _i3.DatabaseService);
  @override
  void onChanged(void Function()? cb) =>
      super.noSuchMethod(Invocation.method(#onChanged, [cb]),
          returnValueForMissingStub: null);
  @override
  void disposeOnChanged(void Function()? cb) =>
      super.noSuchMethod(Invocation.method(#disposeOnChanged, [cb]),
          returnValueForMissingStub: null);
  @override
  _i17.Future<List<_i4.Contact>> fetchAll() =>
      (super.noSuchMethod(Invocation.method(#fetchAll, []),
              returnValue: Future<List<_i4.Contact>>.value(<_i4.Contact>[]))
          as _i17.Future<List<_i4.Contact>>);
  @override
  _i17.Future<_i4.Contact> fetchByPhoneNumber(String? phoneNumber) =>
      (super.noSuchMethod(Invocation.method(#fetchByPhoneNumber, [phoneNumber]),
              returnValue: Future<_i4.Contact>.value(_FakeContact_2()))
          as _i17.Future<_i4.Contact>);
  @override
  _i17.Future<_i4.Contact> insert(_i4.Contact? contact) =>
      (super.noSuchMethod(Invocation.method(#insert, [contact]),
              returnValue: Future<_i4.Contact>.value(_FakeContact_2()))
          as _i17.Future<_i4.Contact>);
  @override
  _i17.Future<_i4.Contact> update(_i4.Contact? contact) =>
      (super.noSuchMethod(Invocation.method(#update, [contact]),
              returnValue: Future<_i4.Contact>.value(_FakeContact_2()))
          as _i17.Future<_i4.Contact>);
  @override
  _i17.Future<void> setContactStatus(
          String? contactPhoneNumber, String? status) =>
      (super.noSuchMethod(
          Invocation.method(#setContactStatus, [contactPhoneNumber, status]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub:
              Future<void>.value()) as _i17.Future<void>);
  @override
  _i17.Future<void> setContactProfileImage(
          String? contactPhoneNumber, String? profileImage) =>
      (super.noSuchMethod(
              Invocation.method(
                  #setContactProfileImage, [contactPhoneNumber, profileImage]),
              returnValue: Future<void>.value(),
              returnValueForMissingStub: Future<void>.value())
          as _i17.Future<void>);
  @override
  _i17.Future<void> setContactBirthday(
          String? contactPhoneNumber, DateTime? birthday) =>
      (super.noSuchMethod(
              Invocation.method(
                  #setContactBirthday, [contactPhoneNumber, birthday]),
              returnValue: Future<void>.value(),
              returnValueForMissingStub: Future<void>.value())
          as _i17.Future<void>);
  @override
  _i17.Future<void> deleteByPhoneNumber(String? phoneNumber) => (super
          .noSuchMethod(Invocation.method(#deleteByPhoneNumber, [phoneNumber]),
              returnValue: Future<void>.value(),
              returnValueForMissingStub: Future<void>.value())
      as _i17.Future<void>);
  @override
  String toString() => super.toString();
}

/// A class which mocks [CommunicationService].
///
/// See the documentation for Mockito's code generation for more information.
class MockCommunicationService extends _i1.Mock
    implements _i19.CommunicationService {
  MockCommunicationService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i5.BlockedNumbersService get blockedNumbersService =>
      (super.noSuchMethod(Invocation.getter(#blockedNumbersService),
              returnValue: _FakeBlockedNumbersService_3())
          as _i5.BlockedNumbersService);
  @override
  _i6.EncryptionService get encryptionService =>
      (super.noSuchMethod(Invocation.getter(#encryptionService),
          returnValue: _FakeEncryptionService_4()) as _i6.EncryptionService);
  @override
  _i7.UserService get userService =>
      (super.noSuchMethod(Invocation.getter(#userService),
          returnValue: _FakeUserService_5()) as _i7.UserService);
  @override
  _i8.ChatService get chatService =>
      (super.noSuchMethod(Invocation.getter(#chatService),
          returnValue: _FakeChatService_6()) as _i8.ChatService);
  @override
  _i9.ContactService get contactService =>
      (super.noSuchMethod(Invocation.getter(#contactService),
          returnValue: _FakeContactService_7()) as _i9.ContactService);
  @override
  _i10.MessageService get messageService =>
      (super.noSuchMethod(Invocation.getter(#messageService),
          returnValue: _FakeMessageService_8()) as _i10.MessageService);
  @override
  _i11.SettingsService get settingsService =>
      (super.noSuchMethod(Invocation.getter(#settingsService),
          returnValue: _FakeSettingsService_9()) as _i11.SettingsService);
  @override
  _i12.MediaService get mediaService =>
      (super.noSuchMethod(Invocation.getter(#mediaService),
          returnValue: _FakeMediaService_10()) as _i12.MediaService);
  @override
  _i13.MemoryStoreService get memoryStoreService => (super.noSuchMethod(
      Invocation.getter(#memoryStoreService),
      returnValue: _FakeMemoryStoreService_11()) as _i13.MemoryStoreService);
  @override
  _i14.NotificationService get notificationService => (super.noSuchMethod(
      Invocation.getter(#notificationService),
      returnValue: _FakeNotificationService_12()) as _i14.NotificationService);
  @override
  _i15.MessageboxService get messageboxService =>
      (super.noSuchMethod(Invocation.getter(#messageboxService),
          returnValue: _FakeMessageboxService_13()) as _i15.MessageboxService);
  @override
  _i16.Lock get communicationLock =>
      (super.noSuchMethod(Invocation.getter(#communicationLock),
          returnValue: _FakeLock_14()) as _i16.Lock);
  @override
  set communicationLock(_i16.Lock? _communicationLock) => super.noSuchMethod(
      Invocation.setter(#communicationLock, _communicationLock),
      returnValueForMissingStub: null);
  @override
  set channelNumber(_i20.IOWebSocketChannel? _channelNumber) =>
      super.noSuchMethod(Invocation.setter(#channelNumber, _channelNumber),
          returnValueForMissingStub: null);
  @override
  set channelAnonymous(_i20.IOWebSocketChannel? _channelAnonymous) => super
      .noSuchMethod(Invocation.setter(#channelAnonymous, _channelAnonymous),
          returnValueForMissingStub: null);
  @override
  set anonymousConnectionId(String? _anonymousConnectionId) =>
      super.noSuchMethod(
          Invocation.setter(#anonymousConnectionId, _anonymousConnectionId),
          returnValueForMissingStub: null);
  @override
  String get anonymousId =>
      (super.noSuchMethod(Invocation.getter(#anonymousId), returnValue: '')
          as String);
  @override
  set anonymousId(String? _anonymousId) =>
      super.noSuchMethod(Invocation.setter(#anonymousId, _anonymousId),
          returnValueForMissingStub: null);
  @override
  set onStopPrivateChat(void Function(String)? _onStopPrivateChat) => super
      .noSuchMethod(Invocation.setter(#onStopPrivateChat, _onStopPrivateChat),
          returnValueForMissingStub: null);
  @override
  set onAcceptPrivateChat(void Function()? _onAcceptPrivateChat) =>
      super.noSuchMethod(
          Invocation.setter(#onAcceptPrivateChat, _onAcceptPrivateChat),
          returnValueForMissingStub: null);
  @override
  bool Function(String) get shouldBlockNotifications =>
      (super.noSuchMethod(Invocation.getter(#shouldBlockNotifications),
              returnValue: (String incomingPhoneNumber) => false)
          as bool Function(String));
  @override
  set shouldBlockNotifications(
          bool Function(String)? _shouldBlockNotifications) =>
      super.noSuchMethod(
          Invocation.setter(
              #shouldBlockNotifications, _shouldBlockNotifications),
          returnValueForMissingStub: null);
  @override
  void onMessage(void Function(_i21.Message)? cb) =>
      super.noSuchMethod(Invocation.method(#onMessage, [cb]),
          returnValueForMissingStub: null);
  @override
  void disposeOnMessage(void Function(_i21.Message)? cb) =>
      super.noSuchMethod(Invocation.method(#disposeOnMessage, [cb]),
          returnValueForMissingStub: null);
  @override
  void onDelete(void Function(String)? cb) =>
      super.noSuchMethod(Invocation.method(#onDelete, [cb]),
          returnValueForMissingStub: null);
  @override
  void disposeOnDelete(void Function(String)? cb) =>
      super.noSuchMethod(Invocation.method(#disposeOnDelete, [cb]),
          returnValueForMissingStub: null);
  @override
  void onAck(void Function(String)? cb) =>
      super.noSuchMethod(Invocation.method(#onAck, [cb]),
          returnValueForMissingStub: null);
  @override
  void disposeOnAck(void Function(String)? cb) =>
      super.noSuchMethod(Invocation.method(#disposeOnAck, [cb]),
          returnValueForMissingStub: null);
  @override
  void onAckSeen(void Function(List<String>)? cb) =>
      super.noSuchMethod(Invocation.method(#onAckSeen, [cb]),
          returnValueForMissingStub: null);
  @override
  void disposeOnAckSeen(void Function(List<String>)? cb) =>
      super.noSuchMethod(Invocation.method(#disposeOnAckSeen, [cb]),
          returnValueForMissingStub: null);
  @override
  void onMessageLiked(void Function(String, bool)? cb) =>
      super.noSuchMethod(Invocation.method(#onMessageLiked, [cb]),
          returnValueForMissingStub: null);
  @override
  void disposeOnMessageLiked(void Function(String, bool)? cb) =>
      super.noSuchMethod(Invocation.method(#disposeOnMessageLiked, [cb]),
          returnValueForMissingStub: null);
  @override
  void onMessageEdited(void Function(String, String)? cb) =>
      super.noSuchMethod(Invocation.method(#onMessageEdited, [cb]),
          returnValueForMissingStub: null);
  @override
  void disposeOnMessageEdited(void Function(String, String)? cb) =>
      super.noSuchMethod(Invocation.method(#disposeOnMessageEdited, [cb]),
          returnValueForMissingStub: null);
  @override
  _i17.Future<void> registerConnectionForMessagebox(String? mid) =>
      (super.noSuchMethod(
              Invocation.method(#registerConnectionForMessagebox, [mid]),
              returnValue: Future<void>.value(),
              returnValueForMissingStub: Future<void>.value())
          as _i17.Future<void>);
  @override
  _i17.Future<void> goOnline() => (super.noSuchMethod(
      Invocation.method(#goOnline, []),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value()) as _i17.Future<void>);
  @override
  _i17.Future<void> sendMessage(_i21.Message? message, _i22.ChatType? chatType,
          String? recipientPhoneNumber, String? repliedMessageId) =>
      (super.noSuchMethod(
              Invocation.method(#sendMessage,
                  [message, chatType, recipientPhoneNumber, repliedMessageId]),
              returnValue: Future<void>.value(),
              returnValueForMissingStub: Future<void>.value())
          as _i17.Future<void>);
  @override
  _i17.Future<void> sendImage(_i21.Message? message, _i22.ChatType? chatType,
          String? recipientPhoneNumber) =>
      (super.noSuchMethod(
              Invocation.method(
                  #sendImage, [message, chatType, recipientPhoneNumber]),
              returnValue: Future<void>.value(),
              returnValueForMissingStub: Future<void>.value())
          as _i17.Future<void>);
  @override
  _i17.Future<void> sendDelete(
          String? messageId, String? recipientPhoneNumber) =>
      (super.noSuchMethod(
              Invocation.method(#sendDelete, [messageId, recipientPhoneNumber]),
              returnValue: Future<void>.value(),
              returnValueForMissingStub: Future<void>.value())
          as _i17.Future<void>);
  @override
  _i17.Future<void> sendLiked(
          String? messageId, bool? liked, String? recipientPhoneNumber) =>
      (super.noSuchMethod(
              Invocation.method(
                  #sendLiked, [messageId, liked, recipientPhoneNumber]),
              returnValue: Future<void>.value(),
              returnValueForMissingStub: Future<void>.value())
          as _i17.Future<void>);
  @override
  _i17.Future<void> sendEditedMessage(String? messageID, String? newMessage,
          String? recipientPhoneNumber) =>
      (super.noSuchMethod(
              Invocation.method(#sendEditedMessage,
                  [messageID, newMessage, recipientPhoneNumber]),
              returnValue: Future<void>.value(),
              returnValueForMissingStub: Future<void>.value())
          as _i17.Future<void>);
  @override
  _i17.Future<void> sendOnlineStatus(
          bool? online, String? recipientPhoneNumber) =>
      (super.noSuchMethod(
          Invocation.method(#sendOnlineStatus, [online, recipientPhoneNumber]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub:
              Future<void>.value()) as _i17.Future<void>);
  @override
  _i17.Future<void> sendStatus(String? status, String? recipientPhoneNumber) =>
      (super.noSuchMethod(
              Invocation.method(#sendStatus, [status, recipientPhoneNumber]),
              returnValue: Future<void>.value(),
              returnValueForMissingStub: Future<void>.value())
          as _i17.Future<void>);
  @override
  _i17.Future<void> sendBirthday(int? birthday, String? recipientPhoneNumber) =>
      (super.noSuchMethod(
          Invocation.method(#sendBirthday, [birthday, recipientPhoneNumber]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub:
              Future<void>.value()) as _i17.Future<void>);
  @override
  _i17.Future<void> sendProfileImage(
          String? profileImageBase64, String? recipientPhoneNumber) =>
      (super.noSuchMethod(
          Invocation.method(
              #sendProfileImage, [profileImageBase64, recipientPhoneNumber]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub:
              Future<void>.value()) as _i17.Future<void>);
  @override
  _i17.Future<void> sendAck(String? messageId, String? recipientPhoneNumber) =>
      (super.noSuchMethod(
              Invocation.method(#sendAck, [messageId, recipientPhoneNumber]),
              returnValue: Future<void>.value(),
              returnValueForMissingStub: Future<void>.value())
          as _i17.Future<void>);
  @override
  _i17.Future<void> sendAckSeen(
          List<String>? messageIds, String? recipientPhoneNumber) =>
      (super.noSuchMethod(
          Invocation.method(#sendAckSeen, [messageIds, recipientPhoneNumber]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub:
              Future<void>.value()) as _i17.Future<void>);
  @override
  _i17.Future<void> sendRequestStatus(String? contactPhoneNumber) =>
      (super.noSuchMethod(
              Invocation.method(#sendRequestStatus, [contactPhoneNumber]),
              returnValue: Future<void>.value(),
              returnValueForMissingStub: Future<void>.value())
          as _i17.Future<void>);
  @override
  _i17.Future<void> sendRequestBirthday(String? contactPhoneNumber) =>
      (super.noSuchMethod(
              Invocation.method(#sendRequestBirthday, [contactPhoneNumber]),
              returnValue: Future<void>.value(),
              returnValueForMissingStub: Future<void>.value())
          as _i17.Future<void>);
  @override
  _i17.Future<void> sendRequestProfileImage(String? contactPhoneNumber) =>
      (super.noSuchMethod(
              Invocation.method(#sendRequestProfileImage, [contactPhoneNumber]),
              returnValue: Future<void>.value(),
              returnValueForMissingStub: Future<void>.value())
          as _i17.Future<void>);
  @override
  _i17.Future<void> sendStartPrivateChat(String? recipientPhoneNumber) =>
      (super.noSuchMethod(
              Invocation.method(#sendStartPrivateChat, [recipientPhoneNumber]),
              returnValue: Future<void>.value(),
              returnValueForMissingStub: Future<void>.value())
          as _i17.Future<void>);
  @override
  _i17.Future<void> sendStopPrivateChat(String? recipientPhoneNumber) =>
      (super.noSuchMethod(
              Invocation.method(#sendStopPrivateChat, [recipientPhoneNumber]),
              returnValue: Future<void>.value(),
              returnValueForMissingStub: Future<void>.value())
          as _i17.Future<void>);
  @override
  _i17.Future<void> sendAcceptPrivateChat(String? recipientPhoneNumber) =>
      (super.noSuchMethod(
              Invocation.method(#sendAcceptPrivateChat, [recipientPhoneNumber]),
              returnValue: Future<void>.value(),
              returnValueForMissingStub: Future<void>.value())
          as _i17.Future<void>);
  @override
  _i17.Future<_i19.EventPayload?> getParsedEventPayload(
          Map<String, Object?>? event) =>
      (super.noSuchMethod(Invocation.method(#getParsedEventPayload, [event]),
              returnValue: Future<_i19.EventPayload?>.value())
          as _i17.Future<_i19.EventPayload?>);
  @override
  String toString() => super.toString();
}