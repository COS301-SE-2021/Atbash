import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SettingsService {
  final _storage = FlutterSecureStorage();

  Future<bool> getEditableSettings() async {
    final editableSettings =
        await _storage.read(key: "settings_editable_settings");
    if (editableSettings == null)
      return false;
    else if (editableSettings == "true")
      return true;
    else
      return false;
  }

  Future<void> setEditableSettings(bool value) async {
    await _storage.write(
        key: "settings_editable_settings", value: value ? "true" : "false");
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

  Future<bool> getShareBirthday() async {
    final bool shareBirthday =
        await _storage.read(key: "settings_share_birthday") == "true";
    return shareBirthday;
  }

  Future<void> setShareBirthday(bool value) async {
    await _storage.write(
        key: "settings_share_birthday", value: value ? "true" : "false");
  }

  Future<bool> getDisableNotifications() async {
    final bool showNotifications =
        await _storage.read(key: "settings_show_notifications") == "true";
    return showNotifications;
  }

  Future<void> setDisableNotifications(bool value) async {
    await _storage.write(
        key: "settings_show_notifications", value: value ? "true" : "false");
  }

  Future<bool> getDisableMessagePreview() async {
    final bool showMessagePreview =
        await _storage.read(key: "settings_show_message_preview") == "true";
    return showMessagePreview;
  }

  Future<void> setDisableMessagePreview(bool value) async {
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

  Future<bool> getLockedAccount() async {
    final lockedAccount = await _storage.read(key: "settings_locked_account");

    if (lockedAccount == null)
      return false;
    else if (lockedAccount == "true")
      return true;
    else
      return false;
  }

  Future<void> setLockedAccount(bool value) async {
    await _storage.write(
        key: "settings_locked_account", value: value ? "true" : "false");
  }

  Future<bool> getPrivateChatAccess() async {
    final bool privateChatAccess =
        await _storage.read(key: "settings_private_chat_access") == "true";
    return privateChatAccess;
  }

  Future<void> setPrivateChatAccess(bool value) async {
    await _storage.write(
        key: "settings_private_chat_access", value: value ? "true" : "false");
  }

  Future<bool> getBlockSaveMedia() async {
    final bool blockSaveMedia =
        await _storage.read(key: "settings_block_save_media") == "true";
    return blockSaveMedia;
  }

  Future<void> setBlockSaveMedia(bool value) async {
    await _storage.write(
        key: "settings_block_save_media", value: value ? "true" : "false");
  }

  Future<bool> getBlockEditingMessages() async {
    final bool blockEditingMessages =
        await _storage.read(key: "settings_block_editing_messages") == "true";
    return blockEditingMessages;
  }

  Future<void> setBlockEditingMessages(bool value) async {
    await _storage.write(
        key: "settings_block_editing_messages",
        value: value ? "true" : "false");
  }

  Future<bool> getBlockDeletingMessages() async {
    final bool blockDeletingMessages =
        await _storage.read(key: "settings_block_deleting_messages") == "true";
    return blockDeletingMessages;
  }

  Future<void> setBlockDeletingMessages(bool value) async {
    await _storage.write(
        key: "settings_block_deleting_messages",
        value: value ? "true" : "false");
  }
}
