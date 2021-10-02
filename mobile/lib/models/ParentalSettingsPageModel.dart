import 'package:mobile/domain/Child.dart';
import 'package:mobx/mobx.dart';

part 'ParentalSettingsPageModel.g.dart';

class ParentalSettingsPageModel = _ParentalSettingsPageModel
    with _$ParentalSettingsPageModel;

abstract class _ParentalSettingsPageModel with Store {
  @observable
  ObservableList<Child> children =
      <Child>[].asObservable();

  @observable
  int index = 0;

  @observable
  String parentName = "";
}
