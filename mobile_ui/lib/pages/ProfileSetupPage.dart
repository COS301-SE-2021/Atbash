import 'package:flutter/material.dart';
import 'package:mobile_ui/Domain/constants.dart';

class ProfileSetupPage extends StatefulWidget {
  const ProfileSetupPage({Key? key}) : super(key: key);

  @override
  _ProfileSetupPageState createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends State<ProfileSetupPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
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
              Text(
                "Please provide a name as well as an optional profile picture and status.",
                textAlign: TextAlign.center,
              ),
              IconButton(
                iconSize: 128,
                splashRadius: 56,
                padding: EdgeInsets.zero,
                onPressed: () {},
                icon: Icon(
                  Icons.account_circle,
                ),
              ),
              SizedBox(
                height: 10,
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
                height: 20,
              ),
              MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                color: Constants.orangeColor,
                onPressed: () {},
                child: Text("Next"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
