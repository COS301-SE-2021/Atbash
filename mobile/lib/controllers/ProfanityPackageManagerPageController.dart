import 'package:get_it/get_it.dart';
import 'package:mobile/domain/StoredProfanityWord.dart';
import 'package:mobile/models/ProfanityPackageManagerPageModel.dart';
import 'package:mobile/services/ProfanityWordService.dart';
import 'package:mobile/services/StoredProfanityWordService.dart';

class ProfanityPackageManagerPageController {
  final ProfanityWordService profanityWordService = GetIt.I.get();
  final StoredProfanityWordService storedProfanityWordService = GetIt.I.get();

  final ProfanityPackageManagerPageModel model =
      ProfanityPackageManagerPageModel();

  ProfanityPackageManagerPageController() {
    reload();
  }

  void reload() {
    profanityWordService.fetchAll().then((profanityWords) {
      model.profanityWords.clear();
      model.profanityWords.addAll(profanityWords);
    });
    storedProfanityWordService.fetchAll().then((storedProfanityWords) {
      model.storedProfanityWords.clear();
      model.storedProfanityWords.addAll(storedProfanityWords);
    });
    storedProfanityWordService.fetchAllGroupByPackage(true).then((value) {
      model.packageCountsGeneral.clear();
      model.packageCountsGeneral.addAll(value);
    });
    storedProfanityWordService.fetchAllGroupByPackage(false).then((value) {
      model.packageCountsCreated.clear();
      model.packageCountsCreated.addAll(value);
    });
  }

  void addPackage(List<StoredProfanityWord> words) {
    words.forEach((word) {
      final wordAlreadyExists = model.profanityWords.where((element) =>
          element.packageName.toLowerCase() == word.packageName.toLowerCase() &&
          element.word.toLowerCase() == word.word.toLowerCase());

      if (wordAlreadyExists.isEmpty)
        profanityWordService
            .addWord(word.word, word.packageName)
            .catchError((_) {});
    });
  }
}
