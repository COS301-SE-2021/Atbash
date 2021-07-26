import 'package:flutter/material.dart';

Future<bool?> showConfirmDialog(BuildContext context, String message) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) => _ConfirmDialog(message),
  );
}

class _ConfirmDialog extends StatelessWidget {
  final String message;

  _ConfirmDialog(this.message);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(message),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: Text("CANCEL"),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: Text("OK"),
        ),
      ],
    );
  }
}
