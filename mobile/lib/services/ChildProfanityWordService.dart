import 'package:mobile/domain/ChildProfanityWord.dart';
import 'package:mobile/services/DatabaseService.dart';
import 'package:uuid/uuid.dart';

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

  Future<ChildProfanityWord> insert(String word,String childNumber, {String? id}) async {
    final db = await databaseService.database;

    //logic for profanity variations
    String newWord = word.replaceAll(RegExp(r'e'), '[e3]');
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

    final childProfanityWord = ChildProfanityWord(
        phoneNumber: childNumber,
        profanityWordRegex: newWord,
        profanityID: id != null ? id : Uuid().v4(),
        profanityOriginalWord: word);

    await db.transaction((txn) async {
      final wordAlreadyExists = await txn.query(ChildProfanityWord.TABLE_NAME,
          where:
              "${ChildProfanityWord.COLUMN_PROFANITY_ID} = ? AND ${ChildProfanityWord.COLUMN_PHONE_NUMBER} = ?",
          whereArgs: [
            childProfanityWord.profanityID,
            childProfanityWord.phoneNumber
          ]);

      if (wordAlreadyExists.isNotEmpty)
        throw ChildProfanityWordAlreadyExistsException();

      txn.insert(ChildProfanityWord.TABLE_NAME, childProfanityWord.toMap());
    });

    return childProfanityWord;
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
