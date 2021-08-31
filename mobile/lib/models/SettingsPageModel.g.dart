// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SettingsPageModel.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$SettingsPageModel on _SettingsPageModel, Store {
  final _$blurImagesAtom = Atom(name: '_SettingsPageModel.blurImages');

  @override
  bool get blurImages {
    _$blurImagesAtom.reportRead();
    return super.blurImages;
  }

  @override
  set blurImages(bool value) {
    _$blurImagesAtom.reportWrite(value, super.blurImages, () {
      super.blurImages = value;
    });
  }

  final _$safeModeAtom = Atom(name: '_SettingsPageModel.safeMode');

  @override
  bool get safeMode {
    _$safeModeAtom.reportRead();
    return super.safeMode;
  }

  @override
  set safeMode(bool value) {
    _$safeModeAtom.reportWrite(value, super.safeMode, () {
      super.safeMode = value;
    });
  }

  final _$sharedProfilePictureAtom =
      Atom(name: '_SettingsPageModel.sharedProfilePicture');

  @override
  bool get sharedProfilePicture {
    _$sharedProfilePictureAtom.reportRead();
    return super.sharedProfilePicture;
  }

  @override
  set sharedProfilePicture(bool value) {
    _$sharedProfilePictureAtom.reportWrite(value, super.sharedProfilePicture,
        () {
      super.sharedProfilePicture = value;
    });
  }

  final _$shareStatusAtom = Atom(name: '_SettingsPageModel.shareStatus');

  @override
  bool get shareStatus {
    _$shareStatusAtom.reportRead();
    return super.shareStatus;
  }

  @override
  set shareStatus(bool value) {
    _$shareStatusAtom.reportWrite(value, super.shareStatus, () {
      super.shareStatus = value;
    });
  }

  final _$shareReadReceiptsAtom =
      Atom(name: '_SettingsPageModel.shareReadReceipts');

  @override
  bool get shareReadReceipts {
    _$shareReadReceiptsAtom.reportRead();
    return super.shareReadReceipts;
  }

  @override
  set shareReadReceipts(bool value) {
    _$shareReadReceiptsAtom.reportWrite(value, super.shareReadReceipts, () {
      super.shareReadReceipts = value;
    });
  }

  final _$showNotificationsAtom =
      Atom(name: '_SettingsPageModel.showNotifications');

  @override
  bool get showNotifications {
    _$showNotificationsAtom.reportRead();
    return super.showNotifications;
  }

  @override
  set showNotifications(bool value) {
    _$showNotificationsAtom.reportWrite(value, super.showNotifications, () {
      super.showNotifications = value;
    });
  }

  final _$playNotificationSoundAtom =
      Atom(name: '_SettingsPageModel.playNotificationSound');

  @override
  bool get playNotificationSound {
    _$playNotificationSoundAtom.reportRead();
    return super.playNotificationSound;
  }

  @override
  set playNotificationSound(bool value) {
    _$playNotificationSoundAtom.reportWrite(value, super.playNotificationSound,
        () {
      super.playNotificationSound = value;
    });
  }

  final _$showMessagePreviewAtom =
      Atom(name: '_SettingsPageModel.showMessagePreview');

  @override
  bool get showMessagePreview {
    _$showMessagePreviewAtom.reportRead();
    return super.showMessagePreview;
  }

  @override
  set showMessagePreview(bool value) {
    _$showMessagePreviewAtom.reportWrite(value, super.showMessagePreview, () {
      super.showMessagePreview = value;
    });
  }

  final _$autoDownloadMediaAtom =
      Atom(name: '_SettingsPageModel.autoDownloadMedia');

  @override
  bool get autoDownloadMedia {
    _$autoDownloadMediaAtom.reportRead();
    return super.autoDownloadMedia;
  }

  @override
  set autoDownloadMedia(bool value) {
    _$autoDownloadMediaAtom.reportWrite(value, super.autoDownloadMedia, () {
      super.autoDownloadMedia = value;
    });
  }

  @override
  String toString() {
    return '''
blurImages: ${blurImages},
safeMode: ${safeMode},
sharedProfilePicture: ${sharedProfilePicture},
shareStatus: ${shareStatus},
shareReadReceipts: ${shareReadReceipts},
showNotifications: ${showNotifications},
playNotificationSound: ${playNotificationSound},
showMessagePreview: ${showMessagePreview},
autoDownloadMedia: ${autoDownloadMedia}
    ''';
  }
}
