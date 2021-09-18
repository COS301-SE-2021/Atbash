import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
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
  final _phoneNumberController = TextEditingController();
  final _birthdayController = TextEditingController();
  DateTime? chosenBirthday;

  late final ReactionDisposer _contactDisposer;

  _ContactEditPageState({required String phoneNumber})
      : controller = ContactEditPageController(phoneNumber: phoneNumber);

  @override
  void initState() {
    super.initState();

    _contactDisposer = autorun((_) {
      final contactBirthday = controller.model.contactBirthday;
      setState(() {
        chosenBirthday = controller.model.contactBirthday;
      });
      _phoneNumberController.text = controller.model.contactPhoneNumber;
      _displayNameController.text = controller.model.contactName;
      _birthdayController.text = contactBirthday == null
          ? "Select birthday"
          : DateFormat.yMMMd().format(contactBirthday);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _contactDisposer();
  }

  @override
  Widget build(BuildContext context) {
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
            SizedBox(
              height: 50,
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Text(
                "Edit birthday:",
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
            TextButton(
              onPressed: () {
                DatePicker.showDatePicker(
                  context,
                  showTitleActions: true,
                  minTime: DateTime(1900, 1, 1),
                  maxTime: DateTime.now(),
                  onConfirm: (date) {
                    setState(() {
                      chosenBirthday = date;
                      _birthdayController.text =
                          DateFormat.yMMMd().format(date);
                    });
                  },
                  currentTime: DateTime.now(),
                );
              },
              child: Text(_chosenBirthdayToString()),
            ),
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

  String _chosenBirthdayToString() {
    final birthday = chosenBirthday;

    if (birthday != null) {
      return DateFormat.yMMMd().format(birthday);
    } else {
      return "Select Birthday";
    }
  }

  void _save() {
    final String displayName = _displayNameController.text.trim();

    if (displayName.isEmpty) {
      showSnackBar(context, "Display name cannot be blank");
    } else {
      if (chosenBirthday != null) {
        controller.updateContact(displayName, chosenBirthday);
      } else {
        controller.updateContact(displayName, null);
      }
      Navigator.pop(context);
    }
  }
}
