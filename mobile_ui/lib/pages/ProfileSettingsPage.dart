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
          child: Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        splashRadius: 24,
                        color: Colors.black.withOpacity(0.7),
                        iconSize: 32,
                        onPressed: () {},
                        icon: Icon(Icons.photo_library),
                      ),
                      SizedBox(
                        width: 48,
                      ),
                      IconButton(
                        splashRadius: 24,
                        color: Colors.black.withOpacity(0.7),
                        iconSize: 32,
                        onPressed: () {},
                        icon: Icon(Icons.photo_camera),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: 40,
                    ),
                    child: Container(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Display Name",
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: 80,
                    ),
                    child: Container(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Status",
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    color: Constants.orangeColor,
                    onPressed: () {},
                    child: Text("Save"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
