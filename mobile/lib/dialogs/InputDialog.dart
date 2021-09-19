import 'package:flutter/material.dart';

Future<String?> showInputDialog(BuildContext context, String message,
    {String hint = ""}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => _InputDialog(message, hint),
  );
}

class _InputDialog extends StatelessWidget {
  final String message;
  final String hint;
  final inputController = TextEditingController();

  _InputDialog(this.message, this.hint);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(message),
      content: TextField(
        controller: inputController,
        decoration: InputDecoration(
          hintText: hint,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(null);
          },
          child: Text("CANCEL"),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(inputController.text.trim());
          },
          child: Text("OK"),
        ),
      ],
    );
  }
}
