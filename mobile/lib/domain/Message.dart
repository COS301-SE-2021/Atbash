import 'Tag.dart';

class Message {
  final String id;
  final String senderPhoneNumber;
  final String recipientPhoneNumber;
  final String contents;
  final DateTime timestamp;
  final ReadReceipt readReceipt;
  final bool deleted;
  final bool liked;
  final List<Tag> tags;

  Message({
    required this.id,
    required this.senderPhoneNumber,
    required this.recipientPhoneNumber,
    required this.contents,
    required this.timestamp,
    required this.readReceipt,
    required this.deleted,
    required this.liked,
    required this.tags,
  });

  Map<String, Object> toMap() {
    return {
      COLUMN_ID: id,
      COLUMN_SENDER_NUMBER: senderPhoneNumber,
      COLUMN_RECIPIENT_NUMBER: recipientPhoneNumber,
      COLUMN_CONTENTS: contents,
      COLUMN_TIMESTAMP: timestamp.millisecondsSinceEpoch,
      COLUMN_READ_RECEIPT: readReceipt.index,
      COLUMN_DELETED: deleted ? 1 : 0,
      COLUMN_LIKED: liked ? 1 : 0,
    };
  }

  static Message? fromMap(Map<String, Object?> map) {
    final id = map[COLUMN_ID] as String?;
    final senderPhoneNumber = map[COLUMN_SENDER_NUMBER] as String?;
    final recipientPhoneNumber = map[COLUMN_RECIPIENT_NUMBER] as String?;
    final contents = map[COLUMN_CONTENTS] as String?;
    final timestamp = map[COLUMN_TIMESTAMP] as int?;
    final readReceipt = map[COLUMN_READ_RECEIPT] as int?;
    final deleted = map[COLUMN_DELETED] as int?;
    final liked = map[COLUMN_LIKED] as int?;

    if (id != null &&
        senderPhoneNumber != null &&
        recipientPhoneNumber != null &&
        contents != null &&
        timestamp != null &&
        readReceipt != null &&
        deleted != null &&
        liked != null) {
      return Message(
        id: id,
        senderPhoneNumber: senderPhoneNumber,
        recipientPhoneNumber: recipientPhoneNumber,
        contents: contents,
        timestamp: DateTime.fromMillisecondsSinceEpoch(timestamp),
        readReceipt: ReadReceipt.values[readReceipt],
        deleted: deleted == 1,
        liked: liked == 1,
        tags: [],
      );
    }
  }

  static const String TABLE_NAME = "message";
  static const String COLUMN_ID = "message_id";
  static const String COLUMN_SENDER_NUMBER = "message_sender_number";
  static const String COLUMN_RECIPIENT_NUMBER = "message_recipient_number";
  static const String COLUMN_CONTENTS = "message_contents";
  static const String COLUMN_TIMESTAMP = "message_timestamp";
  static const String COLUMN_READ_RECEIPT = "message_read_receipt";
  static const String COLUMN_DELETED = "message_deleted";
  static const String COLUMN_LIKED = "message_liked";
  static const String CREATE_TABLE = "create table $TABLE_NAME ("
      "$COLUMN_ID text primary key,"
      "$COLUMN_SENDER_NUMBER text not null,"
      "$COLUMN_RECIPIENT_NUMBER text not null,"
      "$COLUMN_CONTENTS text not null,"
      "$COLUMN_TIMESTAMP int not null,"
      "$COLUMN_READ_RECEIPT int not null,"
      "$COLUMN_DELETED tinyint not null,"
      "$COLUMN_LIKED tinyint not null"
      ");";
}

enum ReadReceipt { undelivered, delivered, seen }
