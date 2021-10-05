import 'package:mobile/domain/ProfanityWord.dart';
import 'package:mobile/services/DatabaseService.dart';
import 'package:mobile/util/RegexGeneration.dart';
import 'package:mobile/util/Tuple.dart';
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

  Future<List<Tuple<int, String>>> fetchAllGroupByPackage() async {
    final db = await databaseService.database;

    final response = await db.rawQuery(
        "SELECT COUNT(${ProfanityWord.COLUMN_ID}) AS package_count,${ProfanityWord.COLUMN_PACKAGE_NAME} "
        "FROM ${ProfanityWord.TABLE_NAME} "
        "GROUP BY ${ProfanityWord.COLUMN_PACKAGE_NAME} "
        "ORDER BY ${ProfanityWord.COLUMN_PACKAGE_NAME} COLLATE NOCASE"
        ";");

    final packageCounts = <Tuple<int, String>>[];

    response.forEach((element) {
      final packageCount = Tuple(element["package_count"] as int,
          element[ProfanityWord.COLUMN_PACKAGE_NAME] as String);
      packageCounts.add(packageCount);
    });

    return packageCounts;
  }

  Future<ProfanityWord> addWord(String word, String packageName,
      {bool addedByParent = false}) async {
    final db = await databaseService.database;

    String regex = generateRegex(word);

    final profanityWord = ProfanityWord(
        id: Uuid().v4(),
        packageName: packageName.toLowerCase(),
        word: word.toLowerCase(),
        regex: regex,
        addedByParent: addedByParent);

    await db.transaction((txn) async {
      final wordAlreadyExists = await txn.query(ProfanityWord.TABLE_NAME,
          where:
              "${ProfanityWord.COLUMN_WORD} = ? AND ${ProfanityWord.COLUMN_PACKAGE_NAME} = ?",
          whereArgs: [profanityWord.word, profanityWord.packageName]);

      if (wordAlreadyExists.isNotEmpty)
        throw ProfanityWordAlreadyExistsException();

      txn.insert(ProfanityWord.TABLE_NAME, profanityWord.toMap());
    });

    return profanityWord;
  }

  Future<void> deleteByWordAndPackage(String word, String package) async {
    final db = await databaseService.database;

    db.delete(ProfanityWord.TABLE_NAME,
        where:
            "${ProfanityWord.COLUMN_WORD} =? AND ${ProfanityWord.COLUMN_PACKAGE_NAME} = ?",
        whereArgs: [word, package]);
  }

  Future<void> deleteByPackage(String package) async {
    final db = await databaseService.database;

    db.delete(ProfanityWord.TABLE_NAME,
        where: "${ProfanityWord.COLUMN_PACKAGE_NAME} = ?",
        whereArgs: [package]);
  }

  Future<void> deleteByID(String id) async {
    final db = await databaseService.database;

    db.delete(ProfanityWord.TABLE_NAME,
        where: "${ProfanityWord.COLUMN_ID} =?", whereArgs: [id]);
  }
}

class ProfanityWordAlreadyExistsException implements Exception {}
