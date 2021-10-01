class ChildMessage {
  final String id;
  final String chatId;
  final bool isIncoming;
  final String otherPartyNumber;
  final String contents;
  final DateTime timestamp;
  final isMedia = false;

  ChildMessage(
      {required this.id,
      required this.chatId,
      required this.isIncoming,
      required this.otherPartyNumber,
      required this.contents,
      required this.timestamp});

  Map<String, Object?> toMap() {
    return {
      COLUMN_ID: id,
      COLUMN_CHAT_ID: chatId,
      COLUMN_IS_INCOMING: isIncoming ? 1 : 0,
      COLUMN_OTHER_PARTY_NUMBER: otherPartyNumber,
      COLUMN_CONTENTS: contents,
      COLUMN_TIMESTAMP: timestamp.millisecondsSinceEpoch,
    };
  }

  Map toJson() => {
        'id': id,
        'chatId': chatId,
        'isIncoming': isIncoming,
        'otherPartyNumber': otherPartyNumber,
        'contents': contents,
        'timestamp': timestamp.millisecondsSinceEpoch
      };

  static ChildMessage? fromMap(Map<String, Object?> map) {
    final id = map[COLUMN_ID] as String?;
    final chatId = map[COLUMN_CHAT_ID] as String?;
    final isIncoming = map[COLUMN_IS_INCOMING] as int?;
    final otherPartyNumber = map[COLUMN_OTHER_PARTY_NUMBER] as String?;
    final contents = map[COLUMN_CONTENTS] as String?;
    final timestamp = map[COLUMN_TIMESTAMP] as int?;

    if (id != null &&
        chatId != null &&
        isIncoming != null &&
        otherPartyNumber != null &&
        contents != null &&
        timestamp != null) {
      return ChildMessage(
          id: id,
          chatId: chatId,
          isIncoming: isIncoming != 0,
          otherPartyNumber: otherPartyNumber,
          contents: contents,
          timestamp: DateTime.fromMillisecondsSinceEpoch(timestamp));
    }
  }

  static const TABLE_NAME = "child_message";
  static const COLUMN_ID = "id";
  static const COLUMN_CHAT_ID = "chat_id";
  static const COLUMN_IS_INCOMING = "is_incoming";
  static const COLUMN_OTHER_PARTY_NUMBER = "other_party_number";
  static const COLUMN_CONTENTS = "contents";
  static const COLUMN_TIMESTAMP = "timestamp";
  static const String CREATE_TABLE = "create table $TABLE_NAME ("
      "$COLUMN_ID text primary key,"
      "$COLUMN_CHAT_ID text not null,"
      "$COLUMN_IS_INCOMING tinyint not null,"
      "$COLUMN_OTHER_PARTY_NUMBER text not null,"
      "$COLUMN_CONTENTS text not null,"
      "$COLUMN_TIMESTAMP int not null"
      ");";
}
