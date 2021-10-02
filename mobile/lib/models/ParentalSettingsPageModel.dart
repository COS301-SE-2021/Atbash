import 'package:mobile/domain/Child.dart';
import 'package:mobile/util/Tuple.dart';
import 'package:mobx/mobx.dart';

part 'ParentalSettingsPageModel.g.dart';

class ParentalSettingsPageModel = _ParentalSettingsPageModel
    with _$ParentalSettingsPageModel;

abstract class _ParentalSettingsPageModel with Store {
  @observable
  ObservableList<Tuple<Child, bool>> children =
      <Tuple<Child, bool>>[].asObservable();

  @observable
  int index = 0;

  @observable
  String parentName = "";
}
