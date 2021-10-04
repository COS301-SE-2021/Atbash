import 'package:get_it/get_it.dart';
import 'package:mobile/domain/ProfanityWord.dart';
import 'package:mobile/domain/StoredProfanityWord.dart';
import 'package:mobile/services/ChildProfanityWordService.dart';
import 'package:mobile/services/CommunicationService.dart';
import 'package:mobile/services/StoredProfanityWordService.dart';
import 'package:mobile/models/ChildProfanityPackageManagerPageModel.dart';
import 'package:mobile/util/RegexGeneration.dart';
import 'package:uuid/uuid.dart';

class ChildProfanityPackageManagerPageController {
  final childNumber;
  final StoredProfanityWordService storedProfanityWordService = GetIt.I.get();
  final ChildProfanityWordService childProfanityWordService = GetIt.I.get();
  final CommunicationService communicationService = GetIt.I.get();

  final ChildProfanityPackageManagerPageModel model =
      ChildProfanityPackageManagerPageModel();

  ChildProfanityPackageManagerPageController({required this.childNumber}) {
    reload();
  }

  void reload() {
    childProfanityWordService
        .fetchAllWordsByChildNumber(childNumber)
        .then((profanityWords) {
      model.childProfanityWords.clear();
      model.childProfanityWords.addAll(profanityWords);
    });
    storedProfanityWordService.fetchAll().then((storedProfanityWords) {
      model.storedProfanityWords.clear();
      model.storedProfanityWords.addAll(storedProfanityWords);
    });
    storedProfanityWordService.fetchAllGroupByPackage(true).then(
        (generalStoredWords) => storedProfanityWordService
                .fetchAllGroupByPackage(false)
                .then((createdStoredWords) {
              model.packageCounts.clear();
              model.packageCounts.addAll(generalStoredWords);
              model.packageCounts.addAll(createdStoredWords);
            }));
  }

  void addPackage(List<StoredProfanityWord> words) {
    final sentProfanityWords = <ProfanityWord>[];
    words.forEach((word) {
      final wordAlreadyExists = model.childProfanityWords.where((element) =>
          element.packageName.toLowerCase() == word.packageName.toLowerCase() &&
          element.word.toLowerCase() == word.word.toLowerCase());

      if (wordAlreadyExists.isEmpty) {
        childProfanityWordService
            .insert(childNumber, word.word, word.packageName, Uuid().v4())
            .catchError((_) {});
        final profanityWord = ProfanityWord(
            id: Uuid().v4(),
            packageName: word.packageName,
            word: word.word,
            regex: generateRegex(word.word),
            addedByParent: true);
        sentProfanityWords.add(profanityWord);
      }

      communicationService.sendNewProfanityWordToChild(
          childNumber, sentProfanityWords, "insert");
    });
  }
}
