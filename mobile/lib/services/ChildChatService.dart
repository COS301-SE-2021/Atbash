import 'package:mobile/domain/ChildChat.dart';
import 'package:mobile/services/DatabaseService.dart';

class ChildChatService {
  final DatabaseService databaseService;

  ChildChatService(this.databaseService);

  Future<List<ChildChat>> fetchAllChatsByChildNumber(String phoneNumber) async {
    final db = await databaseService.database;

    final result = await db.query(ChildChat.TABLE_NAME,
        where: "${ChildChat.COLUMN_CHILD_PHONE_NUMBER} = ?",
        whereArgs: [phoneNumber]);

    final chats = <ChildChat>[];
    result.forEach((element) {
      final chat = ChildChat.fromMap(element);

      if (chat != null) chats.add(chat);
    });

    return chats;
  }

  Future<ChildChat> fetchByNumbers(
      String childNumber, String otherNumber) async {
    final db = await databaseService.database;

    final result = await db.query(ChildChat.TABLE_NAME,
        where:
            "${ChildChat.COLUMN_CHILD_PHONE_NUMBER} = ? AND ${ChildChat.COLUMN_OTHER_PARTY_NUMBER} = ?",
        whereArgs: [childNumber, otherNumber]);

    if (result.isNotEmpty) {
      final chat = ChildChat.fromMap(result.first);
      if (chat == null) throw ChildChatDoesNotExistException();

      return chat;
    }

    throw ChildChatDoesNotExistException();
  }

  Future<void> insert(ChildChat chat) async {
    final db = await databaseService.database;

    await db.transaction((txn) async {
      final chatAlreadyExists = await txn.query(ChildChat.TABLE_NAME,
          where:
              "${ChildChat.COLUMN_OTHER_PARTY_NUMBER} = ? AND ${ChildChat.COLUMN_CHILD_PHONE_NUMBER} = ?",
          whereArgs: [chat.otherPartyNumber, chat.childPhoneNumber]);

      if (chatAlreadyExists.isNotEmpty) throw ChildChatAlreadyExistsException();

      txn.insert(ChildChat.TABLE_NAME, chat.toMap());
    });
  }

  Future<void> updateOtherPartyNameByNumbers(
      String childNumber, String otherNumber, String name) async {
    final db = await databaseService.database;

    //Check if exists?
    final response = await db.query(ChildChat.TABLE_NAME,
        where:
            "${ChildChat.COLUMN_CHILD_PHONE_NUMBER} = ? AND ${ChildChat.COLUMN_OTHER_PARTY_NUMBER} = ?",
        whereArgs: [childNumber, otherNumber]);

    if (response.isNotEmpty) {
      final chat = ChildChat.fromMap(response.first);

      if (chat != null) {
        chat.otherPartyName = name;
        db.update(ChildChat.TABLE_NAME, chat.toMap());
      }
    }
  }

  Future<void> deleteByNumbers(String childNumber, String otherNumber) async {
    final db = await databaseService.database;

    await db.transaction((txn) async {
      final chatExists = await txn.query(ChildChat.TABLE_NAME,
          where:
              "${ChildChat.COLUMN_CHILD_PHONE_NUMBER} = ? AND ${ChildChat.COLUMN_OTHER_PARTY_NUMBER} = ?",
          whereArgs: [childNumber, otherNumber]);

      if (chatExists.isEmpty) throw ChildChatDoesNotExistException();

      await txn.delete(ChildChat.TABLE_NAME,
          where:
              "${ChildChat.COLUMN_CHILD_PHONE_NUMBER} = ? AND ${ChildChat.COLUMN_OTHER_PARTY_NUMBER} = ?",
          whereArgs: [childNumber, otherNumber]);
    });
  }

  Future<void> deleteAllByNumber(String childNumber) async {
    final db = await databaseService.database;

    await db.delete(ChildChat.TABLE_NAME,
        where: "${ChildChat.COLUMN_CHILD_PHONE_NUMBER} = ?",
        whereArgs: [childNumber]);
  }
}

class ChildChatAlreadyExistsException implements Exception {}

class ChildChatDoesNotExistException implements Exception {}
