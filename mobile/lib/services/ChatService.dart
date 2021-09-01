import 'package:mobile/domain/Chat.dart';
import 'package:mobile/services/DatabaseService.dart';

class ChatService {
  final DatabaseService databaseService;

  ChatService(this.databaseService);

  final List<void Function()> _onChangedListeners = [];

  void onChanged(void Function() cb) {
    _onChangedListeners.add(cb);
  }

  void disposeOnChanged(void Function() cb) {
    _onChangedListeners.remove(cb);
  }

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

    _notifyListeners();

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

    _notifyListeners();

    return chat;
  }

  Future<void> deleteById(String id) async {
    final db = await databaseService.database;

    await db.delete(
      Chat.TABLE_NAME,
      where: "${Chat.COLUMN_ID} = ?",
      whereArgs: [id],
    );

    _notifyListeners();
  }

  Future<bool> existsById(String id) async {
    final db = await databaseService.database;

    final response = await db.query(
      Chat.TABLE_NAME,
      where: "${Chat.COLUMN_ID} = ?",
      whereArgs: [id],
    );

    return response.isNotEmpty;
  }

  void _notifyListeners() {
    _onChangedListeners.forEach((listener) => listener());
  }
}

class ChatNotFoundException implements Exception {}
