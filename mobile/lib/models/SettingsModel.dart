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
}
