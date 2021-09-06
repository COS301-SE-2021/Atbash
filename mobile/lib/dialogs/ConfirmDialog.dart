import 'package:flutter/material.dart';

Future<bool?> showConfirmDialog(
  BuildContext context,
  String message, {
  String positive = "ok",
  String negative = "cancel",
}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) => _ConfirmDialog(message, positive, negative),
  );
}

class _ConfirmDialog extends StatelessWidget {
  final String message;
  final String positive;
  final String negative;

  _ConfirmDialog(this.message, this.positive, this.negative);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(message),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: Text(negative.toUpperCase()),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: Text(positive.toUpperCase()),
        ),
      ],
    );
  }
}
