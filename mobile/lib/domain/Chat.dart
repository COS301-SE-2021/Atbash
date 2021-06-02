import 'dart:collection';

import 'Message.dart';

class Chat {
  List<Message> _messages = [];

  get messages => UnmodifiableListView<Message>(_messages);

  addMessage(Message message) => _messages.add(message);
}
