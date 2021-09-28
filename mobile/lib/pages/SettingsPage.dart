import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobile/constants.dart';
import 'package:mobile/controllers/SettingsPageController.dart';
import 'package:mobile/pages/AnalyticsPage.dart';
import 'package:mobile/pages/BlockedContactsPage.dart';
import 'package:mobile/pages/ParentalSettingsPage.dart';
import 'package:mobile/pages/ProfanityFilterListPage.dart';
import 'package:mobile/pages/ProfileSettingsPage.dart';
import 'package:mobile/pages/WallpaperPage.dart';
import 'package:mobile/util/Utils.dart';

import 'package:mobile/widgets/AvatarIcon.dart';
import 'package:url_launcher/url_launcher.dart';

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
                              key: Key("SettingsPage_displayName"),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Text(
                              controller.model.userStatus,
                              style: TextStyle(fontSize: 14),
                              key: Key("SettingsPage_status"),
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
                margin: EdgeInsets.symmetric(horizontal: 20),
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black)),
                child: Text(
                  "Privacy settings have been disabled. Please contact \n'phone number'\nto allow access.",
                  textAlign: TextAlign.center,
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
                key: Key("blurImages"),
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
                key: Key("safeMode"),
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
                key: Key("sharedProfilePicture"),
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
                key: Key("shareStatus"),
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
                key: Key("shareBirthday"),
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
                key: Key("shareReadReceipts"),
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
                  Icons.admin_panel_settings_sharp,
                  color: Constants.orange,
                ),
                title: Text(
                  "Profanity Filtering List",
                  style: TextStyle(fontSize: 16),
                ),
                subtitle: Text("Add or remove words from the profanity filter"),
                trailing: Icon(Icons.arrow_forward_rounded),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfanityFilterListPage()));
                },
                dense: true,
              ),
              ListTile(
                key: Key("blockedContacts"),
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
                  Icons.perm_contact_calendar_rounded,
                  color: Constants.orange,
                ),
                title: Text(
                  "Parental Controls",
                  style: TextStyle(fontSize: 16),
                ),
                trailing: Icon(Icons.arrow_forward_rounded),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => ParentalSettingsPage()),
                  );
                },
                dense: true,
              ),
              ListTile(
                key: Key("changeWallpaper"),
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
                key: Key("chatAnalytics"),
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
                key: Key("importContacts"),
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
                key: Key("disableNotifications"),
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
                key: Key("disableMessagePreview"),
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
                key: Key("help"),
                leading: Icon(
                  Icons.help,
                  color: Constants.orange,
                ),
                title: Text(
                  "User Manual",
                  style: TextStyle(fontSize: 16),
                ),
                trailing: Icon(Icons.arrow_forward_rounded),
                onTap: () async {
                  if (await canLaunch(Constants.userManualUrl)) {
                    await launch(Constants.userManualUrl);
                  } else {
                    showSnackBar(context, "Could not open User Manual");
                  }
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
