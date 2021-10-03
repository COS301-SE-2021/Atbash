import 'package:get_it/get_it.dart';
import 'package:mobile/domain/ChildProfanityWord.dart';
import 'package:mobile/models/ChildProfanityManagerPageModel.dart';
import 'package:mobile/services/ChildProfanityWordService.dart';
import 'package:uuid/uuid.dart';

class ChildProfanityManagerPageController {
  final ChildProfanityWordService childProfanityWordService = GetIt.I.get();

  final ChildProfanityManagerPageModel model = ChildProfanityManagerPageModel();

  final childNumber;

  ChildProfanityManagerPageController({required this.childNumber}) {
    reload();
  }

  void reload() {
    childProfanityWordService
        .fetchAllWordsByChildNumber(childNumber)
        .then((profanityWords) {
      model.profanityWords.clear();
      model.profanityWords.addAll(profanityWords);
    });
    childProfanityWordService
        .fetchAllGroupByPackage(childNumber)
        .then((packageCounts) {
      model.packageCounts.clear();
      model.packageCounts.addAll(packageCounts);
    });
  }

  void addWord(String word, String packageName) {
    childProfanityWordService
        .insert(childNumber, word, packageName, Uuid().v4())
        .then((value) => reload)
        .catchError((_) {});
  }

  void deleteWord(ChildProfanityWord profanityWord) {
    childProfanityWordService.deleteByNumberAndID(
        childNumber, profanityWord.id);
  }

  void deletePackage(String packageName) {
    childProfanityWordService.deleteByChildNumberAndPackageName(
        childNumber, packageName);
  }
}
