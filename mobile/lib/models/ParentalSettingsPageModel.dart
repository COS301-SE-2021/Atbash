import 'package:mobile/domain/Child.dart';
import 'package:mobile/util/Tuple.dart';
import 'package:mobx/mobx.dart';

part 'ParentalSettingsPageModel.g.dart';

class ParentalSettingsPageModel = _ParentalSettingsPageModel
    with _$ParentalSettingsPageModel;

abstract class _ParentalSettingsPageModel with Store {
  @observable
  ObservableList<Tuple<Child, bool>> children = <Tuple<Child, bool>>[].asObservable();

  @observable
  int currentlySelected = 0;

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
