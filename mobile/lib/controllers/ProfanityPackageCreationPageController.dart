import 'package:get_it/get_it.dart';
import 'package:mobile/services/StoredProfanityWordService.dart';
import 'package:mobile/models/ProfanityPackageCreationPageModel.dart';

class ProfanityPackageCreationPageController {
  final StoredProfanityWordService storedProfanityWordService = GetIt.I.get();
  final ProfanityPackageCreationPageModel model =
      ProfanityPackageCreationPageModel();

  void addWord(String word) {
    if (!model.storedProfanityWords
        .any((element) => element.toLowerCase() == word.toLowerCase()))
      model.storedProfanityWords.add(word);
  }

  void removeWord(String word) {
    model.storedProfanityWords
        .removeWhere((element) => element.toLowerCase() == word.toLowerCase());
  }

  void createPackage(String packageName) {
    model.storedProfanityWords.forEach((word) {
      storedProfanityWordService.addWord(word, packageName, true);
    });
  }
}
