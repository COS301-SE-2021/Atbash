import 'package:mobile/domain/ProfanityWord.dart';
import 'package:mobile/services/DatabaseService.dart';
import 'package:uuid/uuid.dart';

class ProfanityWordService {
  final DatabaseService databaseService;

  ProfanityWordService(this.databaseService);

  Future<List<ProfanityWord>> fetchAll() async {
    final db = await databaseService.database;

    final response = await db.query(ProfanityWord.TABLE_NAME);

    final profanityWords = <ProfanityWord>[];
    response.forEach((e) {
      final profanityWordRegex = ProfanityWord.fromMap(e);
      if (profanityWordRegex != null) profanityWords.add(profanityWordRegex);
    });

    return profanityWords;
  }

  Future<ProfanityWord> addWord(String baseWord) async {
    final db = await databaseService.database;

    //logic for profanity variations
    String newWord = baseWord.replaceAll(RegExp(r'e'), '[e3]');
    newWord = newWord.replaceAll(RegExp(r's'), '[s\$]');
    newWord = newWord.replaceAll(RegExp(r'a'), '[a@]');
    newWord = newWord.replaceAll(RegExp(r'l'), '[l1]');
    newWord = newWord.replaceAll(RegExp(r'i'), '[i!]');
    newWord = newWord.replaceAll(RegExp(r'o'), '[o0]');
    newWord = newWord.replaceAll(RegExp(r't'), '[t+]');

    final profanityWord = ProfanityWord(
        profanityWordRegex: newWord,
        profanityID: Uuid().v4(),
        profanityOriginalWord: baseWord);

    await db.insert(ProfanityWord.TABLE_NAME, profanityWord.toMap());

    return profanityWord;
  }

  Future<void> deleteByID(String id) async {
    final db = await databaseService.database;

    db.delete(ProfanityWord.TABLE_NAME,
        where: "${ProfanityWord.COLUMN_PROFANITY_ID} =?", whereArgs: [id]);
  }

  //HELPER FUNCTION TO MANIPULATE STRING
  String replaceCharAt(String oldString, int index, String newChar) {
    return oldString.substring(0, index) +
        newChar +
        oldString.substring(index + 1);
  }
}
