import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mobile/controllers/ChatLogPageController.dart';
import 'package:mobile/domain/ChildChat.dart';
import 'package:mobile/pages/MonitoredChatPage.dart';

class ChatLogPage extends StatefulWidget {
  final String phoneNumber;

  const ChatLogPage({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  _ChatLogPageState createState() =>
      _ChatLogPageState(phoneNumber: phoneNumber);
}

class _ChatLogPageState extends State<ChatLogPage> {
  final ChatLogPageController controller;

  _ChatLogPageState({required String phoneNumber})
      : controller = ChatLogPageController(phoneNumber);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${controller.model.childName}'s chat log"),
      ),
      body: SafeArea(
        child: ListView.builder(
            itemCount: controller.model.chats.length,
            itemBuilder: (_, index) {
              return _buildChatItem(controller.model.chats[index]);
            }),
      ),
    );
  }

  Widget _buildChatItem(ChildChat chat) {
    final displayName = chat.otherPartyName;

    return Slidable(
      actionPane: SlidableScrollActionPane(),
      child: ListTile(
        title: Text(displayName == null
            ? chat.otherPartyNumber
            : chat.otherPartyNumber),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MonitoredChatPage(
                chat: chat,
              ),
            ),
          );
        },
        subtitle: Text(
            "View ${controller.model.childName}'s chat with ${displayName == null ? chat.otherPartyNumber : displayName}"),
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
