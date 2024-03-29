class ChildMessage {
  final String id;
  final String childPhoneNumber;
  final bool isIncoming;
  final String otherPartyNumber;
  final String contents;
  final DateTime timestamp;
  final bool isMedia;

  ChildMessage(
      {required this.id,
      required this.childPhoneNumber,
      required this.isIncoming,
      required this.otherPartyNumber,
      required this.contents,
      required this.timestamp,
      required this.isMedia});

  Map<String, Object?> toMap() {
    return {
      COLUMN_ID: id,
      COLUMN_CHILD_PHONE_NUMBER: childPhoneNumber,
      COLUMN_IS_INCOMING: isIncoming ? 1 : 0,
      COLUMN_OTHER_PARTY_NUMBER: otherPartyNumber,
      COLUMN_CONTENTS: contents,
      COLUMN_TIMESTAMP: timestamp.millisecondsSinceEpoch,
      COLUMN_IS_MEDIA: isMedia ? 1 : 0,
    };
  }

  Map toJson() => {
        'id': id,
        'childPhoneNumber': childPhoneNumber,
        'isIncoming': isIncoming,
        'otherPartyNumber': otherPartyNumber,
        'contents': contents,
        'timestamp': timestamp.millisecondsSinceEpoch,
        'isMedia': isMedia,
      };

  static ChildMessage? fromMap(Map<String, Object?> map) {
    final id = map[COLUMN_ID] as String?;
    final childPhoneNumber = map[COLUMN_CHILD_PHONE_NUMBER] as String?;
    final isIncoming = map[COLUMN_IS_INCOMING] as int?;
    final otherPartyNumber = map[COLUMN_OTHER_PARTY_NUMBER] as String?;
    final contents = map[COLUMN_CONTENTS] as String?;
    final timestamp = map[COLUMN_TIMESTAMP] as int?;
    final isMedia = map[COLUMN_IS_MEDIA] as int?;

    if (id != null &&
        childPhoneNumber != null &&
        isIncoming != null &&
        otherPartyNumber != null &&
        contents != null &&
        timestamp != null && isMedia != null) {
      return ChildMessage(
          id: id,
          childPhoneNumber: childPhoneNumber,
          isIncoming: isIncoming != 0,
          otherPartyNumber: otherPartyNumber,
          contents: contents,
          timestamp: DateTime.fromMillisecondsSinceEpoch(timestamp),
      isMedia: isMedia != 0);
    }
  }

  static const TABLE_NAME = "child_message";
  static const COLUMN_ID = "id";
  static const COLUMN_CHILD_PHONE_NUMBER = "child_phone_number";
  static const COLUMN_IS_INCOMING = "is_incoming";
  static const COLUMN_OTHER_PARTY_NUMBER = "other_party_number";
  static const COLUMN_CONTENTS = "contents";
  static const COLUMN_TIMESTAMP = "timestamp";
  static const COLUMN_IS_MEDIA = "is_media";
  static const String CREATE_TABLE = "create table $TABLE_NAME ("
      "$COLUMN_ID text primary key,"
      "$COLUMN_CHILD_PHONE_NUMBER text not null,"
      "$COLUMN_IS_INCOMING tinyint not null,"
      "$COLUMN_OTHER_PARTY_NUMBER text not null,"
      "$COLUMN_CONTENTS text not null,"
      "$COLUMN_TIMESTAMP int not null,"
      "$COLUMN_IS_MEDIA tinyint not null"
      ");";
}
