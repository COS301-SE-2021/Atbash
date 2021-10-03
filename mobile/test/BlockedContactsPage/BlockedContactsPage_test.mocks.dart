// Mocks generated by Mockito 5.0.15 from annotations
// in mobile/test/BlockedContactsPage/BlockedContactsPage_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i7;

import 'package:mobile/domain/BlockedNumber.dart' as _i3;
import 'package:mobile/domain/Contact.dart' as _i5;
import 'package:mobile/services/BlockedNumbersService.dart' as _i6;
import 'package:mobile/services/ContactService.dart' as _i8;
import 'package:mobile/services/DatabaseService.dart' as _i2;
import 'package:mobile/services/PCConnectionService.dart' as _i4;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis

class _FakeDatabaseService_0 extends _i1.Fake implements _i2.DatabaseService {}

class _FakeBlockedNumber_1 extends _i1.Fake implements _i3.BlockedNumber {}

class _FakePCConnectionService_2 extends _i1.Fake
    implements _i4.PCConnectionService {}

class _FakeContact_3 extends _i1.Fake implements _i5.Contact {}

/// A class which mocks [BlockedNumbersService].
///
/// See the documentation for Mockito's code generation for more information.
class MockBlockedNumbersService extends _i1.Mock
    implements _i6.BlockedNumbersService {
  MockBlockedNumbersService() {
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
  _i7.Future<List<_i3.BlockedNumber>> fetchAll() =>
      (super.noSuchMethod(Invocation.method(#fetchAll, []),
              returnValue:
                  Future<List<_i3.BlockedNumber>>.value(<_i3.BlockedNumber>[]))
          as _i7.Future<List<_i3.BlockedNumber>>);
  @override
  _i7.Future<bool> checkIfBlocked(String? phoneNumber) =>
      (super.noSuchMethod(Invocation.method(#checkIfBlocked, [phoneNumber]),
          returnValue: Future<bool>.value(false)) as _i7.Future<bool>);
  @override
  _i7.Future<bool> checkIfBlockedByParent(String? phoneNumber) => (super
      .noSuchMethod(Invocation.method(#checkIfBlockedByParent, [phoneNumber]),
          returnValue: Future<bool>.value(false)) as _i7.Future<bool>);
  @override
  _i7.Future<_i3.BlockedNumber> insert(_i3.BlockedNumber? blockedNumber) =>
      (super.noSuchMethod(Invocation.method(#insert, [blockedNumber]),
              returnValue:
                  Future<_i3.BlockedNumber>.value(_FakeBlockedNumber_1()))
          as _i7.Future<_i3.BlockedNumber>);
  @override
  _i7.Future<void> delete(String? number) =>
      (super.noSuchMethod(Invocation.method(#delete, [number]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i7.Future<void>);
  @override
  String toString() => super.toString();
}

/// A class which mocks [ContactService].
///
/// See the documentation for Mockito's code generation for more information.
class MockContactService extends _i1.Mock implements _i8.ContactService {
  MockContactService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.DatabaseService get databaseService =>
      (super.noSuchMethod(Invocation.getter(#databaseService),
          returnValue: _FakeDatabaseService_0()) as _i2.DatabaseService);
  @override
  _i4.PCConnectionService get pcConnectionService => (super.noSuchMethod(
      Invocation.getter(#pcConnectionService),
      returnValue: _FakePCConnectionService_2()) as _i4.PCConnectionService);
  @override
  void onChanged(void Function()? cb) =>
      super.noSuchMethod(Invocation.method(#onChanged, [cb]),
          returnValueForMissingStub: null);
  @override
  void disposeOnChanged(void Function()? cb) =>
      super.noSuchMethod(Invocation.method(#disposeOnChanged, [cb]),
          returnValueForMissingStub: null);
  @override
  _i7.Future<List<_i5.Contact>> fetchAll() =>
      (super.noSuchMethod(Invocation.method(#fetchAll, []),
              returnValue: Future<List<_i5.Contact>>.value(<_i5.Contact>[]))
          as _i7.Future<List<_i5.Contact>>);
  @override
  _i7.Future<_i5.Contact> fetchByPhoneNumber(String? phoneNumber) =>
      (super.noSuchMethod(Invocation.method(#fetchByPhoneNumber, [phoneNumber]),
              returnValue: Future<_i5.Contact>.value(_FakeContact_3()))
          as _i7.Future<_i5.Contact>);
  @override
  _i7.Future<_i5.Contact> insert(_i5.Contact? contact) =>
      (super.noSuchMethod(Invocation.method(#insert, [contact]),
              returnValue: Future<_i5.Contact>.value(_FakeContact_3()))
          as _i7.Future<_i5.Contact>);
  @override
  _i7.Future<_i5.Contact> update(_i5.Contact? contact) =>
      (super.noSuchMethod(Invocation.method(#update, [contact]),
              returnValue: Future<_i5.Contact>.value(_FakeContact_3()))
          as _i7.Future<_i5.Contact>);
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
