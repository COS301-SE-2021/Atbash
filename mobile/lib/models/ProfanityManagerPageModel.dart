import 'package:mobile/domain/ProfanityWord.dart';
import 'package:mobile/util/Tuple.dart';
import 'package:mobx/mobx.dart';

part 'ProfanityManagerPageModel.g.dart';

class ProfanityManagerPageModel = _ProfanityManagerPageModel
    with _$ProfanityManagerPageModel;

abstract class _ProfanityManagerPageModel with Store {
  @observable
  ObservableList<ProfanityWord> profanityWords =
      <ProfanityWord>[].asObservable();

  @observable
  ObservableList<Tuple<int, String>> packageCounts =
      <Tuple<int, String>>[].asObservable();

  @observable
  String filter = "";

  @computed
  ObservableList<ProfanityWord> get filteredProfanityWords => profanityWords
      .where((profanityWord) =>
          profanityWord.word.toLowerCase().contains(filter.toLowerCase()) ||
          profanityWord.packageName
              .toLowerCase()
              .contains(filter.toLowerCase()))
      .toList()
      .asObservable();

  @computed
  ObservableList<Tuple<int, String>> get filteredPackageCounts => packageCounts
      .where((packageCount) =>
          packageCount.second.toLowerCase().contains(filter.toLowerCase()))
      .toList()
      .asObservable();
}
