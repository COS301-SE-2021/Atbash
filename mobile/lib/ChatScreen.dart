import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  final List<String> messages = [
    "Hello!",
    "This is a test message.",
    "This is meant to be a very long message to show how the application will react to a long message that doesnt fit.",
    "Goodbye =D"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChatScreenAppBar(),
      body: Column(
        children: [
          Flexible(
              child: ListView(
            children: _buildMessages(),
          )),
          InputBar()
        ],
      ),
    );
  }

  List<Widget> _buildMessages() {
    List<Widget> messageWidgets = [];
    //TODO: populate messages
    messages.forEach((element) => messageWidgets.add(MessageItem(element)));
    return messageWidgets;
  }
}

class InputBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: TextField()),
        IconButton(
          icon: Icon(Icons.send),
          onPressed: () {},
        )
      ],
    );
  }
}

class MessageItem extends StatelessWidget {
  final String _message;

  MessageItem(this._message);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: EdgeInsets.fromLTRB(16.0, 5.0, 60.0, 5.0),
      child: Card(
        color: Colors.green,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.0, 10.0, 20.0, 10.0),
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
