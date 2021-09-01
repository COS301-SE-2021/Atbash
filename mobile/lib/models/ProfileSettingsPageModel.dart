import 'dart:typed_data';

import 'package:mobx/mobx.dart';

part 'ProfileSettingsPageModel.g.dart';

class ProfileSettingsPageModel = _ProfileSettingsPageModel
    with _$ProfileSettingsPageModel;

abstract class _ProfileSettingsPageModel with Store {
  @observable
  String phoneNumber = "";

  @observable
  String displayName = "";

  @observable
  String status = "";

  @observable
  DateTime? birthday;

  @observable
  Uint8List? profilePicture;
}
