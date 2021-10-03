import 'package:mobile/domain/ChildProfanityWord.dart';
import 'package:mobile/domain/StoredProfanityWord.dart';
import 'package:mobile/util/Tuple.dart';
import 'package:mobx/mobx.dart';

part 'ChildProfanityPackageManagerPageModel.g.dart';

class ChildProfanityPackageManagerPageModel = _ChildProfanityPackageManagerPageModel
    with _$ChildProfanityPackageManagerPageModel;

abstract class _ChildProfanityPackageManagerPageModel with Store {
  @observable
  ObservableList<ChildProfanityWord> childProfanityWords =
      <ChildProfanityWord>[].asObservable();

  @observable
  ObservableList<StoredProfanityWord> storedProfanityWords =
      <StoredProfanityWord>[].asObservable();

  @observable
  ObservableList<Tuple<int, String>> packageCounts =
      <Tuple<int, String>>[].asObservable();
}
