import 'package:flutter/material.dart';
import 'package:mobile_ui/Domain/constants.dart';

class ProfileSettingsPage extends StatefulWidget {
  const ProfileSettingsPage({Key? key}) : super(key: key);

  @override
  _ProfileSettingsPageState createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends State<ProfileSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              Text(
                "Profile info",
                style: TextStyle(
                  fontSize: 20,
                  color: Constants.orangeColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              CircleAvatar(
                backgroundColor: Constants.orangeColor,
                radius: 64,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
