import 'package:mobx/mobx.dart';

part 'ParentalSettingsPageModel.g.dart';

class ParentalSettingsPageModel = _ParentalSettingsPageModel
    with _$ParentalSettingsPageModel;

abstract class _ParentalSettingsPageModel with Store {
  @observable
  ObservableList<String> childrenNames = <String>[].asObservable();

  @observable
  bool editableSettings = false;

  @observable
  bool blurImages = false;

  @observable
  bool safeMode = false;

  @observable
  bool shareProfilePicture = false;

  @observable
  bool shareStatus = false;

  @observable
  bool shareReadReceipts = false;

  @observable
  bool shareBirthday = false;

  @observable
  bool lockedAccount = false;

  @observable
  bool privateChatAccess = false;

  @observable
  bool blockSaveMedia = false;

  @observable
  bool blockEditingMessages = false;

  @observable
  bool blockDeletingMessages = false;
}