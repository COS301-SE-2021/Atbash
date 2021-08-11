import 'dart:math';

class Message {
  final bool isSender;
  final String contents;
  final DateTime timestamp;

  Message(this.isSender, this.contents, this.timestamp);
}
