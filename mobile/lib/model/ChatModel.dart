import 'dart:collection';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:mobile/domain/Chat.dart';
import 'package:mobile/domain/Message.dart';

class ChatModel extends ChangeNotifier {
  final Chat? _chat;

  ChatModel(this._chat);

  UnmodifiableListView<Message> get messages =>
      _chat?.messages ?? UnmodifiableListView([]);

  void addMessage(String from, String to, String contents) {
    if (contents.replaceAll(" ", "").replaceAll("\n", "").isNotEmpty) {
      _chat?.addMessage(Message(from, to, contents));
      _chat?.addMessage(Message(to, from, randomResponseGenerator()));
    }
    notifyListeners();
  }

  String randomResponseGenerator() {
    List<String> responses = [
      "Hello",
      "k",
      "perfect!",
      "Why don't you love me anymore? I thought we had something special. :(",
      "Bye!",
      "I'm good thanks"
    ];
    Random rnd = Random();
    return responses[rnd.nextInt(responses.length)];
  }
}
