// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SettingsModel.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$SettingsModel on _SettingsModel, Store {
  final _$blurImagesAtom = Atom(name: '_SettingsModel.blurImages');

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

  final _$safeModeAtom = Atom(name: '_SettingsModel.safeMode');

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

  final _$shareProfileImageAtom =
      Atom(name: '_SettingsModel.shareProfileImage');

  @override
  bool get shareProfileImage {
    _$shareProfileImageAtom.reportRead();
    return super.shareProfileImage;
  }

  @override
  set shareProfileImage(bool value) {
    _$shareProfileImageAtom.reportWrite(value, super.shareProfileImage, () {
      super.shareProfileImage = value;
    });
  }

  final _$shareStatusAtom = Atom(name: '_SettingsModel.shareStatus');

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
      Atom(name: '_SettingsModel.shareReadReceipts');

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
      Atom(name: '_SettingsModel.showNotifications');

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

  final _$playNotificationsSoundAtom =
      Atom(name: '_SettingsModel.playNotificationsSound');

  @override
  bool get playNotificationsSound {
    _$playNotificationsSoundAtom.reportRead();
    return super.playNotificationsSound;
  }

  @override
  set playNotificationsSound(bool value) {
    _$playNotificationsSoundAtom
        .reportWrite(value, super.playNotificationsSound, () {
      super.playNotificationsSound = value;
    });
  }

  final _$showMessagePreviewAtom =
      Atom(name: '_SettingsModel.showMessagePreview');

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
      Atom(name: '_SettingsModel.autoDownloadMedia');

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

  final _$blockedNumbersAtom = Atom(name: '_SettingsModel.blockedNumbers');

  @override
  ObservableList<String> get blockedNumbers {
    _$blockedNumbersAtom.reportRead();
    return super.blockedNumbers;
  }

  @override
  set blockedNumbers(ObservableList<String> value) {
    _$blockedNumbersAtom.reportWrite(value, super.blockedNumbers, () {
      super.blockedNumbers = value;
    });
  }

  final _$initAsyncAction = AsyncAction('_SettingsModel.init');

  @override
  Future<void> init() {
    return _$initAsyncAction.run(() => super.init());
  }

  final _$_SettingsModelActionController =
      ActionController(name: '_SettingsModel');

  @override
  void setSafeModePin(String pin) {
    final _$actionInfo = _$_SettingsModelActionController.startAction(
        name: '_SettingsModel.setSafeModePin');
    try {
      return super.setSafeModePin(pin);
    } finally {
      _$_SettingsModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSafeMode(bool safeMode, String pin) {
    final _$actionInfo = _$_SettingsModelActionController.startAction(
        name: '_SettingsModel.setSafeMode');
    try {
      return super.setSafeMode(safeMode, pin);
    } finally {
      _$_SettingsModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setBlurImages(bool value) {
    final _$actionInfo = _$_SettingsModelActionController.startAction(
        name: '_SettingsModel.setBlurImages');
    try {
      return super.setBlurImages(value);
    } finally {
      _$_SettingsModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setShareProfileImage(bool value) {
    final _$actionInfo = _$_SettingsModelActionController.startAction(
        name: '_SettingsModel.setShareProfileImage');
    try {
      return super.setShareProfileImage(value);
    } finally {
      _$_SettingsModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setShareStatus(bool value) {
    final _$actionInfo = _$_SettingsModelActionController.startAction(
        name: '_SettingsModel.setShareStatus');
    try {
      return super.setShareStatus(value);
    } finally {
      _$_SettingsModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setShareReadReceipts(bool value) {
    final _$actionInfo = _$_SettingsModelActionController.startAction(
        name: '_SettingsModel.setShareReadReceipts');
    try {
      return super.setShareReadReceipts(value);
    } finally {
      _$_SettingsModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setShowNotifications(bool value) {
    final _$actionInfo = _$_SettingsModelActionController.startAction(
        name: '_SettingsModel.setShowNotifications');
    try {
      return super.setShowNotifications(value);
    } finally {
      _$_SettingsModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPlayNotificationsSound(bool value) {
    final _$actionInfo = _$_SettingsModelActionController.startAction(
        name: '_SettingsModel.setPlayNotificationsSound');
    try {
      return super.setPlayNotificationsSound(value);
    } finally {
      _$_SettingsModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setShowMessagePreview(bool value) {
    final _$actionInfo = _$_SettingsModelActionController.startAction(
        name: '_SettingsModel.setShowMessagePreview');
    try {
      return super.setShowMessagePreview(value);
    } finally {
      _$_SettingsModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setAutoDownloadMedia(bool value) {
    final _$actionInfo = _$_SettingsModelActionController.startAction(
        name: '_SettingsModel.setAutoDownloadMedia');
    try {
      return super.setAutoDownloadMedia(value);
    } finally {
      _$_SettingsModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addBlockedNumber(String number) {
    final _$actionInfo = _$_SettingsModelActionController.startAction(
        name: '_SettingsModel.addBlockedNumber');
    try {
      return super.addBlockedNumber(number);
    } finally {
      _$_SettingsModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeBlockedNumber(String number) {
    final _$actionInfo = _$_SettingsModelActionController.startAction(
        name: '_SettingsModel.removeBlockedNumber');
    try {
      return super.removeBlockedNumber(number);
    } finally {
      _$_SettingsModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
blurImages: ${blurImages},
safeMode: ${safeMode},
shareProfileImage: ${shareProfileImage},
shareStatus: ${shareStatus},
shareReadReceipts: ${shareReadReceipts},
showNotifications: ${showNotifications},
playNotificationsSound: ${playNotificationsSound},
showMessagePreview: ${showMessagePreview},
autoDownloadMedia: ${autoDownloadMedia},
blockedNumbers: ${blockedNumbers}
    ''';
  }
}
