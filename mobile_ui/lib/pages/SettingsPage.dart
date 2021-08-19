import 'package:flutter/material.dart';
import 'package:mobile_ui/Domain/constants.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  //bool _darkModeIsSelected = false;
  bool _blurredImagesIsSelected = false;
  bool _safeChatIsSelected = false;
  bool _profileImageVisibleIsSelected = false;
  bool _statusVisibleIsSelected = false;
  bool _readReceiptsIsSelected = false;

  bool _showNotificationsIsSelected = false;
  bool _notificationSoundsEnabledIsSelected = false;
  bool _showMessagePreviewIsSelected = false;
  bool _photoAutoDownloadIsSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            InkWell(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.all(15),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.orange,
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
                            "Liam Mayston",
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Text(
                            "Available",
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
            // SwitchListTile(
            //   value: _darkModeIsSelected,
            //   onChanged: (bool newValue) {
            //     setState(() {
            //       _darkModeIsSelected = !_darkModeIsSelected;
            //     });
            //   },
            //   title: Text(
            //     "Dark mode",
            //     style: TextStyle(fontSize: 16),
            //   ),
            //   secondary: Icon(
            //     Icons.dark_mode_rounded,
            //     color: Constants.orangeColor,
            //   ),
            //   dense: true,
            // ),
            Container(
              padding: EdgeInsets.all(15),
              child: Text(
                "Privacy",
                style: TextStyle(fontSize: 20),
              ),
            ),
            SwitchListTile(
              value: _blurredImagesIsSelected,
              onChanged: (bool newValue) {
                setState(() {
                  _blurredImagesIsSelected = !_blurredImagesIsSelected;
                });
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
              value: _safeChatIsSelected,
              onChanged: (bool newValue) {
                setState(() {
                  _safeChatIsSelected = !_safeChatIsSelected;
                });
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
              value: _profileImageVisibleIsSelected,
              onChanged: (bool newValue) {
                setState(() {
                  _profileImageVisibleIsSelected =
                      !_profileImageVisibleIsSelected;
                });
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
              value: _statusVisibleIsSelected,
              onChanged: (bool newValue) {
                setState(() {
                  _statusVisibleIsSelected = !_statusVisibleIsSelected;
                });
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
              value: _readReceiptsIsSelected,
              onChanged: (bool newValue) {
                setState(() {
                  _readReceiptsIsSelected = !_readReceiptsIsSelected;
                });
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
              onTap: () {},
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
              onTap: () {},
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
              onTap: () {},
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
              value: _showNotificationsIsSelected,
              onChanged: (bool newValue) {
                setState(() {
                  _showNotificationsIsSelected = !_showNotificationsIsSelected;
                });
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
              value: _notificationSoundsEnabledIsSelected,
              onChanged: (bool newValue) {
                setState(() {
                  _notificationSoundsEnabledIsSelected =
                      !_notificationSoundsEnabledIsSelected;
                });
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
              value: _showMessagePreviewIsSelected,
              onChanged: (bool newValue) {
                setState(() {
                  _showMessagePreviewIsSelected =
                      !_showMessagePreviewIsSelected;
                });
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
              subtitle:
                  Text("Display a preview of the message in the notification"),
            ),
            Container(
              padding: EdgeInsets.all(15),
              child: Text(
                "Media auto-download",
                style: TextStyle(fontSize: 20),
              ),
            ),
            SwitchListTile(
              value: _photoAutoDownloadIsSelected,
              onChanged: (bool newValue) {
                setState(() {
                  _photoAutoDownloadIsSelected = !_photoAutoDownloadIsSelected;
                });
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
              onTap: () {},
              dense: true,
            ),
          ],
        ),
      ),
    );
  }
}
