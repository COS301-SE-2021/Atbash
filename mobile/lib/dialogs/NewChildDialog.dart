import 'package:flutter/material.dart';
import 'package:mobile/domain/Child.dart';
import 'package:mobile/domain/Contact.dart';

Future<Child?> showNewChildDialog(
    BuildContext context, List<Contact> contacts) {
  return showDialog<Child>(
      context: context, builder: (context) => NewChildDialog(contacts));
}

class NewChildDialog extends StatefulWidget {
  final List<Contact> contacts;

  NewChildDialog(this.contacts);

  @override
  _NewChildDialogState createState() => _NewChildDialogState();
}

class _NewChildDialogState extends State<NewChildDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        children: [],
      ),
    );
  }
}
