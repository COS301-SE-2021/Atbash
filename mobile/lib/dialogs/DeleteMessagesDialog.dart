import 'package:flutter/material.dart';

enum DeleteMessagesResponse { CANCEL, DELETE_FOR_ME, DELETE_FOR_EVERYONE }

Future<DeleteMessagesResponse?> showConfirmDeleteDialog(
    BuildContext context, String message) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => _ConfirmDeleteDialog(message),
  );
}

class _ConfirmDeleteDialog extends StatelessWidget {
  final String message;

  _ConfirmDeleteDialog(this.message);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(message),
      actions: [
        TextButton(
          onPressed: () =>
              Navigator.of(context).pop(DeleteMessagesResponse.CANCEL),
          child: Text("CANCEL"),
        ),
        TextButton(
          onPressed: () =>
              Navigator.of(context).pop(DeleteMessagesResponse.DELETE_FOR_ME),
          child: Text("DELETE FOR ME"),
        ),
        TextButton(
          onPressed: () => Navigator.of(context)
              .pop(DeleteMessagesResponse.DELETE_FOR_EVERYONE),
          child: Text("DELETE FOR EVERYONE"),
        ),
      ],
    );
  }
}
