import 'package:get_it/get_it.dart';
import 'package:mobile/domain/Chat.dart';
import 'package:mobile/services/DatabaseService.dart';
import 'package:mobile/services/PCConnectionService.dart';
import 'package:mobile/util/Tuple.dart';

class ChatService {
  final DatabaseService databaseService;
  final PCConnectionService pcConnectionService = GetIt.I.get();

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

  Future<List<Tuple<String, String>>> fetchIdsByContactPhoneNumbers(
      List<String> numbers) async {
    final db = await databaseService.database;

    final where = "(" + numbers.map((e) => "?").join(",") + ")";

    final response = await db.query(Chat.TABLE_NAME,
        where: "${Chat.COLUMN_CONTACT_PHONE_NUMBER} in $where",
        whereArgs: numbers);

    return response
        .map((e) => Tuple(e[Chat.COLUMN_CONTACT_PHONE_NUMBER] as String,
            e[Chat.COLUMN_ID] as String))
        .toList();
  }

  Future<List<Chat>> fetchByChatType(ChatType chatType) async {
    final db = await databaseService.database;

    final response = await db.rawQuery(
      "select * from chat left join message on message_id = (select message_id from message where message_chat_id = chat_id order by message_timestamp desc limit 1) left join contact on chat_contact_phone_number = contact_phone_number where chat_type = ?;",
      [chatType.index],
    );

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

    await pcConnectionService.notifyPcPutChat(chat);
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

    await pcConnectionService.notifyPcPutChat(chat);
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

    await pcConnectionService.notifyPcDeleteChat(id);
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

  Future<bool> existsByPhoneNumberAndChatType(
      String phoneNumber, ChatType chatType) async {
    final db = await databaseService.database;
    final response = await db.query(
      Chat.TABLE_NAME,
      where:
          "${Chat.COLUMN_CONTACT_PHONE_NUMBER} = ? and ${Chat.COLUMN_CHAT_TYPE} = ?",
      whereArgs: [phoneNumber, chatType.index],
    );

    return response.isNotEmpty;
  }

  Future<String> findIdByPhoneNumberAndChatType(
      String phoneNumber, ChatType chatType) async {
    final db = await databaseService.database;
    final response = await db.query(
      Chat.TABLE_NAME,
      where:
          "${Chat.COLUMN_CONTACT_PHONE_NUMBER} = ? and ${Chat.COLUMN_CHAT_TYPE} = ?",
      whereArgs: [phoneNumber, chatType.index],
    );

    return response.single[Chat.COLUMN_ID] as String;
  }

  void _notifyListeners() {
    _onChangedListeners.forEach((listener) => listener());
  }
}

class ChatNotFoundException implements Exception {}
