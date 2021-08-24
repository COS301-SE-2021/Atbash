import 'package:mobile/domain/Message.dart';
import 'package:mobile/domain/Tag.dart';
import 'package:mobile/services/DatabaseService.dart';

class MessageService {
  final DatabaseService databaseService;

  MessageService(this.databaseService);

  Future<List<Message>> fetchAllBySenderOrRecipient(String phoneNumber) async {
    final db = await databaseService.database;

    final response = await db.rawQuery(
      "select *, (select group_concat(tag_id, ',') from message_tag where message_id = message.message_id order by message_tag.tag_id) as tag_ids, (select group_concat(tag_name, ',') from tag join message_tag on tag.tag_id = message_tag.tag_id where message_id = message.message_id order by message_tag.tag_id) as tag_names from message where ${Message.COLUMN_SENDER_NUMBER} = ? or ${Message.COLUMN_RECIPIENT_NUMBER} = ?;",
      [phoneNumber, phoneNumber],
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
