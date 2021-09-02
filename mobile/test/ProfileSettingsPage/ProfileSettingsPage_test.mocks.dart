// Mocks generated by Mockito 5.0.15 from annotations
// in mobile/test/ProfileSettingsPage/ProfileSettingsPage_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i8;
import 'dart:typed_data' as _i7;

import 'package:mobile/controllers/ProfileSettingsPageController.dart' as _i6;
import 'package:mobile/models/ProfileSettingsPageModel.dart' as _i5;
import 'package:mobile/services/CommunicationService.dart' as _i4;
import 'package:mobile/services/ContactService.dart' as _i3;
import 'package:mobile/services/UserService.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis

class _FakeUserService_0 extends _i1.Fake implements _i2.UserService {}

class _FakeContactService_1 extends _i1.Fake implements _i3.ContactService {}

class _FakeCommunicationService_2 extends _i1.Fake
    implements _i4.CommunicationService {}

class _FakeProfileSettingsPageModel_3 extends _i1.Fake
    implements _i5.ProfileSettingsPageModel {}

/// A class which mocks [ProfileSettingsPageController].
///
/// See the documentation for Mockito's code generation for more information.
class MockProfileSettingsPageController extends _i1.Mock
    implements _i6.ProfileSettingsPageController {
  MockProfileSettingsPageController() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.UserService get userService =>
      (super.noSuchMethod(Invocation.getter(#userService),
          returnValue: _FakeUserService_0()) as _i2.UserService);
  @override
  _i3.ContactService get contactService =>
      (super.noSuchMethod(Invocation.getter(#contactService),
          returnValue: _FakeContactService_1()) as _i3.ContactService);
  @override
  _i4.CommunicationService get communicationService => (super.noSuchMethod(
      Invocation.getter(#communicationService),
      returnValue: _FakeCommunicationService_2()) as _i4.CommunicationService);
  @override
  _i5.ProfileSettingsPageModel get model =>
      (super.noSuchMethod(Invocation.getter(#model),
              returnValue: _FakeProfileSettingsPageModel_3())
          as _i5.ProfileSettingsPageModel);
  @override
  void setDisplayName(String? name) =>
      super.noSuchMethod(Invocation.method(#setDisplayName, [name]),
          returnValueForMissingStub: null);
  @override
  void setStatus(String? status) =>
      super.noSuchMethod(Invocation.method(#setStatus, [status]),
          returnValueForMissingStub: null);
  @override
  void setBirthday(DateTime? birthday) =>
      super.noSuchMethod(Invocation.method(#setBirthday, [birthday]),
          returnValueForMissingStub: null);
  @override
  void setProfilePicture(_i7.Uint8List? picture) =>
      super.noSuchMethod(Invocation.method(#setProfilePicture, [picture]),
          returnValueForMissingStub: null);
  @override
  _i8.Future<void> importContacts() =>
      (super.noSuchMethod(Invocation.method(#importContacts, []),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i8.Future<void>);
  @override
  String toString() => super.toString();
}
