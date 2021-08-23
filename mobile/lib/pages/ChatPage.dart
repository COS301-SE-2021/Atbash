import 'package:flutter/material.dart';
import 'package:mobile/observables/ObservableChat.dart';

class ChatPage extends StatefulWidget {
  final ObservableChat chat;

  const ChatPage({
    Key? key,
    required this.chat,
  }) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
