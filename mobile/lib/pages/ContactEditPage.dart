import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/models/ContactsModel.dart';
import 'package:mobile/models/UserModel.dart';

import '../constants.dart';

class ContactEditPage extends StatefulWidget {
  const ContactEditPage({Key? key}) : super(key: key);

  @override
  _ContactEditPageState createState() => _ContactEditPageState();
}

class _ContactEditPageState extends State<ContactEditPage> {
  ContactsModel _contactsModel = GetIt.I.get();

  TextEditingController _displayNameController =
      TextEditingController(text: "Liam Mayston");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Text(
                "Edit display name:",
                style: TextStyle(
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 60),
              alignment: Alignment.center,
              child: TextField(
                controller: _displayNameController,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 160),
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                color: Constants.orangeColor,
                onPressed: () {
                  final displayName = _displayNameController.text;
                  if (displayName.isNotEmpty) {
                    //change contact name
                  }

                  Navigator.pop(context);
                },
                child: Text("Save"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
