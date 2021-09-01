import 'dart:typed_data';

import 'package:mobx/mobx.dart';

part 'SettingsPageModel.g.dart';

class SettingsPageModel = _SettingsPageModel with _$SettingsPageModel;

abstract class _SettingsPageModel with Store {
  @observable
  String userName = "";

  @observable
  String userStatus = "";

  @observable
  Uint8List? userProfilePicture = Uint8List(0);

  @observable
  bool blurImages = false;

  @observable
  bool safeMode = false;

  @observable
  bool sharedProfilePicture = false;

  @observable
  bool shareStatus = false;

  @observable
  bool shareReadReceipts = false;

  @observable
  bool showNotifications = false;

  @observable
  bool playNotificationSound = false;

  @observable
  bool showMessagePreview = false;

  @observable
  bool autoDownloadMedia = false;

  //TODO add pin
  // @observable
  // String pin = "";
}