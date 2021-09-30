import 'package:mobile/domain/ChildProfanityWord.dart';
import 'package:mobile/services/DatabaseService.dart';

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

  Future<ChildProfanityWord> fetchByNumberAndID(
      String childNumber, String profID) async {
    final db = await databaseService.database;

    final result = await db.query(ChildProfanityWord.TABLE_NAME,
        where:
            "${ChildProfanityWord.COLUMN_PHONE_NUMBER} = ? AND ${ChildProfanityWord.COLUMN_PROFANITY_ID} = ?",
        whereArgs: [childNumber, profID]);

    if (result.isNotEmpty) {
      final word = ChildProfanityWord.fromMap(result.first);
      if (word == null) throw ChildProfanityWordDoesNotExistException();

      return word;
    }

    throw ChildProfanityWordDoesNotExistException();
  }

  Future<void> insert(ChildProfanityWord word) async {
    final db = await databaseService.database;

    await db.transaction((txn) async {
      final wordAlreadyExists = await txn.query(ChildProfanityWord.TABLE_NAME,
          where:
              "${ChildProfanityWord.COLUMN_PROFANITY_ID} = ? AND ${ChildProfanityWord.COLUMN_PHONE_NUMBER} = ?",
          whereArgs: [word.profanityID, word.phoneNumber]);

      if (wordAlreadyExists.isNotEmpty)
        throw ChildProfanityWordAlreadyExistsException();

      txn.insert(ChildProfanityWord.TABLE_NAME, word.toMap());
    });
  }

  Future<void> deleteByNumberAndID(String childNumber, String profID) async {
    final db = await databaseService.database;

    await db.transaction((txn) async {
      final wordAlreadyExists = await txn.query(ChildProfanityWord.TABLE_NAME,
          where:
              "${ChildProfanityWord.COLUMN_PROFANITY_ID} = ? AND ${ChildProfanityWord.COLUMN_PHONE_NUMBER} = ?",
          whereArgs: [profID, childNumber]);

      if (wordAlreadyExists.isEmpty)
        throw ChildProfanityWordDoesNotExistException();

      await txn.delete(ChildProfanityWord.TABLE_NAME,
          where:
              "${ChildProfanityWord.COLUMN_PHONE_NUMBER} = ? AND ${ChildProfanityWord.COLUMN_PROFANITY_ID} = ?",
          whereArgs: [childNumber, profID]);
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
