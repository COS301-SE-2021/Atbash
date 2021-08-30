import 'package:mobile/domain/Message.dart';
import 'package:mobile/domain/Tag.dart';
import 'package:mobile/services/DatabaseService.dart';

class MessageService {
  final DatabaseService databaseService;

  MessageService(this.databaseService);

  Future<List<Message>> fetchAllByChatId(String chatId) async {
    final db = await databaseService.database;

    final response = await db.rawQuery(
      "select *, (select group_concat(tag_id, ',') from message_tag where message_id = message.message_id order by message_tag.tag_id) as tag_ids, (select group_concat(tag_name, ',') from tag join message_tag on tag.tag_id = message_tag.tag_id where message_id = message.message_id order by message_tag.tag_id) as tag_names from message where ${Message.COLUMN_CHAT_ID} = ? order by message_timestamp desc;",
      [chatId],
    );

    final messages = <Message>[];
    response.forEach((map) {
      final message = Message.fromMap(map);

      if (message != null) {
        final tagIdsStr = map["tag_ids"] as String?;
        final tagNamesStr = map["tag_names"] as String?;

        if (tagIdsStr != null && tagNamesStr != null) {
          final tagIds = tagIdsStr.split(",");
          final tagNames = tagNamesStr.split(",");

          final tags = <Tag>[];

          for (int i = 0; i < tagIdsStr.length; i++) {
            tags.add(Tag(id: tagIds[i], name: tagNames[i]));
          }
          message.tags = tags;
        }

        messages.add(message);
      }
    });

    return messages;
  }

  Future<Message> fetchById(String id) async {
    final db = await databaseService.database;

    final response = await db.query(
      Message.TABLE_NAME,
      where: "${Message.COLUMN_ID} = ?",
      whereArgs: [id],
    );

    if (response.isEmpty) {
      throw MessageNotFoundException();
    } else {
      final message = Message.fromMap(response.first);
      if (message == null) {
        throw MessageNotFoundException();
      } else {
        return message;
      }
    }
  }

  Future<List<Message>> fetchAllById(List<String> ids) async {
    final db = await databaseService.database;

    final where = "(" + ids.map((e) => "?").join(",") + ")";

    final response = await db.query(
      Message.TABLE_NAME,
      where: "${Message.COLUMN_ID} in $where",
      whereArgs: ids,
    );

    final messages = <Message>[];

    response.forEach((element) {
      final message = Message.fromMap(element);
      if (message != null) {
        messages.add(message);
      }
    });

    return messages;
  }

  Future<Message> insert(Message message) async {
    final db = await databaseService.database;

    await db.transaction((txn) async {
      final messageInsert = txn.insert(Message.TABLE_NAME, message.toMap());

      final tagRelationInserts = message.tags.map((tag) async {
        await txn.insert("${Message.TABLE_NAME}_${Tag.TABLE_NAME}", {
          Message.COLUMN_ID: message.id,
          Tag.COLUMN_ID: tag.id,
        });
      });

      await Future.wait([messageInsert, ...tagRelationInserts]);
    });

    return message;
  }

  Future<Message> update(Message message) async {
    final db = await databaseService.database;

    await db.transaction((txn) async {
      final messageUpdate = txn.update(
        Message.TABLE_NAME,
        message.toMap(),
        where: "${Message.COLUMN_ID} = ?",
        whereArgs: [message.id],
      );

      final tagDeletes = message.tags.map((tag) async {
        await txn.delete(
          "${Message.TABLE_NAME}_${Tag.TABLE_NAME}",
          where: "${Message.COLUMN_ID} = ? and ${Tag.COLUMN_ID} = ?",
          whereArgs: [message.id, tag.id],
        );
      });

      await Future.wait([messageUpdate, ...tagDeletes]);

      await Future.wait(message.tags.map((tag) async {
        await txn.insert("${Message.TABLE_NAME}_${Tag.TABLE_NAME}", {
          Message.COLUMN_ID: message.id,
          Tag.COLUMN_ID: tag.id,
        });
      }));
    });

    return message;
  }

  Future<void> setMessageDeleted(String messageId) async {
    final db = await databaseService.database;

    final response = await db.rawUpdate(
      "update ${Message.TABLE_NAME} set ${Message.COLUMN_DELETED} = 1, ${Message.COLUMN_CONTENTS} = '' where ${Message.COLUMN_ID} = ?",
      [messageId],
    );

    if (response == 0) throw MessageNotFoundException();
  }

  Future<void> setMessageReadReceipt(
      String messageId, ReadReceipt readReceipt) async {
    final db = await databaseService.database;

    final response = await db.rawUpdate(
      "update ${Message.TABLE_NAME} set${Message.COLUMN_READ_RECEIPT} = ? where ${Message.COLUMN_ID} = ?",
      [readReceipt.index, messageId],
    );

    if (response == 0) throw MessageNotFoundException();
  }

  Future<void> deleteById(String id) async {
    final db = await databaseService.database;

    await db.transaction((txn) async {
      final exists = await txn.query(
        Message.TABLE_NAME,
        where: "${Message.COLUMN_ID} = ?",
        whereArgs: [id],
      );

      if (exists.isEmpty) {
        throw MessageNotFoundException();
      }

      await txn.delete(
        Message.TABLE_NAME,
        where: "${Message.COLUMN_ID} = ?",
        whereArgs: [id],
      );
    });
  }
}

class MessageNotFoundException implements Exception {}
