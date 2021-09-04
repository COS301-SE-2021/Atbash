import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SettingsService {
  final _storage = FlutterSecureStorage();

  Future<void> setSafeModePin(String pin) async {
    await _storage.write(key: "settings_safe_search_pin", value: pin);
  }

  Future<void> addBlockedNumber(String number) async {
    //TODO Implement functionality
  }

  Future<void> removeBlockedNumber(String number) async {
    //TODO Implement functionality
  }

  Future<List<String>> fetchAllBlockedNumbers() async {
    //TODO Implement functionality
    return [];
  }

  Future<bool> getBlurImages() async {
    final bool blurImage =
        await _storage.read(key: "settings_blur_images") == "true";
    return blurImage;
  }

  Future<void> setBlurImages(bool value) async {
    await _storage.write(
        key: "settings_blur_images", value: value ? "true" : "false");
  }

  Future<bool> getSafeMode() async {
    final bool safeMode =
        await _storage.read(key: "settings_safe_mode") == "true";
    return safeMode;
  }

  Future<void> setSafeMode(bool value) async {
    await _storage.write(
        key: "settings_safe_mode", value: value ? "true" : "false");
  }

  Future<bool> getShareProfilePicture() async {
    final bool shareProfilePicture =
        await _storage.read(key: "settings_share_profile_image") == "true";
    return shareProfilePicture;
  }

  Future<void> setShareProfilePicture(bool value) async {
    await _storage.write(
        key: "settings_share_profile_image", value: value ? "true" : "false");
  }

  Future<bool> getShareStatus() async {
    final bool shareStatus =
        await _storage.read(key: "settings_share_status") == "true";
    return shareStatus;
  }

  Future<void> setShareStatus(bool value) async {
    await _storage.write(
        key: "settings_share_status", value: value ? "true" : "false");
  }

  Future<bool> getShareReadReceipts() async {
    final bool shareReadReceipts =
        await _storage.read(key: "settings_share_read_receipts") == "true";
    return shareReadReceipts;
  }

  Future<void> setShareReadReceipts(bool value) async {
    await _storage.write(
        key: "settings_share_read_receipts", value: value ? "true" : "false");
  }

  Future<bool> getShowNotifications() async {
    final bool showNotifications =
        await _storage.read(key: "settings_show_notifications") == "true";
    return showNotifications;
  }

  Future<void> setShowNotifications(bool value) async {
    await _storage.write(
        key: "settings_show_notifications", value: value ? "true" : "false");
  }

  Future<bool> getPlayNotificationSound() async {
    final bool playNotificationSound =
        await _storage.read(key: "settings_play_notifications_sound") == "true";
    return playNotificationSound;
  }

  Future<void> setPlayNotificationSound(bool value) async {
    await _storage.write(
        key: "settings_play_notifications_sound",
        value: value ? "true" : "false");
  }

  Future<bool> getShowMessagePreview() async {
    final bool showMessagePreview =
        await _storage.read(key: "settings_show_message_preview") == "true";
    return showMessagePreview;
  }

  Future<void> setShowMessagePreview(bool value) async {
    await _storage.write(
        key: "settings_show_message_preview", value: value ? "true" : "false");
  }

  Future<bool> getAutoDownloadMedia() async {
    final bool autoDownloadMedia =
        await _storage.read(key: "settings_auto_download_media") == "true";
    return autoDownloadMedia;
  }

  Future<void> setAutoDownloadMedia(bool value) async {
    await _storage.write(
        key: "settings_auto_download_media", value: value ? "true" : "false");
  }

  Future<String?> getWallpaperImage() async {
    return await _storage.read(key: "settings_wallpaper");
  }

  Future<void> setWallpaperImage(String imageBase64) async {
    await _storage.write(key: "settings_wallpaper", value: imageBase64);
  }
}
