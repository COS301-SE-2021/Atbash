import 'package:get_it/get_it.dart';
import 'package:mobile/models/SettingsPageModel.dart';
import 'package:mobile/services/SettingsService.dart';
import 'package:mobile/services/UserService.dart';

class SettingsPageController {
  final SettingsService settingsService = GetIt.I.get();
  final UserService userService = GetIt.I.get();

  final SettingsPageModel model = SettingsPageModel();

  SettingsPageController() {
    userService.getDisplayName().then((value) => model.userName = value);
    userService.getStatus().then((value) => model.userStatus = value);
    userService.getProfileImage().then((value) => model.userProfilePicture = value);
    settingsService.getBlurImages().then((value) => model.blurImages = value);
    settingsService.getSafeMode().then((value) => model.safeMode = value);
    settingsService
        .getShareProfilePicture()
        .then((value) => model.sharedProfilePicture = value);
    settingsService.getShareStatus().then((value) => model.shareStatus = value);
    settingsService
        .getShareReadReceipts()
        .then((value) => model.shareReadReceipts = value);
    settingsService
        .getShowNotifications()
        .then((value) => model.showNotifications = value);
    settingsService
        .getPlayNotificationSound()
        .then((value) => model.playNotificationSound = value);
    settingsService
        .getShowMessagePreview()
        .then((value) => model.showMessagePreview = value);
    settingsService
        .getAutoDownloadMedia()
        .then((value) => model.autoDownloadMedia = value);
    //TODO Set model pin
  }

  //TODO create function to change pin

  void setBlurImages(bool value) {
    model.blurImages = value;
    settingsService.setBlurImages(value);
  }

  void setSafeMode(bool value, String pin) {
    //TODO Check if pin is correct
    model.safeMode = value;
    settingsService.setSafeMode(value);
  }

  void setSharedProfilePicture(bool value) {
    model.sharedProfilePicture = value;
    settingsService.setShareProfilePicture(value);
  }

  void setShareStatus(bool value) {
    model.shareStatus = value;
    settingsService.setShareStatus(value);
  }

  void setShareReadReceipts(bool value) {
    model.shareReadReceipts = value;
    settingsService.setShareReadReceipts(value);
  }

  void setShowNotifications(bool value) {
    model.showNotifications = value;
    settingsService.setShowNotifications(value);
  }

  void setPlayNotificationSound(bool value) {
    model.playNotificationSound = value;
    settingsService.setPlayNotificationSound(value);
  }

  void setShowMessagePreview(bool value) {
    model.showMessagePreview = value;
    settingsService.setShowMessagePreview(value);
  }

  void setAutoDownloadMedia(bool value) {
    model.autoDownloadMedia = value;
    settingsService.setAutoDownloadMedia(value);
  }
}
