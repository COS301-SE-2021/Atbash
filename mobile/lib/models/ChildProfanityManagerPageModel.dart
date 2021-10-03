import 'package:mobile/domain/ChildProfanityWord.dart';
import 'package:mobile/util/Tuple.dart';
import 'package:mobx/mobx.dart';

part 'ChildProfanityManagerPageModel.g.dart';

class ChildProfanityManagerPageModel = _ChildProfanityManagerPageModel with _$ChildProfanityManagerPageModel;

abstract class _ChildProfanityManagerPageModel with Store{
  @observable
  ObservableList<ChildProfanityWord> profanityWords = <ChildProfanityWord>[].asObservable();

  @observable
  ObservableList<Tuple<int, String>> packageCounts =
  <Tuple<int, String>>[].asObservable();

  @observable
  String filter = "";

  @computed
  ObservableList<ChildProfanityWord> get filteredProfanityWords => profanityWords
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