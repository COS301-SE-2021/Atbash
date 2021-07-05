import 'package:flutter/material.dart';

class PhoneNumberNamePair {
  final String phoneNumber;
  final String name;

  PhoneNumberNamePair(this.phoneNumber, this.name);
}

Future<PhoneNumberNamePair?> showNewContactDialog(BuildContext context) {
  return showDialog<PhoneNumberNamePair>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => _NewContactDialog());
}

class _NewContactDialog extends StatelessWidget {
  final _nameController = TextEditingController();
  final _phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Create new contact"),
      content: Wrap(children: [
        Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(hintText: "Name"),
            ),
            TextField(
              controller: _phoneNumberController,
              decoration: InputDecoration(hintText: "Phone number"),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
      ]),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(null);
          },
          child: Text("CANCEL"),
        ),
        TextButton(
          onPressed: () {
            final name = _nameController.text.trim();
            final phoneNumber = _phoneNumberController.text.trim();

            if (name.isNotEmpty && phoneNumber.isNotEmpty) {
              final pair = PhoneNumberNamePair(phoneNumber, name);
              Navigator.of(context).pop(pair);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Both name and number are required")));
            }
          },
          child: Text("ADD"),
        ),
      ],
    );
  }
}
