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

  Message(
      {required this.id,
      required this.senderPhoneNumber,
      required this.recipientPhoneNumber,
      required this.contents,
      required this.timestamp,
      required this.readReceipt,
      required this.deleted,
      required this.liked,
      required this.tags});

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
      "$COLUMN_LIKED tinyint not null,"
      ");";
}

enum ReadReceipt { undelivered, delivered, seen }
