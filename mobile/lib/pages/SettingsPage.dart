import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobile/constants.dart';
import 'package:mobile/controllers/SettingsPageController.dart';
import 'package:mobile/pages/AnalyticsPage.dart';
import 'package:mobile/pages/BlockedContactsPage.dart';
import 'package:mobile/pages/ProfileSettingsPage.dart';
import 'package:mobile/pages/WallpaperPage.dart';

import 'package:mobile/widgets/AvatarIcon.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final SettingsPageController controller;

  _SettingsPageState() : controller = SettingsPageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: SafeArea(
        child: Observer(builder: (_) {
          return ListView(
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileSettingsPage(
                        setup: false,
                      ),
                    ),
                  ).then((_) => controller.reload());
                },
                child: Container(
                  padding: EdgeInsets.all(15),
                  child: Row(
                    children: [
                      AvatarIcon(
                        controller.model.userProfilePicture,
                        radius: 24,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              controller.model.userName,
                              style: TextStyle(fontSize: 20),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Text(
                              controller.model.userStatus,
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 24,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(15),
                child: Text(
                  "Privacy",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              SwitchListTile(
                value: controller.model.blurImages,
                onChanged: (bool newValue) {
                  controller.setBlurImages(newValue);
                },
                title: Text(
                  "Hide images",
                  style: TextStyle(fontSize: 16),
                ),
                secondary: Icon(
                  Icons.remove_red_eye_outlined,
                  color: Constants.orange,
                ),
                dense: true,
                subtitle: Text(
                    "Hide images by default. Images can still be viewed if selected"),
              ),
              SwitchListTile(
                value: controller.model.safeMode,
                onChanged: (bool newValue) {
                  //TODO Create Pin logic
                  controller.setSafeMode(newValue, "Pin");
                },
                title: Text(
                  "Profanity Filter",
                  style: TextStyle(fontSize: 16),
                ),
                secondary: Icon(
                  Icons.health_and_safety,
                  color: Constants.orange,
                ),
                dense: true,
                subtitle: Text("Enables text profanity filter for all chats"),
              ),
              SwitchListTile(
                value: controller.model.sharedProfilePicture,
                onChanged: (bool newValue) {
                  controller.setSharedProfilePicture(newValue);
                },
                title: Text(
                  "Don't share profile photo",
                  style: TextStyle(fontSize: 16),
                ),
                secondary: Icon(
                  Icons.photo,
                  color: Constants.orange,
                ),
                dense: true,
                subtitle: Text(
                    "Enable or disable whether your profile photo is visible to others"),
              ),
              SwitchListTile(
                value: controller.model.shareStatus,
                onChanged: (bool newValue) {
                  controller.setShareStatus(newValue);
                },
                title: Text(
                  "Don't share status",
                  style: TextStyle(fontSize: 16),
                ),
                secondary: Icon(
                  Icons.wysiwyg,
                  color: Constants.orange,
                ),
                dense: true,
                subtitle: Text(
                    "Enable or disable whether your status is visible to others"),
              ),
              SwitchListTile(
                value: controller.model.shareBirthday,
                onChanged: (bool newValue) {
                  controller.setShareBirthday(newValue);
                },
                title: Text(
                  "Don't share birthday",
                  style: TextStyle(fontSize: 16),
                ),
                secondary: Icon(
                  Icons.cake,
                  color: Constants.orange,
                ),
                dense: true,
                subtitle: Text(
                    "Choose whether you want to share your birthday to contacts"),
              ),
              SwitchListTile(
                value: controller.model.shareReadReceipts,
                onChanged: (bool newValue) {
                  controller.setShareReadReceipts(newValue);
                },
                title: Text(
                  "Don't share read receipts",
                  style: TextStyle(fontSize: 16),
                ),
                secondary: Icon(
                  Icons.done_all,
                  color: Constants.orange,
                ),
                dense: true,
                subtitle: Text(
                    "Choose whether others can see if you've read their messages"),
              ),
              ListTile(
                leading: Icon(
                  Icons.block,
                  color: Constants.orange,
                ),
                title: Text(
                  "Blocked contacts",
                  style: TextStyle(fontSize: 16),
                ),
                subtitle: Text("View a list of all blocked contacts"),
                trailing: Icon(Icons.arrow_forward_rounded),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BlockedContactsPage()));
                },
                dense: true,
              ),
              Container(
                padding: EdgeInsets.all(15),
                child: Text(
                  "Account",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.wallpaper,
                  color: Constants.orange,
                ),
                title: Text(
                  "Change Wallpaper",
                  style: TextStyle(fontSize: 16),
                ),
                trailing: Icon(Icons.arrow_forward_rounded),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => WallpaperPage()),
                  );
                },
                dense: true,
              ),
              ListTile(
                leading: Icon(
                  Icons.analytics,
                  color: Constants.orange,
                ),
                title: Text(
                  "Chat Analytics",
                  style: TextStyle(fontSize: 16),
                ),
                trailing: Icon(Icons.arrow_forward_rounded),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => AnalyticsPage()));
                },
                dense: true,
              ),
              ListTile(
                leading: Icon(
                  Icons.import_contacts,
                  color: Constants.orange,
                ),
                title: Text(
                  "Import Contacts",
                  style: TextStyle(fontSize: 16),
                ),
                onTap: () {
                  controller.importContacts();
                },
                dense: true,
              ),
              // ListTile(
              //   leading: Icon(
              //     Icons.delete_forever,
              //     color: Constants.orange,
              //   ),
              //   title: Text(
              //     "Delete Account",
              //     style: TextStyle(fontSize: 16),
              //   ),
              //   trailing: Icon(Icons.arrow_forward_rounded),
              //   onTap: () {
              //     //TODO Delete Account Logic
              //   },
              //   dense: true,
              // ),
              Container(
                padding: EdgeInsets.all(15),
                child: Text(
                  "Notifications",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              SwitchListTile(
                value: controller.model.disableNotifications,
                onChanged: (bool newValue) {
                  controller.setDisableNotifications(newValue);
                },
                title: Text(
                  "Disable notifications",
                  style: TextStyle(fontSize: 16),
                ),
                secondary: Icon(
                  Icons.notifications_active,
                  color: Constants.orange,
                ),
                dense: true,
              ),
              SwitchListTile(
                value: controller.model.disableMessagePreview,
                onChanged: controller.model.disableNotifications
                    ? null
                    : (bool newValue) {
                        controller.setDisableMessagePreview(newValue);
                      },
                title: Text(
                  "Disable message preview",
                  style: TextStyle(fontSize: 16),
                ),
                secondary: Icon(
                  Icons.multitrack_audio,
                  color: Constants.orange,
                ),
                dense: true,
                subtitle: Text(
                    "Display a preview of the message in the notification"),
              ),
              //TODO:Re-enable auto download when complete
              // Container(
              //   padding: EdgeInsets.all(15),
              //   child: Text(
              //     "Media auto-download",
              //     style: TextStyle(fontSize: 20),
              //   ),
              // ),
              // SwitchListTile(
              //   value: controller.model.autoDownloadMedia,
              //   onChanged: (bool newValue) {
              //     controller.setAutoDownloadMedia(newValue);
              //   },
              //   title: Text(
              //     "Photos",
              //     style: TextStyle(fontSize: 16),
              //   ),
              //   dense: true,
              // ),
              Container(
                padding: EdgeInsets.all(15),
                child: Text(
                  "Help",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.help,
                  color: Constants.orange,
                ),
                title: Text(
                  "User Manual",
                  style: TextStyle(fontSize: 16),
                ),
                trailing: Icon(Icons.arrow_forward_rounded),
                onTap: () {
                  //TODO Navigate to help page
                },
                dense: true,
              ),
            ],
          );
        }),
      ),
    );
  }
}
