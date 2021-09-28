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

  Future<void> insert(ChildChat chat) async {
    final db = await databaseService.database;

    await db.transaction((txn) async {
      final chatAlreadyExists = await txn.query(ChildChat.TABLE_NAME,
          //TODO Ive implemented the dual key here
          where:
              "${ChildChat.COLUMN_OTHER_PARTY_NUMBER} = ? AND ${ChildChat.COLUMN_CHILD_PHONE_NUMBER} = ?",
          whereArgs: [chat.otherPartyNumber, chat.childPhoneNumber]);

      if (chatAlreadyExists.isNotEmpty) throw ChildChatAlreadyExistsException();

      txn.insert(ChildChat.TABLE_NAME, chat.toMap());
    });
  }

  Future<void> updateOtherPartyNameById(String id, String name) async {
    final db = await databaseService.database;

    //Check if exists?
    final response = await db.query(ChildChat.TABLE_NAME,
        where: "${ChildChat.COLUMN_ID} = ?", whereArgs: [id]);

    if (response.isNotEmpty) {
      final chat = ChildChat.fromMap(response.first);

      if (chat != null) {
        chat.otherPartyName = name;
        db.update(ChildChat.TABLE_NAME, chat.toMap());
      }
    }
  }

  Future<void> deleteById(String id) async {
    final db = await databaseService.database;

    await db.transaction((txn) async {
      final chatExists = await txn.query(ChildChat.TABLE_NAME,
          where: "${ChildChat.COLUMN_ID} = ?", whereArgs: [id]);

      if (chatExists.isEmpty) throw ChildChatDoesNotExistException();

      await txn.delete(ChildChat.TABLE_NAME,
          where: "${ChildChat.COLUMN_ID} = ?", whereArgs: [id]);
    });
  }
}

class ChildChatAlreadyExistsException implements Exception {}

class ChildChatDoesNotExistException implements Exception {}
