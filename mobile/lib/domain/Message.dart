class Message {
  final String id;
  final String senderPhoneNumber;
  final String recipientPhoneNumber;
  final String contents;
  final DateTime timestamp;

  Message(
    this.id,
    this.senderPhoneNumber,
    this.recipientPhoneNumber,
    this.contents,
    this.timestamp,
  );

  Map<String, dynamic> toMap() {
    return {
      COLUMN_ID: this.id,
      COLUMN_SENDER_PHONE_NUMBER: this.senderPhoneNumber,
      COLUMN_RECIPIENT_PHONE_NUMBER: this.recipientPhoneNumber,
      COLUMN_CONTENTS: this.contents,
      COLUMN_TIMESTAMP: this.timestamp.millisecondsSinceEpoch
    };
  }

  static Message? fromMap(Map<String, Object?> map) {
    final id = map[Message.COLUMN_ID];
    final senderPhoneNumber = map[Message.COLUMN_SENDER_PHONE_NUMBER];
    final recipientPhoneNumber = map[Message.COLUMN_RECIPIENT_PHONE_NUMBER];
    final contents = map[Message.COLUMN_CONTENTS];
    final timestamp = map[Message.COLUMN_TIMESTAMP];

    if (id is String &&
        senderPhoneNumber is String &&
        recipientPhoneNumber is String &&
        contents is String &&
        timestamp is int) {
      return Message(
        id,
        senderPhoneNumber,
        recipientPhoneNumber,
        contents,
        DateTime.fromMillisecondsSinceEpoch(timestamp),
      );
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

  static const String CREATE_TABLE =
      "create table $TABLE_NAME ($COLUMN_ID text primary key, $COLUMN_SENDER_PHONE_NUMBER text not null, $COLUMN_RECIPIENT_PHONE_NUMBER text not null, $COLUMN_CONTENTS text not null, $COLUMN_TIMESTAMP int not null);";
}
