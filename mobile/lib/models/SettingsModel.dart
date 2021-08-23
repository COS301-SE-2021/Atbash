import 'package:mobx/mobx.dart';
import 'package:mobx/mobx.dart';

part 'SettingsModel.g.dart';

class ChatListModel = _ChatListModel with _$ChatListModel;

abstract class _ChatListModel with Store {
  @observable
  bool blurImages;

  @observable
  bool safeMode;

  @observable
  bool shareProfileImage;

  @observable
  bool shareStatus;

  @observable
  bool shareReadReceipts;

  @observable
  bool showNotifications;

  @observable
  bool playNotificationsSound;

  @observable
  bool showMessagePreview;

  @observable
  bool autoDownloadMedia;

  @observable
  ObservableList<String> blockedNumbers = <String>[].asObservable();
}
