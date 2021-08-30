import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/domain/Contact.dart';
import 'package:mobile/models/ContactListModel.dart';
import 'package:mobile/widgets/AvatarIcon.dart';

import '../constants.dart';

Future<bool?> showForwardDialog(BuildContext context, String messageContents) {
  return showDialog<bool>(
    context: context,
    builder: (context) => _ForwardDialog(messageContents),
  );
}

class _ForwardDialog extends StatelessWidget {
  final String message;
  final ContactListModel _contactListModel = GetIt.I.get();

  _ForwardDialog(this.message);

  @override
  Widget build(BuildContext context) {
    List<Contact> contacts = _contactListModel.contacts;

    return AlertDialog(
        contentPadding: EdgeInsets.all(Constants.screenBorderPadding),
        title: Text(
          "Search placeholder",
          textAlign: TextAlign.center,
        ),
        content: Container(
          height: 400,
          width: 200,
          child: ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0 ||
                    contacts[index - 1].displayName.substring(0, 1).compareTo(
                            contacts[index].displayName.substring(0, 1)) <
                        0)
                  return Column(
                    children: [
                      Container(
                        width: double.infinity,
                        color: Constants.darkGrey.withOpacity(0.2),
                        child:
                            Text(contacts[index].displayName.substring(0, 1)),
                      ),
                      _buildContactItem(contacts[index]),
                    ],
                  );
                return _buildContactItem(contacts[index]);
              }),
        ));
  }
}
