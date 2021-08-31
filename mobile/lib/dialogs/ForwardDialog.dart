import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/domain/Contact.dart';
import 'package:mobile/models/ContactListModel.dart';
import 'package:mobile/widgets/AvatarIcon.dart';

import '../constants.dart';

Future<List<Contact>?> showForwardDialog(BuildContext context) {
  return showDialog<List<Contact>>(
    context: context,
    builder: (context) => _ForwardDialog(),
  );
}

class _ForwardDialog extends StatelessWidget {
  final ContactListModel _contactListModel = GetIt.I.get();
  final List<Contact> _selectedContacts = [];

  @override
  Widget build(BuildContext context) {
    List<Contact> contacts = _contactListModel.contacts;

    return AlertDialog(
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(null);
            },
            child: Text("CANCEL"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(_selectedContacts);
            },
            child: Text("SEND"),
          ),
        ],
        contentPadding: EdgeInsets.zero,
        title: Container(
          padding: EdgeInsets.zero,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Constants.darkGrey.withOpacity(0.5),
          ),
          child: Row(
            children: [
              Icon(
                Icons.search,
                size: 20,
              ),
              Expanded(
                child: TextField(
                  expands: false,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintText: "Search",
                    contentPadding: EdgeInsets.all(2),
                    isDense: true,
                  ),
                ),
              ),
            ],
          ),
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

  Widget _buildContactItem(Contact contact) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
        child: Row(
          children: [
            AvatarIcon.fromString(contact.profileImage),
            Expanded(child: Text(contact.displayName)),
          ],
        ),
      ),
    );
  }
}
