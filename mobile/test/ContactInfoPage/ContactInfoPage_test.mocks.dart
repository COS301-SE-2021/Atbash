// Mocks generated by Mockito 5.0.15 from annotations
// in mobile/test/ContactInfoPage/ContactInfoPage_test.dart.
// Do not manually edit this file.

import 'package:mobile/controllers/ContactInfoPageController.dart' as _i4;
import 'package:mobile/models/ContactInfoPageModel.dart' as _i3;
import 'package:mobile/services/ContactService.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis

class _FakeContactService_0 extends _i1.Fake implements _i2.ContactService {}

class _FakeContactInfoPageModel_1 extends _i1.Fake
    implements _i3.ContactInfoPageModel {}

/// A class which mocks [ContactInfoPageController].
///
/// See the documentation for Mockito's code generation for more information.
class MockContactInfoPageController extends _i1.Mock
    implements _i4.ContactInfoPageController {
  MockContactInfoPageController() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.ContactService get contactService =>
      (super.noSuchMethod(Invocation.getter(#contactService),
          returnValue: _FakeContactService_0()) as _i2.ContactService);
  @override
  _i3.ContactInfoPageModel get model => (super.noSuchMethod(
      Invocation.getter(#model),
      returnValue: _FakeContactInfoPageModel_1()) as _i3.ContactInfoPageModel);
  @override
  String get phoneNumber =>
      (super.noSuchMethod(Invocation.getter(#phoneNumber), returnValue: '')
          as String);
  @override
  void reload() => super.noSuchMethod(Invocation.method(#reload, []),
      returnValueForMissingStub: null);
  @override
  String toString() => super.toString();
}
