import 'package:mobile/domain/StoredProfanityWord.dart';
import 'package:mobile/services/DatabaseService.dart';
import 'package:mobile/util/RegexGeneration.dart';
import 'package:mobile/util/Tuple.dart';
import 'package:uuid/uuid.dart';

class StoredProfanityWordService {
  final DatabaseService databaseService;

  StoredProfanityWordService(this.databaseService);

  Future<List<StoredProfanityWord>> fetchAll() async {
    final db = await databaseService.database;

    final response = await db.query(StoredProfanityWord.TABLE_NAME,
        where: "${StoredProfanityWord.COLUMN_DOWNLOADED} = ?", whereArgs: [1]);

    final storedProfanityWords = <StoredProfanityWord>[];
    response.forEach((e) {
      final profanityWordRegex = StoredProfanityWord.fromMap(e);
      if (profanityWordRegex != null)
        storedProfanityWords.add(profanityWordRegex);
    });

    return storedProfanityWords;
  }

  Future<StoredProfanityWord> addWord(
      String word, String packageName, bool removable,
      {bool downloaded = true}) async {
    final db = await databaseService.database;

    final storedProfanityWord = StoredProfanityWord(
        id: Uuid().v4(),
        packageName: packageName,
        word: word,
        regex: generateRegex(word),
        removable: removable,
        downloaded: downloaded);

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

  Future<List<Tuple<int, String>>> fetchAllGroupByPackage(bool general) async {
    final db = await databaseService.database;

    final response = await db.rawQuery(
        "SELECT COUNT(${StoredProfanityWord.COLUMN_ID}) AS package_count,${StoredProfanityWord.COLUMN_PACKAGE_NAME} "
        "FROM ${StoredProfanityWord.TABLE_NAME} "
        "WHERE ${StoredProfanityWord.COLUMN_REMOVABLE} = ${general ? 0 : 1} AND ${StoredProfanityWord.COLUMN_DOWNLOADED} = 1 "
        "GROUP BY ${StoredProfanityWord.COLUMN_PACKAGE_NAME} "
        "ORDER BY ${StoredProfanityWord.COLUMN_PACKAGE_NAME} COLLATE NOCASE"
        ";");

    final packageCounts = <Tuple<int, String>>[];

    response.forEach((element) {
      final packageCount = Tuple(element["package_count"] as int,
          element[StoredProfanityWord.COLUMN_PACKAGE_NAME] as String);
      packageCounts.add(packageCount);
    });

    return packageCounts;
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
