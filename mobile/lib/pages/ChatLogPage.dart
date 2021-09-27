import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ChatLogPage extends StatefulWidget {
  const ChatLogPage({Key? key}) : super(key: key);

  @override
  _ChatLogPageState createState() => _ChatLogPageState();
}

class _ChatLogPageState extends State<ChatLogPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("'child names' chat log"),
      ),
      body: SafeArea(
        child: ListView.builder(
            itemCount: 6,
            itemBuilder: (_, index) {
              return _buildChatItem("Liam Mayston");
            }),
      ),
    );
  }

  Widget _buildChatItem(String displayName) {
    return Slidable(
      actionPane: SlidableScrollActionPane(),
      child: ListTile(
        title: Text(displayName),
        onTap: () {
          //TODO: Enter chat
        },
        subtitle: Text("View 'child names' chat with 'recipient'"),
        leading: Icon(
          Icons.account_circle_rounded,
          size: 36,
        ),
        trailing: Icon(Icons.arrow_forward_rounded),
        dense: true,
      ),
      secondaryActions: [
        //TODO: Only make possible if child cant edit own contacts. Or make it a special block that requires pin.
        IconSlideAction(
          caption: "Block for child",
          color: Colors.red,
          icon: Icons.block,
          onTap: () {
            //TODO: block contact on child's phone.
          },
        ),
      ],
    );
  }
}
