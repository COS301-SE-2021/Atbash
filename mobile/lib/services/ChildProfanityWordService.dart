import 'package:mobile/domain/ChildProfanityWord.dart';
import 'package:mobile/services/DatabaseService.dart';
import 'package:mobile/util/RegexGeneration.dart';

class ChildProfanityWordService {
  final DatabaseService databaseService;

  ChildProfanityWordService(this.databaseService);

  Future<List<ChildProfanityWord>> fetchAllWordsByChildNumber(
      String phoneNumber) async {
    final db = await databaseService.database;

    final result = await db.query(ChildProfanityWord.TABLE_NAME,
        where: "${ChildProfanityWord.COLUMN_PHONE_NUMBER} = ?",
        whereArgs: [phoneNumber]);

    final words = <ChildProfanityWord>[];
    result.forEach((element) {
      final word = ChildProfanityWord.fromMap(element);

      if (word != null) words.add(word);
    });

    return words;
  }

  Future<ChildProfanityWord> insert(
      String childNumber, String word, String packageName, String id) async {
    final db = await databaseService.database;

    final childProfanityWord = ChildProfanityWord(
      phoneNumber: childNumber,
      id: id,
      packageName: packageName,
      word: word,
      regex: generateRegex(word),
    );

    await db.transaction((txn) async {
      final wordAlreadyExists = await txn.query(ChildProfanityWord.TABLE_NAME,
          where:
              "${ChildProfanityWord.COLUMN_ID} = ? AND ${ChildProfanityWord.COLUMN_PHONE_NUMBER} = ?",
          whereArgs: [childProfanityWord.id, childProfanityWord.phoneNumber]);

      if (wordAlreadyExists.isNotEmpty)
        throw ChildProfanityWordAlreadyExistsException();

      txn.insert(ChildProfanityWord.TABLE_NAME, childProfanityWord.toMap());
    });

    return childProfanityWord;
  }

  Future<void> deleteByNumberAndID(String childNumber, String id) async {
    final db = await databaseService.database;

    await db.transaction((txn) async {
      final wordAlreadyExists = await txn.query(ChildProfanityWord.TABLE_NAME,
          where:
              "${ChildProfanityWord.COLUMN_ID} = ? AND ${ChildProfanityWord.COLUMN_PHONE_NUMBER} = ?",
          whereArgs: [id, childNumber]);

      if (wordAlreadyExists.isEmpty)
        throw ChildProfanityWordDoesNotExistException();

      await txn.delete(ChildProfanityWord.TABLE_NAME,
          where:
              "${ChildProfanityWord.COLUMN_PHONE_NUMBER} = ? AND ${ChildProfanityWord.COLUMN_ID} = ?",
          whereArgs: [childNumber, id]);
    });
  }

  Future<void> deleteAllByNumber(String childNumber) async {
    final db = await databaseService.database;

    await db.delete(ChildProfanityWord.TABLE_NAME,
        where: "${ChildProfanityWord.COLUMN_PHONE_NUMBER} = ?",
        whereArgs: [childNumber]);
  }
}

class ChildProfanityWordDoesNotExistException implements Exception {}

class ChildProfanityWordAlreadyExistsException implements Exception {}
