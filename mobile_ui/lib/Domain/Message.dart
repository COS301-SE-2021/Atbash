import 'dart:math';

class Message {
  final bool isSender;
  final String contents;
  final DateTime timestamp;
  final bool isLiked;

  Message(this.isSender, this.contents, this.timestamp, {this.isLiked = false});
}

Random rnd = new Random(3);

List messages = [
  Message(
      true, "Hey!", DateTime.now().add(Duration(seconds: rnd.nextInt(100)))),
  Message(
      false,
      "Hi! This message is mean to be very long to show what happens.",
      DateTime.now().add(Duration(seconds: rnd.nextInt(100))),
      isLiked: true),
  Message(true, "You're so cool!",
      DateTime.now().add(Duration(seconds: rnd.nextInt(100)))),
  Message(true, "And super pretty!",
      DateTime.now().add(Duration(seconds: rnd.nextInt(100)))),
  Message(false, "Thanks! You are too!",
      DateTime.now().add(Duration(seconds: rnd.nextInt(100)))),
  Message(false, "a", DateTime.now().add(Duration(seconds: rnd.nextInt(100)))),
  Message(
      false,
      "I have to go, See you later. This message is mean to be very long to show what happens.",
      DateTime.now().add(Duration(seconds: rnd.nextInt(100)))),
  Message(
      true,
      "Thank you. Bye now. This message is mean to be very long to show what happens.",
      DateTime.now().add(Duration(seconds: rnd.nextInt(100)))),
  Message(false, "Thanks! You are too!",
      DateTime.now().add(Duration(seconds: rnd.nextInt(100)))),
  Message(false, "a", DateTime.now().add(Duration(seconds: rnd.nextInt(100))),
      isLiked: true),
  Message(
      false,
      "I have to go, See you later. This message is mean to be very long to show what happens.",
      DateTime.now().add(Duration(seconds: rnd.nextInt(100)))),
  Message(
      true,
      "Thank you. Bye now. This message is mean to be very long to show what happens.",
      DateTime.now().add(Duration(seconds: rnd.nextInt(100))))
];
