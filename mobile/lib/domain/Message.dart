class Message {
  final String senderPhoneNumber;
  final String recipientPhoneNumber;
  final String contents;
  final DateTime timestamp;

  Message(this.senderPhoneNumber, this.recipientPhoneNumber, this.contents,
      this.timestamp);

  Map<String, dynamic> toMap() {
    return {
      "number_from": senderPhoneNumber,
      "number_to": recipientPhoneNumber,
      "contents": contents,
      "timestamp": timestamp,
    };
  }

  static Message fromMap(Map<String, dynamic> map) {
    final from = map["number_from"] as String;
    final to = map["number_to"] as String;
    final contents = map["contents"] as String;
    final timestamp = map["timestamp"] as int;

    return Message(
      from,
      to,
      contents,
      DateTime.fromMillisecondsSinceEpoch(timestamp),
    );
  }

  static const String TABLE_NAME = "message";
  static const String COLUMN_SENDER_PHONE_NUMBER = "sender_number";
  static const String COLUMN_RECIPIENT_PHONE_NUMBER = "recipient_number";
  static const String COLUMN_CONTENTS = "contents";
  static const String COLUMN_TIMESTAMP = "timestamp";

  static const String CREATE_TABLE =
      "create table $TABLE_NAME ($COLUMN_SENDER_PHONE_NUMBER text not null, $COLUMN_RECIPIENT_PHONE_NUMBER text not null, $COLUMN_CONTENTS text not null, $COLUMN_TIMESTAMP int not null);";
}
