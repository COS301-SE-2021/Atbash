class ChildsMessages {
  final String id;
  final String chatId;
  final bool isIncoming;
  final String otherPartyNumber;
  final String contents;
  final DateTime timestamp;
  final isMedia = false;

  ChildsMessages(
      {required this.id,
      required this.chatId,
      required this.isIncoming,
      required this.otherPartyNumber,
      required this.contents,
      required this.timestamp});

  static const TABLE_NAME = "childs_messages";
  static const COLUMN_ID = "id";
  static const COLUMN_CHAT_ID = "chat_id";
  static const COLUMN_IS_INCOMING = "is_incoming";
  static const COLUMN_OTHER_PARTY_NUMBER = "other_party_number";
  static const COLUMN_CONTENTS = "contents";
  static const COLUMN_TIMESTAMP = "timestamp";
}
