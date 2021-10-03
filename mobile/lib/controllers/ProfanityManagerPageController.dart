import 'package:get_it/get_it.dart';
import 'package:mobile/domain/ProfanityWord.dart';
import 'package:mobile/models/ProfanityManagerPageModel.dart';
import 'package:mobile/services/ProfanityWordService.dart';

class ProfanityManagerPageController {
  final ProfanityWordService profanityWordService = GetIt.I.get();

  final ProfanityManagerPageModel model = ProfanityManagerPageModel();

  ProfanityManagerPageController() {
    reload();
  }

  void reload() {
    profanityWordService.fetchAll().then((profanityWords) {
      model.profanityWords.clear();
      model.profanityWords.addAll(profanityWords);
    });
    profanityWordService.fetchAllGroupByPackage().then((packageCounts) {
      model.packageCounts.clear();
      model.packageCounts.addAll(packageCounts);
    });
  }

  void addWord(String word, String packageName) {
    profanityWordService
        .addWord(word, packageName)
        .then((value) => reload())
        .catchError((_) {});
  }

  void deleteWord(ProfanityWord profanityWord) {
    profanityWordService.deleteByID(profanityWord.id).then((value) => reload());
  }

  void deletePackage(String packageName) {
    profanityWordService.deleteByPackage(packageName).then((value) => reload());
  }
}
