class Message {
  final String id;
  final String numberFrom;
  final String numberTo;
  final String contents;

  Message(this.id, this.numberFrom, this.numberTo, this.contents);

  Map<String, String> toMap() {
    return {
      "id": id,
      "number_from": numberFrom,
      "number_to": numberTo,
      "contents": contents,
    };
  }

  static Message fromMap(Map<String, dynamic> map) {
    final id = map["id"] as String;
    final from = map["number_from"] as String;
    final to = map["number_to"] as String;
    final contents = map["contents"] as String;

    return Message(id, from, to, contents);
  }
}
