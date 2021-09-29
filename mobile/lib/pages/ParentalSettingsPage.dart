import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobile/constants.dart';
import 'package:mobile/controllers/ParentalSettingsPageController.dart';
import 'package:mobile/dialogs/ConfirmDialog.dart';
import 'package:mobile/dialogs/InputDialog.dart';
import 'package:mobile/pages/ChatLogPage.dart';
import 'package:mobile/pages/NewChildPage.dart';
import 'package:mobile/pages/ProfanityFilterListPage.dart';

import 'ChildBlockedContactsPage.dart';

class ParentalSettingsPage extends StatefulWidget {
  @override
  _ParentalSettingsPageState createState() => _ParentalSettingsPageState();
}

class _ParentalSettingsPageState extends State<ParentalSettingsPage> {
  final ParentalSettingsPageController controller;

  _ParentalSettingsPageState() : controller = ParentalSettingsPageController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        controller.model.children.forEach((child) {
          if (child.second) controller.sendUpdatedSettingsToChild(child.first);
        });
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Parental control settings"),
        ),
        body: Observer(builder: (context) {
          return SafeArea(
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
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewChildPage(),
                      ),
                    ).then((value) => controller.reload(0));
                  },
                  title: Text(
                    "Add child's number",
                    style: TextStyle(fontSize: 16),
                  ),
                  subtitle: Text("Add a child to this account."),
                  leading: Icon(
                    Icons.phone_android,
                    color: Constants.orange,
                  ),
                  trailing: Icon(Icons.arrow_forward_rounded),
                  dense: true,
                ),
                ListTile(
                  onTap: () {
                    showInputDialog(context,
                            "Please enter the code shown on the parent's phone")
                        .then((value) {
                      // if(value != null)
                      //   //TODO: Send all data to parent if correct code and enable parent in database.
                    });
                  },
                  title: Text(
                    "Add parent account",
                    style: TextStyle(fontSize: 16),
                  ),
                  subtitle: Text("Add a parent to control this account"),
                  leading: Icon(
                    Icons.phonelink,
                    color: Constants.orange,
                  ),
                  trailing: Icon(Icons.arrow_forward_rounded),
                  dense: true,
                ),
                if (controller.model.children.isNotEmpty)
                  Container(
                    height: 50,
                    padding: EdgeInsets.all(10),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.model.children.length,
                      itemBuilder: (_, index) {
                        return Container(
                          child: _buildChildBubble(
                              controller.model.children[index].first.name,
                              index),
                        );
                      },
                    ),
                  ),
                if (controller.model.children.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(15),
                        child: Text(
                          "Child's Privacy Controls",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      SwitchListTile(
                        value: controller.model.editableSettings,
                        onChanged: (bool newValue) {
                          controller.setChildChanged(true);
                          controller.setEditableSettings(newValue);
                        },
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
                        value: controller.model.blurImages,
                        onChanged: controller.model.editableSettings
                            ? null
                            : (bool newValue) {
                                controller.setChildChanged(true);
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
                        onChanged: controller.model.editableSettings
                            ? null
                            : (bool newValue) {
                                controller.setChildChanged(true);
                                controller.setSafeMode(newValue);
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
                        subtitle:
                            Text("Enables text profanity filter for all chats"),
                      ),
                      SwitchListTile(
                        value: controller.model.shareProfilePicture,
                        onChanged: controller.model.editableSettings
                            ? null
                            : (bool newValue) {
                                controller.setChildChanged(true);
                                controller.setShareProfilePicture(newValue);
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
                        onChanged: controller.model.editableSettings
                            ? null
                            : (bool newValue) {
                                controller.setChildChanged(true);
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
                        onChanged: controller.model.editableSettings
                            ? null
                            : (bool newValue) {
                                controller.setChildChanged(true);
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
                        onChanged: controller.model.editableSettings
                            ? null
                            : (bool newValue) {
                                controller.setChildChanged(true);
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
                        subtitle: Text(
                            "Add or remove words from the profanity filter"),
                        trailing: Icon(Icons.arrow_forward_rounded),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ProfanityFilterListPage()));
                        },
                        dense: true,
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
                                  builder: (context) =>
                                      ChildBlockedContactsPage(
                                          child: controller
                                              .model
                                              .children[controller
                                                  .model.currentlySelected]
                                              .first)));
                        },
                        dense: true,
                      ),
                    ],
                  ),
                if (controller.model.children.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(15),
                        child: Text(
                          "Management",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      ListTile(
                        onTap: () {
                          showConfirmDialog(
                                  context,
                                  "Are you sure you want to lock 'child name's account? You will have to enter their "
                                  "unique pin to unlock the application.")
                              .then((value) {
                            if (value != null) {
                              controller.setChildChanged(true);
                              controller.setLockedAccount(value);
                            }
                          });
                        },
                        title: Text(
                            "${controller.model.lockedAccount ? 'Unlock' : 'Lock'} Account",
                            style: TextStyle(fontSize: 16)),
                        subtitle: Text(
                            "Lock or unlock the child's account so the application cannot be used without entering the pin"),
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
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatLogPage(
                                child: controller
                                    .model
                                    .children[
                                        controller.model.currentlySelected]
                                    .first,
                              ),
                            ),
                          );
                        },
                        dense: true,
                      ),
                      SwitchListTile(
                        value: controller.model.privateChatAccess,
                        onChanged: (bool newValue) {
                          controller.setChildChanged(true);
                          controller.setPrivateChatAccess(newValue);
                        },
                        title: Text(
                          "Block Private Chats",
                          style: TextStyle(fontSize: 16),
                        ),
                        secondary: Icon(
                          Icons.screen_lock_landscape,
                          color: Constants.orange,
                        ),
                        dense: true,
                        subtitle: Text(
                            "Choose whether your child can access private chats"),
                      ),
                      SwitchListTile(
                        value: controller.model.blockSaveMedia,
                        onChanged: (bool newValue) {
                          controller.setChildChanged(true);
                          controller.setBlockSaveMedia(newValue);
                        },
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
                        value: controller.model.blockEditingMessages,
                        onChanged: (bool newValue) {
                          controller.setChildChanged(true);
                          controller.setBlockEditingMessages(newValue);
                        },
                        title: Text(
                          "Block editing of messages",
                          style: TextStyle(fontSize: 16),
                        ),
                        secondary: Icon(
                          Icons.edit_off,
                          color: Constants.orange,
                        ),
                        dense: true,
                        subtitle: Text(
                            "Choose whether your child can edit their messages"),
                      ),
                      SwitchListTile(
                        value: controller.model.blockDeletingMessages,
                        onChanged: (bool newValue) {
                          controller.setChildChanged(true);
                          controller.setBlockDeletingMessages(newValue);
                        },
                        title: Text(
                          "Block deletion of messages",
                          style: TextStyle(fontSize: 16),
                        ),
                        secondary: Icon(
                          Icons.delete_forever_outlined,
                          color: Constants.orange,
                        ),
                        dense: true,
                        subtitle: Text(
                            "Choose whether your child can delete their messages"),
                      ),
                    ],
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildChildBubble(String displayName, int index) {
    return InkWell(
      onTap: () => controller.reload(index),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        padding: EdgeInsets.all(5),
        child: Text(
          displayName,
          style: TextStyle(color: Colors.black),
        ),
        decoration: BoxDecoration(
          color: index == controller.model.currentlySelected
              ? Constants.orange.withOpacity(0.88)
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
