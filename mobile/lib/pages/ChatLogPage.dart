import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mobile/controllers/ChatLogPageController.dart';
import 'package:mobile/domain/Child.dart';
import 'package:mobile/domain/ChildChat.dart';
import 'package:mobile/pages/MonitoredChatPage.dart';
import 'package:mobile/widgets/AvatarIcon.dart';

class ChatLogPage extends StatefulWidget {
  final Child child;

  const ChatLogPage({Key? key, required this.child}) : super(key: key);

  @override
  _ChatLogPageState createState() => _ChatLogPageState(child: child);
}

class _ChatLogPageState extends State<ChatLogPage> {
  final ChatLogPageController controller;

  _ChatLogPageState({required Child child})
      : controller = ChatLogPageController(child.phoneNumber);

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Observer(builder: (_) {
          return Text("${controller.model.childName}'s chat log");
        }),
      ),
      body: SafeArea(
        child: Observer(builder: (_) {
          return ListView.builder(
            itemCount: controller.model.sortedChats.length,
            itemBuilder: (_, index) {
              return _buildChatItem(controller.model.sortedChats[index]);
            },
          );
        }),
      ),
    );
  }

  Widget _buildChatItem(ChildChat chat) {
    return Observer(builder: (_) {
      String displayName = chat.otherPartyNumber;
      String profilePicture = "";

      controller.model.contacts.forEach((contact) {
        if (contact.contactPhoneNumber == chat.otherPartyNumber) {
          displayName = contact.name;
          profilePicture = contact.profileImage;
        }
      });

      return Slidable(
        actionPane: SlidableScrollActionPane(),
        child: ListTile(
          title: Text(displayName),
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
              "View ${controller.model.childName}'s chat with $displayName"),
          leading: AvatarIcon.fromString(
            profilePicture,
            radius: 22,
          ),
          trailing: Icon(Icons.arrow_forward_rounded),
          dense: true,
        ),
        secondaryActions: [
          if (!isBlocked(chat.otherPartyNumber))
            IconSlideAction(
              caption: "Block for child",
              color: Colors.red,
              icon: Icons.block,
              onTap: () {
                controller.blockNumber(
                    chat.childPhoneNumber, chat.otherPartyNumber);
              },
            ),
        ],
      );
    });
  }

  bool isBlocked(String number) {
    bool result = false;
    controller.model.blockedNumbrs.forEach((blockedNumber) {
      if (blockedNumber.blockedNumber == number) result = true;
    });
    return result;
  }
}
