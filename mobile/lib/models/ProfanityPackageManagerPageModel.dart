import 'package:mobile/domain/ProfanityWord.dart';
import 'package:mobile/domain/StoredProfanityWord.dart';
import 'package:mobile/util/Tuple.dart';
import 'package:mobx/mobx.dart';

part 'ProfanityPackageManagerPageModel.g.dart';

class ProfanityPackageManagerPageModel = _ProfanityPackageManagerPageModel
    with _$ProfanityPackageManagerPageModel;

abstract class _ProfanityPackageManagerPageModel with Store {
  @observable
  ObservableList<ProfanityWord> profanityWords =
      <ProfanityWord>[].asObservable();

  @observable
  ObservableList<StoredProfanityWord> storedProfanityWords =
      <StoredProfanityWord>[].asObservable();

  @observable
  ObservableList<Tuple<int, String>> packageCountsGeneral =
      <Tuple<int, String>>[].asObservable();

  @observable
  ObservableList<Tuple<int, String>> packageCountsCreated =
      <Tuple<int, String>>[].asObservable();
}
