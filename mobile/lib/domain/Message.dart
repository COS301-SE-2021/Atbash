import 'package:mobx/mobx.dart';

import 'Tag.dart';

part 'Message.g.dart';

class Message extends _Message with _$Message {
  Message({
    required String id,
    required String chatId,
    required bool isIncoming,
    required String otherPartyPhoneNumber,
    required String contents,
    required DateTime timestamp,
    ReadReceipt readReceipt = ReadReceipt.undelivered,
    bool deleted = false,
    bool liked = false,
    List<Tag> tags = const [],
  }) : super(
            id: id,
            chatId: chatId,
            isIncoming: isIncoming,
            otherPartyPhoneNumber: otherPartyPhoneNumber,
            contents: contents,
            timestamp: timestamp,
            readReceipt: readReceipt,
            deleted: deleted,
            liked: liked,
            tags: tags);

  Map<String, Object> toMap() {
    return {
      COLUMN_ID: id,
      COLUMN_CHAT_ID: chatId,
      COLUMN_IS_INCOMING: isIncoming ? 1 : 0,
      COLUMN_OTHER_PARTY_PHONE: otherPartyPhoneNumber,
      COLUMN_CONTENTS: contents,
      COLUMN_TIMESTAMP: timestamp.millisecondsSinceEpoch,
      COLUMN_READ_RECEIPT: readReceipt.index,
      COLUMN_DELETED: deleted ? 1 : 0,
      COLUMN_LIKED: liked ? 1 : 0,
    };
  }

  static Message? fromMap(Map<String, Object?> map) {
    final id = map[COLUMN_ID] as String?;
    final chatId = map[COLUMN_CHAT_ID] as String?;
    final isIncoming = map[COLUMN_IS_INCOMING] as int?;
    final otherPartyPhoneNumber = map[COLUMN_OTHER_PARTY_PHONE] as String?;
    final contents = map[COLUMN_CONTENTS] as String?;
    final timestamp = map[COLUMN_TIMESTAMP] as int?;
    final readReceipt = map[COLUMN_READ_RECEIPT] as int?;
    final deleted = map[COLUMN_DELETED] as int?;
    final liked = map[COLUMN_LIKED] as int?;

    if (id != null &&
        chatId != null &&
        isIncoming != null &&
        otherPartyPhoneNumber != null &&
        contents != null &&
        timestamp != null &&
        readReceipt != null &&
        deleted != null &&
        liked != null) {
      return Message(
        id: id,
        chatId: chatId,
        isIncoming: isIncoming != 0,
        otherPartyPhoneNumber: otherPartyPhoneNumber,
        contents: contents,
        timestamp: DateTime.fromMillisecondsSinceEpoch(timestamp),
        readReceipt: ReadReceipt.values[readReceipt],
        deleted: deleted != 0,
        liked: liked != 0,
        tags: [],
      );
    }
  }

  static const String TABLE_NAME = "message";
  static const String COLUMN_ID = "message_id";
  static const String COLUMN_CHAT_ID = "message_chat_id";
  static const String COLUMN_IS_INCOMING = "message_is_incoming";
  static const String COLUMN_OTHER_PARTY_PHONE = "message_other_party_phone";
  static const String COLUMN_CONTENTS = "message_contents";
  static const String COLUMN_TIMESTAMP = "message_timestamp";
  static const String COLUMN_READ_RECEIPT = "message_read_receipt";
  static const String COLUMN_DELETED = "message_deleted";
  static const String COLUMN_LIKED = "message_liked";
  static const String CREATE_TABLE = "create table $TABLE_NAME ("
      "$COLUMN_ID text primary key,"
      "$COLUMN_CHAT_ID text not null,"
      "$COLUMN_IS_INCOMING tinyint not null,"
      "$COLUMN_OTHER_PARTY_PHONE text not null,"
      "$COLUMN_CONTENTS text not null,"
      "$COLUMN_TIMESTAMP int not null,"
      "$COLUMN_READ_RECEIPT int not null,"
      "$COLUMN_DELETED tinyint not null,"
      "$COLUMN_LIKED tinyint not null"
      ");";
}

abstract class _Message with Store {
  final String id;

  final String chatId;

  final bool isIncoming;

  final String otherPartyPhoneNumber;

  @observable
  String contents;

  final DateTime timestamp;

  @observable
  ReadReceipt readReceipt;

  @observable
  bool deleted;

  @observable
  bool liked;

  @observable
  List<Tag> tags;

  _Message({
    required this.id,
    required this.chatId,
    required this.isIncoming,
    required this.otherPartyPhoneNumber,
    required this.contents,
    required this.timestamp,
    required this.readReceipt,
    required this.deleted,
    required this.liked,
    required this.tags,
  });
}

enum ReadReceipt { undelivered, delivered, seen }
