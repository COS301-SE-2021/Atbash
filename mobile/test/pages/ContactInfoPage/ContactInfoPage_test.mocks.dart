// Mocks generated by Mockito 5.0.15 from annotations
// in mobile/test/pages/ContactInfoPage/ContactInfoPage_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i6;

import 'package:mobile/domain/BlockedNumber.dart' as _i4;
import 'package:mobile/domain/Contact.dart' as _i3;
import 'package:mobile/services/BlockedNumbersService.dart' as _i7;
import 'package:mobile/services/ContactService.dart' as _i5;
import 'package:mobile/services/DatabaseService.dart' as _i2;
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

class _FakeBlockedNumber_2 extends _i1.Fake implements _i4.BlockedNumber {}

/// A class which mocks [ContactService].
///
/// See the documentation for Mockito's code generation for more information.
class MockContactService extends _i1.Mock implements _i5.ContactService {
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
  _i6.Future<List<_i3.Contact>> fetchAll() =>
      (super.noSuchMethod(Invocation.method(#fetchAll, []),
              returnValue: Future<List<_i3.Contact>>.value(<_i3.Contact>[]))
          as _i6.Future<List<_i3.Contact>>);
  @override
  _i6.Future<_i3.Contact> fetchByPhoneNumber(String? phoneNumber) =>
      (super.noSuchMethod(Invocation.method(#fetchByPhoneNumber, [phoneNumber]),
              returnValue: Future<_i3.Contact>.value(_FakeContact_1()))
          as _i6.Future<_i3.Contact>);
  @override
  _i6.Future<_i3.Contact> insert(_i3.Contact? contact) =>
      (super.noSuchMethod(Invocation.method(#insert, [contact]),
              returnValue: Future<_i3.Contact>.value(_FakeContact_1()))
          as _i6.Future<_i3.Contact>);
  @override
  _i6.Future<_i3.Contact> update(_i3.Contact? contact) =>
      (super.noSuchMethod(Invocation.method(#update, [contact]),
              returnValue: Future<_i3.Contact>.value(_FakeContact_1()))
          as _i6.Future<_i3.Contact>);
  @override
  _i6.Future<void> setContactStatus(
          String? contactPhoneNumber, String? status) =>
      (super.noSuchMethod(
          Invocation.method(#setContactStatus, [contactPhoneNumber, status]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i6.Future<void>);
  @override
  _i6.Future<void> setContactProfileImage(
          String? contactPhoneNumber, String? profileImage) =>
      (super.noSuchMethod(
          Invocation.method(
              #setContactProfileImage, [contactPhoneNumber, profileImage]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i6.Future<void>);
  @override
  _i6.Future<void> setContactBirthday(
          String? contactPhoneNumber, DateTime? birthday) =>
      (super.noSuchMethod(
          Invocation.method(
              #setContactBirthday, [contactPhoneNumber, birthday]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i6.Future<void>);
  @override
  _i6.Future<void> deleteByPhoneNumber(String? phoneNumber) => (super
      .noSuchMethod(Invocation.method(#deleteByPhoneNumber, [phoneNumber]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i6.Future<void>);
  @override
  String toString() => super.toString();
}

/// A class which mocks [BlockedNumbersService].
///
/// See the documentation for Mockito's code generation for more information.
class MockBlockedNumbersService extends _i1.Mock
    implements _i7.BlockedNumbersService {
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
  _i6.Future<List<_i4.BlockedNumber>> fetchAll() =>
      (super.noSuchMethod(Invocation.method(#fetchAll, []),
              returnValue:
                  Future<List<_i4.BlockedNumber>>.value(<_i4.BlockedNumber>[]))
          as _i6.Future<List<_i4.BlockedNumber>>);
  @override
  _i6.Future<bool> checkIfBlocked(String? phoneNumber) =>
      (super.noSuchMethod(Invocation.method(#checkIfBlocked, [phoneNumber]),
          returnValue: Future<bool>.value(false)) as _i6.Future<bool>);
  @override
  _i6.Future<_i4.BlockedNumber> insert(_i4.BlockedNumber? blockedNumber) =>
      (super.noSuchMethod(Invocation.method(#insert, [blockedNumber]),
              returnValue:
                  Future<_i4.BlockedNumber>.value(_FakeBlockedNumber_2()))
          as _i6.Future<_i4.BlockedNumber>);
  @override
  _i6.Future<void> delete(String? number) =>
      (super.noSuchMethod(Invocation.method(#delete, [number]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i6.Future<void>);
  @override
  String toString() => super.toString();
}
