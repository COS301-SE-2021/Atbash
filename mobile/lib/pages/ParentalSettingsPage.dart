import 'package:flutter/material.dart';
import 'package:mobile/constants.dart';
import 'package:mobile/pages/BlockedContactsPage.dart';

class ParentalSettingsPage extends StatefulWidget {
  const ParentalSettingsPage({Key? key}) : super(key: key);

  @override
  _ParentalSettingsPageState createState() => _ParentalSettingsPageState();
}

class _ParentalSettingsPageState extends State<ParentalSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Parental control settings"),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.all(15),
              child: Text(
                "General",
                style: TextStyle(fontSize: 20),
              ),
            ),
            ListTile(
              title: Text(
                "Add child's number",
                style: TextStyle(fontSize: 16),
              ),
              subtitle:
                  Text("Add the number of the account you wish to control."),
              leading: Icon(
                Icons.phone_android,
                color: Constants.orange,
              ),
              trailing: Icon(Icons.arrow_forward_rounded),
              dense: true,
            ),
            ListTile(
              title: Text(
                "Change pin",
                style: TextStyle(fontSize: 16),
              ),
              leading: Icon(
                Icons.password,
                color: Constants.orange,
              ),
              trailing: Icon(Icons.arrow_forward_rounded),
              dense: true,
            ),
            Container(
              padding: EdgeInsets.all(15),
              child: Text(
                "Child's Privacy Controls",
                style: TextStyle(fontSize: 20),
              ),
            ),
            SwitchListTile(
              value: false,
              onChanged: (bool newValue) {},
              title: Text(
                "Allow child to access settings",
                style: TextStyle(fontSize: 16),
              ),
              secondary: Icon(
                Icons.settings_rounded,
                color: Constants.orange,
              ),
              dense: true,
              subtitle: Text(
                  "Choose whether you or your child controls their settings"),
            ),
            Divider(
              height: 2,
              thickness: 2,
            ),
            SwitchListTile(
              key: Key("blurImages"),
              value: false,
              onChanged: (bool newValue) {},
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
              value: false,
              onChanged: (bool newValue) {
                //TODO Create Pin logic
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
              value: false,
              onChanged: (bool newValue) {},
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
              value: false,
              onChanged: (bool newValue) {},
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
              value: false,
              onChanged: (bool newValue) {},
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
              value: false,
              onChanged: (bool newValue) {},
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
                "Management",
                style: TextStyle(fontSize: 20),
              ),
            ),
            ListTile(
              title: Text("Lock Account", style: TextStyle(fontSize: 16)),
              subtitle: Text(
                  "Lock the child's account so the application cannot be used without entering the pin"),
              leading: Icon(
                Icons.lock,
                color: Colors.orange,
              ),
              trailing: Icon(Icons.arrow_forward_rounded),
              dense: true,
            ),
            ListTile(
              title: Text("Chat Log", style: TextStyle(fontSize: 16)),
              subtitle: Text("Access your child's chat log"),
              leading: Icon(
                Icons.mark_chat_read_sharp,
                color: Colors.orange,
              ),
              trailing: Icon(Icons.arrow_forward_rounded),
              dense: true,
            ),
            SwitchListTile(
              value: false,
              onChanged: (bool newValue) {},
              title: Text(
                "Block Private Chats",
                style: TextStyle(fontSize: 16),
              ),
              secondary: Icon(
                Icons.screen_lock_landscape,
                color: Constants.orange,
              ),
              dense: true,
              subtitle:
                  Text("Choose whether your child can access private chats"),
            ),
            SwitchListTile(
              value: false,
              onChanged: (bool newValue) {},
              title: Text(
                "Block saving of media",
                style: TextStyle(fontSize: 16),
              ),
              secondary: Icon(
                Icons.hide_image,
                color: Constants.orange,
              ),
              dense: true,
              subtitle: Text(
                  "Choose whether your child can save media to their phone"),
            ),
            SwitchListTile(
              value: false,
              onChanged: (bool newValue) {},
              title: Text(
                "Block editing of messages",
                style: TextStyle(fontSize: 16),
              ),
              secondary: Icon(
                Icons.edit_off,
                color: Constants.orange,
              ),
              dense: true,
              subtitle:
                  Text("Choose whether your child can edit their messages"),
            ),
            SwitchListTile(
              value: false,
              onChanged: (bool newValue) {},
              title: Text(
                "Block deletion of messages",
                style: TextStyle(fontSize: 16),
              ),
              secondary: Icon(
                Icons.delete_forever_outlined,
                color: Constants.orange,
              ),
              dense: true,
              subtitle:
                  Text("Choose whether your child can delete their messages"),
            ),
          ],
        ),
      ),
    );
  }
}
