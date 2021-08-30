import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/domain/Contact.dart';
import 'package:mobile/models/ContactListModel.dart';

Future<bool?> ShowForwardDialog(BuildContext context, String messageContents) {
  return showDialog(
      context: context, builder: (context) => _ForwardDialog(messageContents));
}

class _ForwardDialog extends StatelessWidget {
  final String message;
  final ContactListModel _contactListModel = GetIt.I.get();

  _ForwardDialog(this.message);

  @override
  Widget build(BuildContext context) {
    List<Contact> contacts = _contactListModel.contacts;

    return AlertDialog(
      title: Text(
        "Search placeholder",
        textAlign: TextAlign.center,
      ),
      content: ListView.builder(
          itemCount: contacts.length,
          itemBuilder: (BuildContext context, int index) {}),
      scrollable: true,
    );
    ;
  }
}
