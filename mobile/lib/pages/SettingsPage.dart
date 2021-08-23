import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/constants.dart';
import 'package:mobile/models/SettingsModel.dart';
import 'package:mobile/models/UserModel.dart';
import 'package:mobile/pages/ContactEditPage.dart';

import 'package:mobile/widgets/AvatarIcon.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final UserModel _userModel = GetIt.I.get();
  final SettingsModel _settingsModel = GetIt.I.get();

  @override
  Widget build(BuildContext context) {
    final _status = _userModel.status;
    final _displayName = _userModel.displayName;

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
                          builder: (context) => ContactEditPage()));
                },
                child: Container(
                  padding: EdgeInsets.all(15),
                  child: Row(
                    children: [
                      AvatarIcon.fromString(
                        _userModel.profileImage,
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
                              _displayName != null ? _displayName : "",
                              style: TextStyle(fontSize: 20),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Text(
                              _status != null ? _status : "",
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
                value: _settingsModel.blurImages,
                onChanged: (bool newValue) {
                  _settingsModel.setBlurImages(newValue);
                },
                title: Text(
                  "Blur images",
                  style: TextStyle(fontSize: 16),
                ),
                secondary: Icon(
                  Icons.remove_red_eye_outlined,
                  color: Constants.orangeColor,
                ),
                dense: true,
                subtitle: Text(
                    "Blur images by default. Images can still be viewed if selected"),
              ),
              SwitchListTile(
                value: _settingsModel.safeMode,
                onChanged: (bool newValue) {
                  //TODO Create Pin logic
                  _settingsModel.setSafeMode(newValue, "Pin");
                },
                title: Text(
                  "Safe chat",
                  style: TextStyle(fontSize: 16),
                ),
                secondary: Icon(
                  Icons.health_and_safety,
                  color: Constants.orangeColor,
                ),
                dense: true,
                subtitle: Text(
                    "Enable safety features for all chats. Including profanity filters for text and media"),
              ),
              SwitchListTile(
                value: _settingsModel.shareProfileImage,
                onChanged: (bool newValue) {
                  _settingsModel.setShareProfileImage(newValue);
                },
                title: Text(
                  "Profile photo",
                  style: TextStyle(fontSize: 16),
                ),
                secondary: Icon(
                  Icons.photo,
                  color: Constants.orangeColor,
                ),
                dense: true,
                subtitle: Text(
                    "Enable or disable whether your profile photo is visible to others"),
              ),
              SwitchListTile(
                value: _settingsModel.shareStatus,
                onChanged: (bool newValue) {
                  _settingsModel.setShareStatus(newValue);
                },
                title: Text(
                  "Status",
                  style: TextStyle(fontSize: 16),
                ),
                secondary: Icon(
                  Icons.wysiwyg,
                  color: Constants.orangeColor,
                ),
                dense: true,
                subtitle: Text(
                    "Enable or disable whether your profile photo is visible to others"),
              ),
              SwitchListTile(
                value: _settingsModel.shareReadReceipts,
                onChanged: (bool newValue) {
                  _settingsModel.setShareReadReceipts(newValue);
                },
                title: Text(
                  "Read receipts",
                  style: TextStyle(fontSize: 16),
                ),
                secondary: Icon(
                  Icons.done_all,
                  color: Constants.orangeColor,
                ),
                dense: true,
                subtitle: Text(
                    "Choose whether others can see if you've read their messages"),
              ),
              ListTile(
                leading: Icon(
                  Icons.block,
                  color: Constants.orangeColor,
                ),
                title: Text(
                  "Blocked contacts",
                  style: TextStyle(fontSize: 16),
                ),
                subtitle: Text("View a list of all blocked contacts"),
                trailing: Icon(Icons.arrow_forward_rounded),
                onTap: () {
                  //TODO Transfer to blocked contacts page
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
                  Icons.contact_phone,
                  color: Constants.orangeColor,
                ),
                title: Text(
                  "Change Number",
                  style: TextStyle(fontSize: 16),
                ),
                trailing: Icon(Icons.arrow_forward_rounded),
                onTap: () {
                  //TODO Change Number Logic
                },
                dense: true,
              ),
              ListTile(
                leading: Icon(
                  Icons.delete_forever,
                  color: Constants.orangeColor,
                ),
                title: Text(
                  "Delete Account",
                  style: TextStyle(fontSize: 16),
                ),
                trailing: Icon(Icons.arrow_forward_rounded),
                onTap: () {
                  //TODO Delete Account Logic
                },
                dense: true,
              ),
              Container(
                padding: EdgeInsets.all(15),
                child: Text(
                  "Notifications",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              SwitchListTile(
                value: _settingsModel.showNotifications,
                onChanged: (bool newValue) {
                  _settingsModel.setShowNotifications(newValue);
                },
                title: Text(
                  "Show notifications",
                  style: TextStyle(fontSize: 16),
                ),
                secondary: Icon(
                  Icons.notifications_active,
                  color: Constants.orangeColor,
                ),
                dense: true,
              ),
              SwitchListTile(
                value: _settingsModel.playNotificationsSound,
                onChanged: (bool newValue) {
                  _settingsModel.setPlayNotificationsSound(newValue);
                },
                title: Text(
                  "Notification sounds",
                  style: TextStyle(fontSize: 16),
                ),
                secondary: Icon(
                  Icons.multitrack_audio,
                  color: Constants.orangeColor,
                ),
                dense: true,
              ),
              SwitchListTile(
                value: _settingsModel.showMessagePreview,
                onChanged: (bool newValue) {
                  _settingsModel.setShowMessagePreview(newValue);
                },
                title: Text(
                  "Message preview",
                  style: TextStyle(fontSize: 16),
                ),
                secondary: Icon(
                  Icons.multitrack_audio,
                  color: Constants.orangeColor,
                ),
                dense: true,
                subtitle: Text(
                    "Display a preview of the message in the notification"),
              ),
              Container(
                padding: EdgeInsets.all(15),
                child: Text(
                  "Media auto-download",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              SwitchListTile(
                value: _settingsModel.autoDownloadMedia,
                onChanged: (bool newValue) {
                  _settingsModel.setAutoDownloadMedia(newValue);
                },
                title: Text(
                  "Photos",
                  style: TextStyle(fontSize: 16),
                ),
                dense: true,
              ),
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
                  color: Constants.orangeColor,
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
