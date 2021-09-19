import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:mobile/util/Utils.dart';

Future<String?> showNewNumberDialog(BuildContext context) {
  return showDialog<String>(
      context: context, builder: (BuildContext context) => NewNumberDialog());
}

class NewNumberDialog extends StatefulWidget {
  const NewNumberDialog({Key? key}) : super(key: key);

  @override
  _NewNumberDialogState createState() => _NewNumberDialogState();
}

class _NewNumberDialogState extends State<NewNumberDialog> {
  final _phoneNumberController = TextEditingController();

  String selectedDialCode = "+27";

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Please insert the number you wish to block."),
      content: Row(
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
              key: Key('NewNumberDialogField'),
              controller: _phoneNumberController,
              decoration: InputDecoration(hintText: "Phone number"),
              keyboardType: TextInputType.phone,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          key: Key('NewNumberDialogCancel'),
          onPressed: () {
            Navigator.of(context).pop(null);
          },
          child: Text("CANCEL"),
        ),
        TextButton(
          key: Key('NewNumberDialogAdd'),
          onPressed: () {
            final phoneNumber =
                selectedDialCode + cullToE164(_phoneNumberController.text);

            if (phoneNumber.isNotEmpty) {
              Navigator.of(context).pop(phoneNumber);
            } else {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text("Number is required")));
            }
          },
          child: Text("ADD"),
        ),
      ],
    );
  }
}
