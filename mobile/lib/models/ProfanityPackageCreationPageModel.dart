import 'package:mobx/mobx.dart';

part 'ProfanityPackageCreationPageModel.g.dart';

class ProfanityPackageCreationPageModel = _ProfanityPackageCreationPageModel
    with _$ProfanityPackageCreationPageModel;

abstract class _ProfanityPackageCreationPageModel with Store {
  @observable
  ObservableList<String> storedProfanityWords = <String>[].asObservable();
}
