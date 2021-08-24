import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobx/mobx.dart';

part 'SettingsModel.g.dart';

class SettingsModel = _SettingsModel with _$SettingsModel;

abstract class _SettingsModel with Store {
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  @observable
  bool blurImages = false;

  @observable
  bool safeMode = false;

  @observable
  bool shareProfileImage = false;

  @observable
  bool shareStatus = false;

  @observable
  bool shareReadReceipts = false;

  @observable
  bool showNotifications = false;

  @observable
  bool playNotificationsSound = false;

  @observable
  bool showMessagePreview = false;

  @observable
  bool autoDownloadMedia = false;

  @observable
  ObservableList<String> blockedNumbers = <String>[].asObservable();

  @action
  Future<void> init() async {
    final blurImagesFuture = _storage
        .read(key: "settings_blur_images")
        .then((value) => blurImages = value == "true");

    final safeModeFuture = _storage
        .read(key: "settings_safe_mode")
        .then((value) => safeMode = value == "true");

    final shareProfileImageFuture = _storage
        .read(key: "settings_share_profile_image")
        .then((value) => shareProfileImage = value == "true");

    final shareStatusFuture = _storage
        .read(key: "settings_share_status")
        .then((value) => shareStatus = value == "true");

    final shareReadReceiptsFuture = _storage
        .read(key: "settings_share_read_receipts")
        .then((value) => shareReadReceipts = value == "true");

    final showNotificationsFuture = _storage
        .read(key: "settings_show_notifications")
        .then((value) => showNotifications = value == "true");

    final playNotificationsSoundFuture = _storage
        .read(key: "settings_play_notifications_sound")
        .then((value) => playNotificationsSound = value == "true");

    final showMessagePreviewFuture = _storage
        .read(key: "settings_show_message_preview")
        .then((value) => showMessagePreview = value == "true");

    final autoDownloadMediaFuture = _storage
        .read(key: "settings_auto_download_media")
        .then((value) => autoDownloadMedia = value == "true");

    await Future.wait([
      blurImagesFuture,
      safeModeFuture,
      shareProfileImageFuture,
      shareStatusFuture,
      shareReadReceiptsFuture,
      showNotificationsFuture,
      playNotificationsSoundFuture,
      showMessagePreviewFuture,
      autoDownloadMediaFuture
    ]);
  }

  @action
  void setSafeModePin(String pin) {
    _storage.write(key: "settings_safe_search_pin", value: pin);
  }

  @action
  void setSafeMode(bool safeMode, String pin) {
    //TODO: implement pin check

    this.safeMode = safeMode;
    _storage.write(
        key: "settings_safe_mode", value: safeMode ? "true" : "false");
  }

  @action
  void setBlurImages(bool value) {
    this.blurImages = value;
    _storage.write(
        key: "settings_blur_images", value: value ? "true" : "false");
  }

  @action
  void setShareProfileImage(bool value) {
    this.shareProfileImage = value;
    _storage.write(
        key: "settings_share_profile_image", value: value ? "true" : "false");
  }

  @action
  void setShareStatus(bool value) {
    this.shareStatus = value;
    _storage.write(
        key: "settings_share_status", value: value ? "true" : "false");
  }

  @action
  void setShareReadReceipts(bool value) {
    this.shareReadReceipts = value;
    _storage.write(
        key: "settings_share_read_receipts", value: value ? "true" : "false");
  }

  @action
  void setShowNotifications(bool value) {
    this.showNotifications = value;
    _storage.write(
        key: "settings_show_notifications", value: value ? "true" : "false");
  }

  @action
  void setPlayNotificationsSound(bool value) {
    this.playNotificationsSound = value;
    _storage.write(
        key: "settings_play_notifications_sound",
        value: value ? "true" : "false");
  }

  @action
  void setShowMessagePreview(bool value) {
    this.showMessagePreview = value;
    _storage.write(
        key: "settings_show_message_preview", value: value ? "true" : "false");
  }

  @action
  void setAutoDownloadMedia(bool value) {
    this.autoDownloadMedia = value;
    _storage.write(
        key: "settings_auto_download_media", value: value ? "true" : "false");
  }

  @action
  void addBlockedNumber(String number) {
    //TODO:
    //Persist data

    blockedNumbers.add(number);
  }

  @action
  void removeBlockedNumber(String number) {
    //TODO:
    //Persist data

    blockedNumbers.remove(number);
  }
}
