import 'package:flutter/material.dart';

Future<String?> showInputDialog(BuildContext context, String message) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => _InputDialog(message),
  );
}

class _InputDialog extends StatelessWidget {
  final String message;
  final inputController = TextEditingController();

  _InputDialog(this.message);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(message),
      content: TextField(
        controller: inputController,
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
