import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile/constants.dart';
import 'package:mobile/controllers/MonitoredChatPageController.dart';
import 'package:mobile/domain/ChildChat.dart';
import 'package:mobile/domain/ChildMessage.dart';
import 'package:intl/intl.dart' as intl;

class MonitoredChatPage extends StatefulWidget {
  final ChildChat chat;

  const MonitoredChatPage({Key? key, required this.chat}) : super(key: key);

  @override
  _MonitoredChatPageState createState() => _MonitoredChatPageState(chat: chat);
}

class _MonitoredChatPageState extends State<MonitoredChatPage> {
  final MonitoredChatPageController controller;

  _MonitoredChatPageState({required ChildChat chat})
      : controller = MonitoredChatPageController(
            //TODO maybe change this to accept a chat entity
            chat.childPhoneNumber,
            chat.otherPartyNumber);

  @override
  Widget build(BuildContext context) {
    final otherName = controller.model.otherMemberName;

    return Scaffold(
      appBar: AppBar(
        title: Text(
            otherName == null ? controller.model.otherMemberNumber : otherName),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(child: _buildMessages()),
          ],
        ),
      ),
    );
  }

  Widget _buildMessages() {
    return ListView.builder(
        itemCount: controller.model.messages.length,
        itemBuilder: (_, index) {
          return Column(
            children: [
              // _chatDateString(index);
              _buildMessage(controller.model.messages[index]),
            ],
          );
          //return _buildMessage();
        });
  }

  Container _buildMessage(ChildMessage message) {
    final dateFormatter = intl.DateFormat("Hm");

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 2.5),
      child: Align(
        alignment: Alignment.centerLeft,
        child: IntrinsicWidth(
          child: Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Constants.orange.withOpacity(0.88),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.7),
                  child: _renderMessageContents(message),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text("${dateFormatter.format(message.timestamp)}",
                      style: TextStyle(fontSize: 10, color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _renderMessageContents(ChildMessage _message) {
    if (_message.isMedia) {
      return Image.memory(
        base64Decode(_message.contents),
        height: 200,
      );
    } else {
      return Text(
        _message.contents,
        style: TextStyle(
          color: Colors.white,
        ),
      );
    }
  }

// Widget _chatDateString(int index) {
//   int numMillisPerDay = 1000 * 60 * 60 * 24;
//
//   int curDay =
//       (controller.model.messages[index].timestamp.millisecondsSinceEpoch /
//               numMillisPerDay)
//           .floor();
//   int prevDay = index == controller.model.messages.length - 1
//       ? 0
//       : (controller.model.messages[index + 1].timestamp
//                   .millisecondsSinceEpoch /
//               numMillisPerDay)
//           .floor();
//
//   int today =
//       (DateTime.now().millisecondsSinceEpoch / numMillisPerDay).floor();
//
//   String date = "";
//
//   if (curDay > prevDay) {
//     if (curDay == today) date = "Today";
//
//     if (today - curDay == 1) date = "Yesterday";
//
//     if (today - curDay < 7)
//       date = DateFormat("EEEE")
//           .format(controller.model.messages[index].timestamp);
//
//     date = DateFormat("EEE, dd MMM")
//         .format(controller.model.messages[index].timestamp);
//   }
//   if (date == "") return Container();
//
//   return Container(
//     margin: EdgeInsets.all(5),
//     padding: EdgeInsets.all(5),
//     decoration: BoxDecoration(
//       color: Constants.white.withOpacity(0.88),
//       borderRadius: BorderRadius.circular(45),
//     ),
//     child: Text(
//       date,
//     ),
//   );
// }
}
