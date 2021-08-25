import 'package:mobile/domain/Chat.dart';
import 'package:mobile/services/DatabaseService.dart';

class ChatService {
  final DatabaseService databaseService;

  ChatService(this.databaseService);

  Future<List<Chat>> fetchAll() async {
    final db = await databaseService.database;

    // TODO should have inner query which fetches most recent message for chat
    final response = await db.rawQuery(
        "select * from chat left join contact on chat_contact_phone_number = contact_phone_number;");

    final chats = <Chat>[];
    response.forEach((element) {
      final chat = Chat.fromMap(element);

      if (chat != null) {
        chats.add(chat);
      }
    });

    return chats;
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
