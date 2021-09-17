import 'package:flutter/material.dart';

Future<void> showInfoDialog(
  BuildContext context,
  String message, {
  String buttonDialog = "ok",
}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => _InfoDialog(message, buttonDialog),
  );
}

class _InfoDialog extends StatelessWidget {
  final String message;
  final String buttonDialog;

  _InfoDialog(this.message, this.buttonDialog);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(buttonDialog.toUpperCase()),
        ),
      ],
    );
  }
}
