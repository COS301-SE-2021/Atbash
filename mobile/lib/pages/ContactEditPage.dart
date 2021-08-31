import 'package:flutter/material.dart';
import 'package:mobile/controllers/ContactEditPageController.dart';
import 'package:mobile/domain/Contact.dart';
import 'package:mobile/util/Utils.dart';

class ContactEditPage extends StatefulWidget {
  final Contact contact;

  const ContactEditPage({
    Key? key,
    required this.contact,
  }) : super(key: key);

  @override
  _ContactEditPageState createState() => _ContactEditPageState(contact: contact);
}

class _ContactEditPageState extends State<ContactEditPage> {
  final ContactEditPageController controller;
  final _displayNameController = TextEditingController();

  _ContactEditPageState({required Contact contact})
      : controller =
            ContactEditPageController(contact: contact);

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
            //TODO Add birthday as an option to update
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
