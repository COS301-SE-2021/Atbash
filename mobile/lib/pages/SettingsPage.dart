import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/models/UserModel.dart';
import 'package:mobile/widgets/AvatarIcon.dart';

import '../constants.dart';
import 'ProfileSettingsPage.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final UserModel _userModel = GetIt.I.get();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            AppBar(
              title: Text(
                "Settings",
              ),
            ),
            SizedBox(
              height: 2,
            ),
            Container(
              padding: EdgeInsets.all(5),
              color: Constants.orangeColor.withOpacity(0.8),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfileSettingsPage()));
                },
                child: Row(
                  children: [
                    Observer(builder: (context) {
                      return AvatarIcon(
                        _userModel.profileImage,
                        radius: 24,
                      );
                    }),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Observer(builder: (context) {
                            return Text(
                              _userModel.displayName,
                              style: TextStyle(
                                fontSize: 22,
                              ),
                            );
                          }),
                          SizedBox(
                            height: 2,
                          ),
                          Observer(builder: (context) {
                            return Text(
                              _userModel.status,
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SettingsElement(
              icon: Icons.vpn_key,
              heading: "Account",
              description: "Number, Deletion, Setup.",
            ),
            Divider(height: 2),
            SettingsElement(
                icon: Icons.privacy_tip,
                heading: "Privacy",
                description: "Security, Safe Search."),
            Divider(height: 2),
            SettingsElement(
                icon: Icons.notification_important,
                heading: "Notifications",
                description: "Messages, Tones."),
            Divider(height: 2),
            SettingsElement(
                icon: Icons.storage,
                heading: "Storage",
                description: "Auto-Download."),
            Divider(height: 2),
            SettingsElement(
                icon: Icons.help,
                heading: "Help",
                description: "Help, Safety."),
          ],
        ),
      ),
    );
  }
}

class SettingsElement extends StatelessWidget {
  const SettingsElement(
      {Key? key,
      required this.icon,
      required this.heading,
      required this.description})
      : super(key: key);

  final IconData icon;
  final String heading;
  final String description;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        color: Constants.orangeColor.withOpacity(0.8),
        padding: EdgeInsets.all(5),
        child: Row(
          children: [
            Icon(icon),
            SizedBox(
              width: 12,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    heading,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Container(
                    child: Text(
                      description,
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward,
            ),
          ],
        ),
      ),
    );
  }
}
