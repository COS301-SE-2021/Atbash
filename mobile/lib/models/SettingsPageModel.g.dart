// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SettingsPageModel.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$SettingsPageModel on _SettingsPageModel, Store {
  final _$userNameAtom = Atom(name: '_SettingsPageModel.userName');

  @override
  String get userName {
    _$userNameAtom.reportRead();
    return super.userName;
  }

  @override
  set userName(String value) {
    _$userNameAtom.reportWrite(value, super.userName, () {
      super.userName = value;
    });
  }

  final _$userStatusAtom = Atom(name: '_SettingsPageModel.userStatus');

  @override
  String get userStatus {
    _$userStatusAtom.reportRead();
    return super.userStatus;
  }

  @override
  set userStatus(String value) {
    _$userStatusAtom.reportWrite(value, super.userStatus, () {
      super.userStatus = value;
    });
  }

  final _$userProfilePictureAtom =
      Atom(name: '_SettingsPageModel.userProfilePicture');

  @override
  Uint8List? get userProfilePicture {
    _$userProfilePictureAtom.reportRead();
    return super.userProfilePicture;
  }

  @override
  set userProfilePicture(Uint8List? value) {
    _$userProfilePictureAtom.reportWrite(value, super.userProfilePicture, () {
      super.userProfilePicture = value;
    });
  }

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

  final _$disableNotificationsAtom =
      Atom(name: '_SettingsPageModel.disableNotifications');

  @override
  bool get disableNotifications {
    _$disableNotificationsAtom.reportRead();
    return super.disableNotifications;
  }

  @override
  set disableNotifications(bool value) {
    _$disableNotificationsAtom.reportWrite(value, super.disableNotifications,
        () {
      super.disableNotifications = value;
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

  final _$disableMessagePreviewAtom =
      Atom(name: '_SettingsPageModel.disableMessagePreview');

  @override
  bool get disableMessagePreview {
    _$disableMessagePreviewAtom.reportRead();
    return super.disableMessagePreview;
  }

  @override
  set disableMessagePreview(bool value) {
    _$disableMessagePreviewAtom.reportWrite(value, super.disableMessagePreview,
        () {
      super.disableMessagePreview = value;
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
userName: ${userName},
userStatus: ${userStatus},
userProfilePicture: ${userProfilePicture},
blurImages: ${blurImages},
safeMode: ${safeMode},
sharedProfilePicture: ${sharedProfilePicture},
shareStatus: ${shareStatus},
shareReadReceipts: ${shareReadReceipts},
disableNotifications: ${disableNotifications},
playNotificationSound: ${playNotificationSound},
disableMessagePreview: ${disableMessagePreview},
autoDownloadMedia: ${autoDownloadMedia}
    ''';
  }
}
