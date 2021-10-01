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

  Future<ProfanityWord> addWord(String baseWord,
      {bool addedByParent = false}) async {
    final db = await databaseService.database;

    //logic for profanity variations
    String newWord = baseWord.replaceAll(RegExp(r'e'), '[e3]');
    newWord = newWord.replaceAll(RegExp(r's'), '[s\$]');
    newWord = newWord.replaceAll(RegExp(r'a'), '[a@]');
    newWord = newWord.replaceAll(RegExp(r'l'), '[l1]');
    newWord = newWord.replaceAll(RegExp(r'i'), '[i!]');
    newWord = newWord.replaceAll(RegExp(r'o'), '[o0]');
    newWord = newWord.replaceAll(RegExp(r't'), '[t+]');
    newWord = newWord.replaceAll(RegExp(r'f'), '(ph|f)');
    newWord = newWord.replaceAll(RegExp(r'ph'), '(ph|f)');
    newWord = newWord.replaceAll(RegExp(r'a'), '(a|er)');
    newWord = newWord.replaceAll(RegExp(r'er'), '(a|er)');

    final profanityWord = ProfanityWord(
        profanityWordRegex: newWord,
        profanityID: Uuid().v4(),
        profanityOriginalWord: baseWord,
        addedByParent: addedByParent);

    await db.transaction((txn) async {
      final wordAlreadyExists = await txn.query(ProfanityWord.TABLE_NAME,
          where: "${ProfanityWord.COLUMN_PROFANITY_ID} = ?",
          whereArgs: [
            profanityWord.profanityID,
          ]);

      if (wordAlreadyExists.isNotEmpty)
        throw ProfanityWordAlreadyExistsException();

      txn.insert(ProfanityWord.TABLE_NAME, profanityWord.toMap());
    });

    await db.insert(ProfanityWord.TABLE_NAME, profanityWord.toMap());

    return profanityWord;
  }

  Future<void> deleteByWord(String word) async {
    final db = await databaseService.database;

    db.delete(ProfanityWord.TABLE_NAME,
        where: "${ProfanityWord.COLUMN_PROFANITY_ORIGINAL_WORD} =?",
        whereArgs: [word]);
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

class ProfanityWordAlreadyExistsException implements Exception {}
