import 'package:mobx/mobx.dart';
import 'package:mobx/mobx.dart';

part 'SettingsModel.g.dart';

class ChatListModel = _ChatListModel with _$ChatListModel;

abstract class _ChatListModel with Store {
  @observable
  bool blurImages = false;

  @observable
  bool safeMode = false;

  @observable
  bool shareProfileImage = true;

  @observable
  bool shareStatus = true;

  @observable
  bool shareReadReceipts = true;

  @observable
  bool showNotifications = true;

  @observable
  bool playNotificationsSound = true;

  @observable
  bool showMessagePreview = false;

  @observable
  bool autoDownloadMedia = false;

  @observable
  ObservableList<String> blockedNumbers = <String>[].asObservable();

  @action
  void setSafeMode(bool safeMode, String pin) {
    //TODO: set pin variable
    //if(pin is correct)
    this.safeMode = safeMode;
  }

  @action
  void setBlurImages(bool value) {
    this.blurImages = value;
  }

  @action
  void setShareProfileImage(bool value) {
    this.shareProfileImage = value;
  }

  @action
  void setShareStatus(bool value) {
    this.shareStatus = value;
  }

  @action
  void setShareReadReceipts(bool value) {
    this.shareReadReceipts = value;
  }

  @action
  void setShowNotifications(bool value) {
    this.showNotifications = value;
  }

  @action
  void setPlayNotificationsSound(bool value) {
    this.playNotificationsSound = value;
  }

  @action
  void setShowMessagePreview(bool value) {
    this.showMessagePreview = value;
  }

  @action
  void setAutoDownloadMedia(bool value) {
    this.autoDownloadMedia = value;
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
