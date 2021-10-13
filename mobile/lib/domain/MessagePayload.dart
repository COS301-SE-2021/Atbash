class MessagePayload {
  final String id;
  final String senderPhoneNumber;
  final String recipientPhoneNumber;
  final String contents;

  MessagePayload({
    required this.id,
    required this.senderPhoneNumber,
    required this.recipientPhoneNumber,
    required this.contents,
  });

  Map<String, Object> get asMap => {
    "id": id,
    "senderPhoneNumber": senderPhoneNumber,
    "recipientPhoneNumber": recipientPhoneNumber,
    "contents": contents
  };

  Map<String, dynamic> toMap() {
    return {
      COLUMN_ID: this.id,
      COLUMN_SENDER_PHONE_NUMBER: this.senderPhoneNumber,
      COLUMN_RECEIPIENT_PHONE_NUMBER: this.recipientPhoneNumber,
      COLUMN_CONTENTS: this.contents,
    };
  }

  static MessagePayload? fromMap(Map<String, Object?> map) {
    final id = map[MessagePayload.COLUMN_ID];
    final senderPhoneNumber = map[MessagePayload.COLUMN_SENDER_PHONE_NUMBER];
    final recipientPhoneNumber = map[MessagePayload.COLUMN_RECEIPIENT_PHONE_NUMBER];
    final contents = map[MessagePayload.COLUMN_CONTENTS];

    if (id is String && senderPhoneNumber is String && recipientPhoneNumber is String && contents is String) {
      return MessagePayload(id: id, senderPhoneNumber: senderPhoneNumber, recipientPhoneNumber: recipientPhoneNumber, contents: contents);
    } else {
      return null;
    }
  }

  static const String TABLE_NAME = "message_payload";
  static const String COLUMN_ID = "message_id";
  static const String COLUMN_SENDER_PHONE_NUMBER =
      "sender_phone_number";
  static const String COLUMN_RECEIPIENT_PHONE_NUMBER =
      "receipient_phone_number";
  static const String COLUMN_CONTENTS = "contents";

  static const String CREATE_TABLE =
      "create table $TABLE_NAME ($COLUMN_ID text not null, $COLUMN_SENDER_PHONE_NUMBER text not null, $COLUMN_RECEIPIENT_PHONE_NUMBER text not null, $COLUMN_CONTENTS text not null, PRIMARY KEY ($COLUMN_ID));";
}
