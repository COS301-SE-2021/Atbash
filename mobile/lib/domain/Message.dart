import 'package:mobile/util/Utils.dart';

enum ReadReceipt { delivered, undelivered, seen }

class Message {
  final String id;
  final String senderPhoneNumber;
  final String recipientPhoneNumber;
  String contents;
  final DateTime timestamp;
  ReadReceipt readReceipt;
  bool deleted;

  Message(
    this.id,
    this.senderPhoneNumber,
    this.recipientPhoneNumber,
    this.contents,
    this.timestamp,
    this.readReceipt,
    this.deleted,
  );

  Map<String, dynamic> toMap() {
    return {
      COLUMN_ID: this.id,
      COLUMN_SENDER_PHONE_NUMBER: this.senderPhoneNumber,
      COLUMN_RECIPIENT_PHONE_NUMBER: this.recipientPhoneNumber,
      COLUMN_CONTENTS: this.contents,
      COLUMN_TIMESTAMP: this.timestamp.millisecondsSinceEpoch,
      COLUMN_READ_RECEIPT: this.readReceipt.toString(),
      COLUMN_DELETED: this.deleted ? 1 : 0,
    };
  }

  static Message? fromMap(Map<String, Object?> map) {
    final id = map[Message.COLUMN_ID];
    final senderPhoneNumber = map[Message.COLUMN_SENDER_PHONE_NUMBER];
    final recipientPhoneNumber = map[Message.COLUMN_RECIPIENT_PHONE_NUMBER];
    final contents = map[Message.COLUMN_CONTENTS];
    final timestamp = map[Message.COLUMN_TIMESTAMP];
    final readReceipt = parseReadReceipt(map[Message.COLUMN_READ_RECEIPT]);
    final deleted = map[Message.COLUMN_DELETED];

    if (id is String &&
        senderPhoneNumber is String &&
        recipientPhoneNumber is String &&
        contents is String &&
        timestamp is int &&
        readReceipt is ReadReceipt &&
        deleted is int) {
      return Message(
          id,
          senderPhoneNumber,
          recipientPhoneNumber,
          contents,
          DateTime.fromMillisecondsSinceEpoch(timestamp),
          readReceipt,
          deleted == 1);
    } else {
      return null;
    }
  }

  static const String TABLE_NAME = "message";
  static const String COLUMN_ID = "id";
  static const String COLUMN_SENDER_PHONE_NUMBER = "sender_number";
  static const String COLUMN_RECIPIENT_PHONE_NUMBER = "recipient_number";
  static const String COLUMN_CONTENTS = "contents";
  static const String COLUMN_TIMESTAMP = "timestamp";
  static const String COLUMN_READ_RECEIPT = "read_receipt";
  static const String COLUMN_DELETED = "deleted";

  static const String CREATE_TABLE =
      "create table $TABLE_NAME ($COLUMN_ID text primary key, $COLUMN_SENDER_PHONE_NUMBER text not null, $COLUMN_RECIPIENT_PHONE_NUMBER text not null, $COLUMN_CONTENTS text not null, $COLUMN_TIMESTAMP int not null, $COLUMN_READ_RECEIPT text not null, $COLUMN_DELETED tinyint not null);";
}
