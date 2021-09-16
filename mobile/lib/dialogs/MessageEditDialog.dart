import 'package:flutter/material.dart';

Future<String?> showEditMessageDialog(
    BuildContext context, String originalMessage) {
  return showDialog(
      context: context, builder: (_) => EditMessageDialog(originalMessage));
}

class EditMessageDialog extends StatefulWidget {
  final String originalMessage;

  EditMessageDialog(this.originalMessage);

  @override
  _EditMessageDialogState createState() => _EditMessageDialogState();
}

class _EditMessageDialogState extends State<EditMessageDialog> {
  final inputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    inputController.text = widget.originalMessage;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(

      content: TextField(
        controller: inputController,
        maxLines: 3,
        minLines: 1,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(null),
          child: Text("CANCEL"),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(inputController.text),
          child: Text("EDIT"),
        ),
      ],
    );
  }
}
