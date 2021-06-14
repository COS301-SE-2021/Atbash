import 'dart:convert';

class Message {
  final String from;
  final String to;
  final String contents;

  Message(this.from, this.to, this.contents);

  String encodeBody() {
    final jsonBody = {"from": from, "message": contents};

    return jsonEncode(jsonBody);
  }
}
