import 'package:flutter/material.dart';
import 'package:mobile_ui/Domain/constants.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
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
            SwitchListTile(
              value: _darkModeIsSelected,
              onChanged: (bool newValue) {
                setState(() {
                  _darkModeIsSelected = !_darkModeIsSelected;
                });
              },
              title: Text(
                "Dark mode",
                style: TextStyle(fontSize: 16),
              ),
              secondary: Icon(Icons.dark_mode_rounded),
              dense: true,
            ),
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
                "Blur Incoming Images",
                style: TextStyle(fontSize: 16),
              ),
              secondary: Icon(Icons.remove_red_eye_outlined),
              dense: true,
            ),
            SwitchListTile(
              value: _blurredImagesIsSelected,
              onChanged: (bool newValue) {
                setState(() {
                  _blurredImagesIsSelected = !_blurredImagesIsSelected;
                });
              },
              title: Text(
                "Blur Incoming Images",
                style: TextStyle(fontSize: 16),
              ),
              secondary: Icon(Icons.remove_red_eye_outlined),
              dense: true,
            ),
          ],
        ),
      ),
    );
  }
}
