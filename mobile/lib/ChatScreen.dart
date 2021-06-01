import 'package:flutter/material.dart';
import 'package:mobile/model/ChatModel.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChatScreenAppBar(),
      body: ChangeNotifierProvider(
        create: (context) => ChatModel(),
        child: Column(
          children: [Flexible(child: MessageList()), InputBar()],
        ),
      ),
    );
  }
}

class MessageList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MessageListState();
  }
}

class _MessageListState extends State<MessageList> {
  _MessageListState();

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatModel>(builder: (context, chat, child) {
      return ListView(
        children: _buildMessages(chat.messages),
      );
    });
  }

  List<Widget> _buildMessages(List<String> messageList) {
    List<Widget> messageWidgets = [];
    messageList.forEach((element) => messageWidgets.add(MessageItem(element)));
    return messageWidgets;
  }
}

class InputBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final inputController = TextEditingController();

    return Consumer<ChatModel>(builder: (context, chat, child) {
      return Container(
          color: Colors.green,
          child: Row(
            children: [
              Expanded(
                  child: Card(
                      color: Colors.white54,
                      child: TextField(
                        controller: inputController,
                        style: TextStyle(fontSize: 18),
                      ))),
              IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  chat.addMessage(inputController.text);
                  inputController.text = "";
                },
              )
            ],
          ));
    });
  }
}

class MessageItem extends StatelessWidget {
  final String _message;

  MessageItem(this._message);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: EdgeInsets.fromLTRB(30.0, 0.0, 10.0, 0.0),
        child: Wrap(
          children: [
            Card(
              color: Colors.green,
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.0, 10.0, 20.0, 10.0),
                child: Text(
                  _message,
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

// EdgeInsets generateTextPadding()
// {
//   double leftPadding =
//   return EdgeInsets.fromLTRB(120.0, 5.0, 16.0, 5.0);
// }
}

class ChatScreenAppBar extends AppBar {
  ChatScreenAppBar()
      : super(
          title: Row(
            children: [
              IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back)),
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
