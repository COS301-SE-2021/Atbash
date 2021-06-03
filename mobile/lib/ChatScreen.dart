import 'package:flutter/material.dart';
import 'package:mobile/model/ChatModel.dart';
import 'package:provider/provider.dart';

import 'domain/Contact.dart';
import 'domain/Message.dart';

//Main widget
class ChatScreen extends StatelessWidget {
  final Contact contact;

  ChatScreen(this.contact);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChatScreenAppBar(contact),
      body: SafeArea(
        child: ChangeNotifierProvider(
          create: (context) => ChatModel(contact.chat),
          child: Column(
            children: [Flexible(child: MessageList()), InputBar(contact)],
          ),
        ),
      ),
    );
  }
}

//Widget for list of messages
class MessageList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MessageListState();
  }
}

//State for MessageList
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

  List<Widget> _buildMessages(List<Message> messageList) {
    List<Widget> messageWidgets = [];
    messageList.forEach((element) => messageWidgets.add(MessageItem(element)));
    return messageWidgets;
  }
}

//Widget for input
class InputBar extends StatelessWidget {
  final Contact contact;

  InputBar(this.contact);

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
                        maxLines: 4,
                        minLines: 1,
                        controller: inputController,
                        style: TextStyle(fontSize: 18),
                      ))),
              IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  if (inputController.text
                          .replaceAll("\n", "")
                          .replaceAll(" ", "") !=
                      "") {
                    chat.addMessage(
                        "", contact.phoneNumber, inputController.text);
                  }
                  inputController.text = "";
                },
              )
            ],
          ));
    });
  }
}

//Widget for each individual message
class MessageItem extends StatelessWidget {
  final Message _message;

  MessageItem(this._message);

  @override
  Widget build(BuildContext context) {
    Alignment alignment = Alignment.centerLeft;
    EdgeInsets paddingInset = EdgeInsets.fromLTRB(10.0, 0.0, 40.0, 0.0);

    if (_message.from == "") {
      alignment = Alignment.centerRight;
      paddingInset = EdgeInsets.fromLTRB(40.0, 0.0, 10.0, 0.0);
    }

    return Align(
      alignment: alignment,
      child: Padding(
        padding: paddingInset,
        child: Wrap(
          children: [
            Card(
              color: Colors.green,
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.0, 10.0, 20.0, 10.0),
                child: Text(
                  _message.contents,
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//Widget for AppBar
class ChatScreenAppBar extends AppBar {
  ChatScreenAppBar(Contact contact)
      : super(
          title: Row(
            children: [
              EmptyProfileIcon(Colors.white),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    contact.displayName,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
            ],
          ),
        );
}

//Widget for profile picture
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
