import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobile/constants.dart';
import 'package:mobile/controllers/AnalyticsPageController.dart';
import 'package:mobile/domain/Chat.dart';
import 'package:mobile/domain/Contact.dart';
import 'package:mobile/util/Tuple.dart';
import 'package:mobile/widgets/AvatarIcon.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({Key? key}) : super(key: key);

  @override
  _AnalyticsPageState createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  final AnalyticsPageController controller;

  _AnalyticsPageState() : controller = AnalyticsPageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Analytics"),
      ),
      body: SafeArea(
        child: Observer(builder: (_) {
          return Column(
            children: [
              Container(
                alignment: Alignment.center,
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 5),
                color: Constants.darkGrey,
                child: Text(
                  "General Statistics",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  child: ListView(
                    children: [
                      _buildStatisticsWidget(
                          "Total text messages sent:",
                          "Total messages received:",
                          controller.model.totalTextMessagesSent,
                          controller.model.totalTextMessagesReceived,
                          Icons.chat,
                          true),
                      Divider(
                        height: 2,
                        thickness: 2,
                      ),
                      _buildStatisticsWidget(
                          "Total photos sent:",
                          "Total photos received:",
                          controller.model.totalPhotosSent,
                          controller.model.totalPhotosReceived,
                          Icons.photo,
                          true),
                      Divider(
                        height: 2,
                        thickness: 2,
                      ),
                      _buildStatisticsWidget(
                          "Total messages liked:",
                          null,
                          controller.model.totalMessagesLiked,
                          null,
                          Icons.favorite,
                          false),
                      Divider(
                        height: 2,
                        thickness: 2,
                      ),
                      _buildStatisticsWidget(
                          "Total messages tagged:",
                          null,
                          controller.model.totalMessagesTagged,
                          null,
                          Icons.tag,
                          false),
                      Divider(
                        height: 2,
                        thickness: 2,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 5),
                color: Constants.darkGrey,
                child: Text(
                  "Chat Statistics",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  child: ListView.builder(
                      itemCount: controller.model.chatMessageCount.length,
                      itemBuilder: (BuildContext context, int index) {
                        return _buildChatItem(
                            controller.model.chatMessageCount[index]);
                      }),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildContact(Tuple<Chat, int> chat) {
    final contact = chat.first.contact;
    return Column(
      children: [
        Divider(
          color: Constants.black,
          indent: 55,
          height: 0,
          thickness: 1.5,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Container(
            height: 50,
            child: Row(
              children: [
                AvatarIcon.fromString(chat.first.contact?.profileImage),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(contact != null
                        ? contact.displayName.isNotEmpty
                            ? contact.displayName
                            : contact.phoneNumber
                        : chat.first.contactPhoneNumber),
                  ),
                ),
                Text(chat.second.toString()),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
