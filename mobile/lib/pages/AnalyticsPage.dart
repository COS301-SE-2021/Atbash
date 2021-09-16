import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobile/constants.dart';
import 'package:mobile/controllers/AnalyticsPageController.dart';
import 'package:mobile/domain/Chat.dart';
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
        child: Observer(
          builder: (_) {
            return ListView(
              children: [
                SizedBox(
                  height: 20,
                ),
                Container(
                  color: Constants.darkGrey.withOpacity(0.88),
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    children: [
                      Text(
                        "Global statistics",
                        style: TextStyle(
                          color: Constants.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ListTile(
                        tileColor: Colors.blueAccent,
                        leading: Icon(
                          Icons.message,
                          color: Constants.orange,
                        ),
                        title: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                    child: Text("Total text messages sent:  ")),
                                Text(controller.model.totalTextMessagesSent
                                    .toString()),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: Text("Total messages received:  ")),
                                Text(controller.model.totalTextMessagesReceived
                                    .toString()),
                              ],
                            )
                          ],
                        ),
                      ),
                      Divider(
                        color: Constants.black,
                        indent: 55,
                        height: 0,
                        thickness: 1.5,
                      ),
                      ListTile(
                        tileColor: Colors.blueAccent,
                        leading: Icon(
                          Icons.photo,
                          color: Constants.orange,
                        ),
                        title: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(child: Text("Total photos sent:  ")),
                                Text(controller.model.totalPhotosSent
                                    .toString()),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: Text("Total photos received:  ")),
                                Text(controller.model.totalPhotosReceived
                                    .toString()),
                              ],
                            )
                          ],
                        ),
                      ),
                      Divider(
                        color: Constants.black,
                        indent: 55,
                        height: 0,
                        thickness: 1.5,
                      ),
                      ListTile(
                        tileColor: Colors.blueAccent,
                        leading: Icon(
                          Icons.favorite,
                          color: Constants.orange,
                        ),
                        title: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                    child: Text("Total messages liked:  ")),
                                Text(controller.model.totalMessagesLiked
                                    .toString()),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        color: Constants.black,
                        indent: 55,
                        height: 0,
                        thickness: 1.5,
                      ),
                      ListTile(
                        tileColor: Colors.blueAccent,
                        leading: Icon(
                          Icons.tag,
                          color: Constants.orange,
                        ),
                        title: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                    child: Text("Total messages tagged:  ")),
                                Text(controller.model.totalMessagesTagged
                                    .toString()),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        color: Constants.black,
                        indent: 55,
                        height: 0,
                        thickness: 1.5,
                      ),
                      ListTile(
                        tileColor: Colors.blueAccent,
                        leading: Icon(
                          Icons.delete,
                          color: Constants.orange,
                        ),
                        title: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                    child: Text("Total messages deleted:  ")),
                                Text(controller.model.totalMessagesDeleted
                                    .toString()),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        color: Constants.black,
                        indent: 55,
                        height: 0,
                        thickness: 1.5,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  color: Constants.darkGrey.withOpacity(0.88),
                  child: Column(
                    children: [
                      Text(
                        "Chats",
                        style: TextStyle(
                          color: Constants.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      _buildContacts(),
                    ],
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildContacts() {
    return Observer(builder: (_) {
      return ListView.builder(
          shrinkWrap: true,
          itemCount: controller.model.chatMessageCount.length,
          itemBuilder: (_, index) {
            return _buildContact(controller.model.chatMessageCount[index]);
          });
    });
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
