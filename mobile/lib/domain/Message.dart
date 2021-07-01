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
}
