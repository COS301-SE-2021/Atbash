import 'package:mobile/domain/StoredProfanityWord.dart';
import 'package:mobile/services/DatabaseService.dart';
import 'package:mobile/util/RegexGeneration.dart';
import 'package:uuid/uuid.dart';

class StoredProfanityWordService {
  final DatabaseService databaseService;

  StoredProfanityWordService(this.databaseService);

  Future<List<StoredProfanityWord>> fetchAll() async {
    final db = await databaseService.database;

    final response = await db.query(StoredProfanityWord.TABLE_NAME);

    final storedProfanityWords = <StoredProfanityWord>[];
    response.forEach((e) {
      final profanityWordRegex = StoredProfanityWord.fromMap(e);
      if (profanityWordRegex != null)
        storedProfanityWords.add(profanityWordRegex);
    });

    return storedProfanityWords;
  }

  Future<StoredProfanityWord> addWord(
      String word, String packageName, bool removable) async {
    final db = await databaseService.database;

    final storedProfanityWord = StoredProfanityWord(
        id: Uuid().v4(),
        packageName: packageName,
        word: word,
        regex: generateRegex(word),
        removable: removable);

    await db.transaction((txn) async {
      final wordAlreadyExists = await txn.query(StoredProfanityWord.TABLE_NAME,
          where:
              "${StoredProfanityWord.COLUMN_WORD} = ? AND ${StoredProfanityWord.COLUMN_PACKAGE_NAME} = ?",
          whereArgs: [
            storedProfanityWord.word,
            storedProfanityWord.packageName
          ]);

      if (wordAlreadyExists.isNotEmpty)
        throw StoredProfanityWordAlreadyExistsException();

      txn.insert(StoredProfanityWord.TABLE_NAME, storedProfanityWord.toMap());
    });

    return storedProfanityWord;
  }

  Future<void> deleteByWordAndPackage(String word, String package) async {
    final db = await databaseService.database;

    db.delete(StoredProfanityWord.TABLE_NAME,
        where:
            "${StoredProfanityWord.COLUMN_WORD} =? AND ${StoredProfanityWord.COLUMN_PACKAGE_NAME} = ?",
        whereArgs: [word, package]);
  }

  Future<void> deleteByID(String id) async {
    final db = await databaseService.database;

    db.delete(StoredProfanityWord.TABLE_NAME,
        where: "${StoredProfanityWord.COLUMN_ID} =?", whereArgs: [id]);
  }
}

class StoredProfanityWordAlreadyExistsException {}
