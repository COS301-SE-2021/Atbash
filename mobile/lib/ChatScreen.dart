import 'package:flutter/material.dart';

import 'MainScreen.dart';

class ChatScreen extends StatelessWidget {
  final List<String> messages = [
    "Hello!",
    "This is a test message.",
    "Goodbye =D"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: ChatScreenAppBar(),
        body: Card(
          child: ListView(
            children: _buildMessages(),
          ),
        )
    );
  }

  List<Widget> _buildMessages() {
    List<Widget> messages = [];
    //TODO: populate messages
    return messages;
  }
}

class ChatScreenAppBar extends AppBar {
  ChatScreenAppBar() : super(
    title: Row(
      children: [
        EmptyProfileIcon(Colors.white),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Joshua",
              overflow: TextOverflow.ellipsis,
            ),
          ),
        )
      ],
    ),
  );
}
