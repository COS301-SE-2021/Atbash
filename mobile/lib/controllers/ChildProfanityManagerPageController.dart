import 'package:get_it/get_it.dart';
import 'package:mobile/domain/ChildProfanityWord.dart';
import 'package:mobile/domain/ProfanityWord.dart';
import 'package:mobile/models/ChildProfanityManagerPageModel.dart';
import 'package:mobile/services/ChildProfanityWordService.dart';
import 'package:mobile/services/CommunicationService.dart';
import 'package:mobile/util/RegexGeneration.dart';
import 'package:uuid/uuid.dart';

class ChildProfanityManagerPageController {
  final ChildProfanityWordService childProfanityWordService = GetIt.I.get();

  final CommunicationService communicationService = GetIt.I.get();

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
      print(model.profanityWords.length);
    });
    childProfanityWordService
        .fetchAllGroupByPackage(childNumber)
        .then((packageCounts) {
      model.packageCounts.clear();
      model.packageCounts.addAll(packageCounts);
      print(model.packageCounts.length);
    });
  }

  void addWord(String word, String packageName) {
    childProfanityWordService
        .insert(childNumber, word, packageName, Uuid().v4())
        .then((value) => reload)
        .catchError((_) {});
    final words = <ProfanityWord>[];
    words.add(ProfanityWord(
        id: Uuid().v4(),
        word: word,
        packageName: packageName,
        regex: generateRegex(word),
        addedByParent: true));
    communicationService.sendNewProfanityWordToChild(
        childNumber, words, "insert");
  }

  void deleteWord(ChildProfanityWord profanityWord) {
    final words = <ProfanityWord>[];
    words.add(ProfanityWord(
        id: profanityWord.id,
        packageName: profanityWord.packageName,
        word: profanityWord.word,
        regex: profanityWord.regex,
        addedByParent: true));
    communicationService.sendNewProfanityWordToChild(
        childNumber, words, "delete");
    childProfanityWordService.deleteByNumberAndID(
        childNumber, profanityWord.id);
  }

  void deletePackage(String packageName) {
    final words = <ProfanityWord>[];
    childProfanityWordService
        .fetchAllWordsByChildNumber(childNumber)
        .then((cWords) {
      cWords.forEach((profanityWord) {
        if (profanityWord.packageName.toLowerCase() ==
            packageName.toLowerCase())
          words.add(ProfanityWord(
              id: profanityWord.id,
              packageName: profanityWord.packageName,
              word: profanityWord.word,
              regex: profanityWord.regex,
              addedByParent: true));
      });
      communicationService.sendNewProfanityWordToChild(
          childNumber, words, "delete");
    });

    childProfanityWordService.deleteByChildNumberAndPackageName(
        childNumber, packageName);
  }
}
