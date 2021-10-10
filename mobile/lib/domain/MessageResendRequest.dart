class MessageResendRequest {
  final String id;
  final String senderPhoneNumber;
  final int originalTimestamp;

  MessageResendRequest({
    required this.id,
    required this.senderPhoneNumber,
    required this.originalTimestamp,
  });

  Map<String, Object> get asMap => {
    "id": id,
    "senderPhoneNumber": senderPhoneNumber,
    "originalTimestamp": originalTimestamp
  };

  Map<String, dynamic> toMap() {
    return {
      COLUMN_ID: this.id,
      COLUMN_SENDER_PHONE_NUMBER: this.senderPhoneNumber,
      COLUMN_ORIGINAL_TIMESTAMP: this.originalTimestamp
    };
  }

  static MessageResendRequest? fromMap(Map<String, Object?> map) {
    final id = map[MessageResendRequest.COLUMN_ID];
    final senderPhoneNumber = map[MessageResendRequest.COLUMN_SENDER_PHONE_NUMBER];
    final originalTimestamp = map[MessageResendRequest.COLUMN_ORIGINAL_TIMESTAMP] as int?;

    if (id is String && senderPhoneNumber is String && originalTimestamp is int) {
      return MessageResendRequest(id: id, senderPhoneNumber: senderPhoneNumber, originalTimestamp: originalTimestamp);
    } else {
      return null;
    }
  }

  static const String TABLE_NAME = "message_resend_request";
  static const String COLUMN_ID = "message_id";
  static const String COLUMN_SENDER_PHONE_NUMBER =
      "sender_phone_number";
  static const String COLUMN_ORIGINAL_TIMESTAMP =
      "original_timestamp";

  static const String CREATE_TABLE =
      "create table $TABLE_NAME ($COLUMN_ID text not null, $COLUMN_SENDER_PHONE_NUMBER text not null, $COLUMN_ORIGINAL_TIMESTAMP int not null, PRIMARY KEY ($COLUMN_ID));";
}
