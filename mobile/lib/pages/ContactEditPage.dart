import 'package:flutter/material.dart';
import 'package:mobile/controllers/ContactEditPageController.dart';
import 'package:mobile/util/Utils.dart';
import 'package:mobx/mobx.dart';

class ContactEditPage extends StatefulWidget {
  final String phoneNumber;

  const ContactEditPage({
    Key? key,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  _ContactEditPageState createState() =>
      _ContactEditPageState(phoneNumber: phoneNumber);
}

class _ContactEditPageState extends State<ContactEditPage> {
  final ContactEditPageController controller;
  final _displayNameController = TextEditingController();
  late final ReactionDisposer _contactDisposer;

  _ContactEditPageState({required String phoneNumber})
      : controller = ContactEditPageController(phoneNumber: phoneNumber);

  @override
  void initState() {
    super.initState();

    _contactDisposer = autorun((_) {
      _displayNameController.text = controller.model.contactName;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _contactDisposer();
  }

  @override
  Widget build(BuildContext context) {
    _displayNameController.text = controller.model.contactName;

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Text(
                "Edit display name:",
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 60),
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
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Text(
                "Edit number:",
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 60),
              alignment: Alignment.center,
              child: TextField(
                controller: _phoneNumberController,
                textAlign: TextAlign.center,
              ),
            ),

            //If we want to allow editing of birthdays again uncomment this code.

            // Container(
            //   padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            //   child: Text(
            //     "Edit birthday:",
            //     style: TextStyle(fontSize: 20),
            //     textAlign: TextAlign.center,
            //   ),
            // ),
            // TextButton(
            //   onPressed: () {
            //     DatePicker.showDatePicker(
            //       context,
            //       showTitleActions: true,
            //       minTime: DateTime(1900, 1, 1),
            //       maxTime: DateTime.now(),
            //       onConfirm: (date) {
            //         //TODO: Update birthday in database.
            //         setState(() {
            //           _birthdayController.text =
            //               DateFormat.yMMMd().format(date);
            //         });
            //       },
            //       currentTime: DateTime.now(),
            //     );
            //   },
            //   child: Text(_birthdayController.text),
            // ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 160),
              child: ElevatedButton(
                key: Key("save"),
                onPressed: _save,
                child: Text("SAVE"),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _save() {
    final String displayName = _displayNameController.text.trim();

    if (displayName.isEmpty) {
      showSnackBar(context, "Display name cannot be blank");
    } else {
      controller.updateContact(displayName, null);
      Navigator.pop(context);
      //TODO Update birthday
    }
  }
}
