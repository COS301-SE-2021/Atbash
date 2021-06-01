import 'dart:collection';

import 'package:flutter/foundation.dart';

class ChatModel extends ChangeNotifier
{
  final List<String> _messages = [];

  UnmodifiableListView<String> get messages => UnmodifiableListView(_messages);

  void addMessage(String message){
    _messages.add(message);
    notifyListeners();
  }
}