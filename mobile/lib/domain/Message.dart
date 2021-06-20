class Message {
  final String id;
  final String numberFrom;
  final String numberTo;
  final String contents;
  final int timestamp;

  Message(
      this.id, this.numberFrom, this.numberTo, this.contents, this.timestamp);

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "number_from": numberFrom,
      "number_to": numberTo,
      "contents": contents,
      "timestamp": timestamp,
    };
  }

  static Message fromMap(Map<String, dynamic> map) {
    final id = map["id"] as String;
    final from = map["number_from"] as String;
    final to = map["number_to"] as String;
    final contents = map["contents"] as String;
    final timestamp = map["timestamp"] as int;

    return Message(id, from, to, contents, timestamp);
  }
}
