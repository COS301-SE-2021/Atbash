import 'package:flutter/material.dart';
import 'package:mobile/util/Utils.dart';

Future<String?> showPinDialog(
    BuildContext context, String message, String? previousPin) {
  return showDialog<String>(
      context: context, builder: (context) => PinDialog(message, previousPin));
}

class PinDialog extends StatefulWidget {
  final String message;
  final String? previousPin;

  PinDialog(this.message, this.previousPin);

  @override
  _PinDialogState createState() => _PinDialogState();
}

class _PinDialogState extends State<PinDialog> {
  final _pinController = TextEditingController();

  @override
  void initState() {
    _pinController.text = widget.previousPin ?? "0000";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Enter the pin you wish to use for this child:",
        textAlign: TextAlign.center,
      ),
      content: TextField(
        controller: _pinController,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 4,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(null);
          },
          child: Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            if (RegExp(r'^[0-9]{4}$').firstMatch(_pinController.text) != null)
              Navigator.of(context).pop(_pinController.text);
            else
              showSnackBar(
                  context, "Please ensure your pin is a 4 digit code.");
          },
          child: Text("Save"),
        ),
      ],
    );
  }
}
