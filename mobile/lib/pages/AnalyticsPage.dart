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
                        true,
                        topKey: Key("AnalyticsPage_totalMessagesSent"),
                        bottomKey: Key("AnalyticsPage_totalMessagesReceived"),
                      ),
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
                        true,
                        topKey: Key("AnalyticsPage_totalPhotosSent"),
                        bottomKey: Key("AnalyticsPage_totalPhotosReceived"),
                      ),
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
                        false,
                        topKey: Key("AnalyticsPage_totalLikedMessages"),
                      ),
                      Divider(
                        height: 2,
                        thickness: 2,
                      ),
                      // _buildStatisticsWidget(
                      //     "Total messages tagged:",
                      //     null,
                      //     controller.model.totalMessagesTagged,
                      //     null,
                      //     Icons.tag,
                      //     false),
                      // Divider(
                      //   height: 2,
                      //   thickness: 2,
                      // ),
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

  Widget _buildChatItem(Tuple<Chat, int> chat) {
    Contact? contact = chat.first.contact;

    return Column(
      children: [
        ListTile(
          leading: AvatarIcon.fromString(chat.first.contact?.profileImage),
          title: Text(contact != null
              ? contact.displayName.isNotEmpty
                  ? contact.displayName
                  : contact.phoneNumber
              : chat.first.contactPhoneNumber),
          subtitle: Text("Total messages: ${chat.second}"),
        ),
        Divider(
          height: 2,
          thickness: 2,
        ),
      ],
    );
  }

  Widget _buildStatisticsWidget(String topText, String? bottomText, int topStat,
      int? bottomStat, IconData icon, bool twoLines,
      {Key? topKey, Key? bottomKey}) {
    if (bottomStat == null) bottomStat = 0;
    return ListTile(
      title: Column(
        children: [
          Row(children: [
            Text(topText),
            Expanded(child: Container()),
            Text(topStat.toString(), key: topKey)
          ]),
          if (twoLines)
            SizedBox(
              height: 5,
            ),
          if (twoLines)
            Row(children: [
              Text(bottomText ?? ""),
              Expanded(child: Container()),
              Text(bottomStat.toString(), key: bottomKey)
            ]),
        ],
      ),
      leading: Icon(
        icon,
        color: Constants.orange,
      ),
    );
  }
}
