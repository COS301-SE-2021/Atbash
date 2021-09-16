import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:mobile/util/Utils.dart';

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

class _NewContactDialog extends StatefulWidget {
  @override
  __NewContactDialogState createState() => __NewContactDialogState();
}

class __NewContactDialogState extends State<_NewContactDialog> {
  final _nameController = TextEditingController();
  final _phoneNumberController = TextEditingController();

  String selectedDialCode = "+27";

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
            Row(
              children: [
                CountryCodePicker(
                  showDropDownButton: true,
                  padding: EdgeInsets.zero,
                  initialSelection: selectedDialCode,
                  showFlag: false,
                  onChanged: (countryCode) {
                    final dialCode = countryCode.dialCode;
                    if (dialCode != null) {
                      selectedDialCode = dialCode;
                    }
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: _phoneNumberController,
                    decoration: InputDecoration(hintText: "Phone number"),
                    keyboardType: TextInputType.phone,
                  ),
                ),
              ],
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
            final phoneNumber =
                selectedDialCode + cullToE164(_phoneNumberController.text);

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
