import 'package:mobile/domain/Chat.dart';
import 'package:mobile/services/DatabaseService.dart';

class ChatService {
  final DatabaseService databaseService;

  ChatService(this.databaseService);

  Future<List<Chat>> fetchAll() async {
    final db = await databaseService.database;

    final response = await db.rawQuery(
        "select * from chat left join message on message_id = (select message_id from message where message_chat_id = chat_id order by message_timestamp desc limit 1)  left join contact on chat_contact_phone_number = contact_phone_number;");

    final chats = <Chat>[];
    response.forEach((element) {
      final chat = Chat.fromMap(element);

      if (chat != null) {
        chats.add(chat);
      }
    });

    return chats;
  }

  Future<Chat> fetchById(String chatId) async {
    final db = await databaseService.database;

    final response = await db.rawQuery(
      "select * from chat left join message on message_id = (select message_id from message where message_chat_id = chat_id order by message_timestamp desc limit 1) left join contact on chat_contact_phone_number = contact_phone_number where chat_id = ?;",
      [chatId],
    );

    if (response.isEmpty) {
      throw ChatNotFoundException();
    } else {
      final chat = Chat.fromMap(response.first);

      if (chat != null) {
        return chat;
      } else {
        throw ChatNotFoundException();
      }
    }
  }

  Future<Chat> insert(Chat chat) async {
    final db = await databaseService.database;

    await db.insert(Chat.TABLE_NAME, chat.toMap());

    return chat;
  }

  Future<Chat> update(Chat chat) async {
    final db = await databaseService.database;

    await db.update(
      Chat.TABLE_NAME,
      chat.toMap(),
      where: "${Chat.COLUMN_ID} = ?",
      whereArgs: [chat.id],
    );

    return chat;
  }

  // TODO should also delete all messages
  Future<void> deleteById(String id) async {
    final db = await databaseService.database;

    await db.delete(
      Chat.TABLE_NAME,
      where: "${Chat.COLUMN_ID} = ?",
      whereArgs: [id],
    );
  }
}

class ChatNotFoundException implements Exception {}
