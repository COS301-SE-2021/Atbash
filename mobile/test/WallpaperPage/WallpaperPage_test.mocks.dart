// Mocks generated by Mockito 5.0.15 from annotations
// in mobile/test/pages/WallpaperPage/WallpaperPage_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i3;

import 'package:mobile/services/SettingsService.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis

/// A class which mocks [SettingsService].
///
/// See the documentation for Mockito's code generation for more information.
class MockSettingsService extends _i1.Mock implements _i2.SettingsService {
  MockSettingsService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<void> setSafeModePin(String? pin) =>
      (super.noSuchMethod(Invocation.method(#setSafeModePin, [pin]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i3.Future<void>);
  @override
  _i3.Future<bool> getBlurImages() =>
      (super.noSuchMethod(Invocation.method(#getBlurImages, []),
          returnValue: Future<bool>.value(false)) as _i3.Future<bool>);
  @override
  _i3.Future<void> setBlurImages(bool? value) =>
      (super.noSuchMethod(Invocation.method(#setBlurImages, [value]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i3.Future<void>);
  @override
  _i3.Future<bool> getSafeMode() =>
      (super.noSuchMethod(Invocation.method(#getSafeMode, []),
          returnValue: Future<bool>.value(false)) as _i3.Future<bool>);
  @override
  _i3.Future<void> setSafeMode(bool? value) =>
      (super.noSuchMethod(Invocation.method(#setSafeMode, [value]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i3.Future<void>);
  @override
  _i3.Future<bool> getShareProfilePicture() =>
      (super.noSuchMethod(Invocation.method(#getShareProfilePicture, []),
          returnValue: Future<bool>.value(false)) as _i3.Future<bool>);
  @override
  _i3.Future<void> setShareProfilePicture(bool? value) =>
      (super.noSuchMethod(Invocation.method(#setShareProfilePicture, [value]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i3.Future<void>);
  @override
  _i3.Future<bool> getShareStatus() =>
      (super.noSuchMethod(Invocation.method(#getShareStatus, []),
          returnValue: Future<bool>.value(false)) as _i3.Future<bool>);
  @override
  _i3.Future<void> setShareStatus(bool? value) =>
      (super.noSuchMethod(Invocation.method(#setShareStatus, [value]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i3.Future<void>);
  @override
  _i3.Future<bool> getShareReadReceipts() =>
      (super.noSuchMethod(Invocation.method(#getShareReadReceipts, []),
          returnValue: Future<bool>.value(false)) as _i3.Future<bool>);
  @override
  _i3.Future<void> setShareReadReceipts(bool? value) =>
      (super.noSuchMethod(Invocation.method(#setShareReadReceipts, [value]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i3.Future<void>);
  @override
  _i3.Future<bool> getShareBirthday() =>
      (super.noSuchMethod(Invocation.method(#getShareBirthday, []),
          returnValue: Future<bool>.value(false)) as _i3.Future<bool>);
  @override
  _i3.Future<void> setShareBirthday(bool? value) =>
      (super.noSuchMethod(Invocation.method(#setShareBirthday, [value]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i3.Future<void>);
  @override
  _i3.Future<bool> getDisableNotifications() =>
      (super.noSuchMethod(Invocation.method(#getDisableNotifications, []),
          returnValue: Future<bool>.value(false)) as _i3.Future<bool>);
  @override
  _i3.Future<void> setDisableNotifications(bool? value) =>
      (super.noSuchMethod(Invocation.method(#setDisableNotifications, [value]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i3.Future<void>);
  @override
  _i3.Future<bool> getDisableMessagePreview() =>
      (super.noSuchMethod(Invocation.method(#getDisableMessagePreview, []),
          returnValue: Future<bool>.value(false)) as _i3.Future<bool>);
  @override
  _i3.Future<void> setDisableMessagePreview(bool? value) =>
      (super.noSuchMethod(Invocation.method(#setDisableMessagePreview, [value]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i3.Future<void>);
  @override
  _i3.Future<bool> getAutoDownloadMedia() =>
      (super.noSuchMethod(Invocation.method(#getAutoDownloadMedia, []),
          returnValue: Future<bool>.value(false)) as _i3.Future<bool>);
  @override
  _i3.Future<void> setAutoDownloadMedia(bool? value) =>
      (super.noSuchMethod(Invocation.method(#setAutoDownloadMedia, [value]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i3.Future<void>);
  @override
  _i3.Future<String?> getWallpaperImage() =>
      (super.noSuchMethod(Invocation.method(#getWallpaperImage, []),
          returnValue: Future<String?>.value()) as _i3.Future<String?>);
  @override
  _i3.Future<void> setWallpaperImage(String? imageBase64) =>
      (super.noSuchMethod(Invocation.method(#setWallpaperImage, [imageBase64]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i3.Future<void>);
  @override
  String toString() => super.toString();
}
