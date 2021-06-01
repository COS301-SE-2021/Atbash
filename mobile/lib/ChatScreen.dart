import 'package:flutter/material.dart';

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
        ));
  }

  List<Widget> _buildMessages() {
    List<Widget> messages = [];
    //TODO: populate messages
    return messages;
  }
}

class MessageItem extends StatelessWidget {
  final String _message;

  MessageItem(this._message);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.0, 10.0, 60.0, 10.0),
        child: Expanded(
          child: Text(_message),
        ),
      ),
    );
  }
}

class ChatScreenAppBar extends AppBar {
  ChatScreenAppBar()
      : super(
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

class EmptyProfileIcon extends StatelessWidget {
  final Color _color;

  EmptyProfileIcon(this._color);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        border: Border.all(width: 1, color: _color),
      ),
      padding: EdgeInsets.all(4.0),
      child: Icon(
        Icons.person,
        color: _color,
      ),
    );
  }
}
