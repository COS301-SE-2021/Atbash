import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/domain/Contact.dart';
import 'package:mobile/widgets/AvatarIcon.dart';

import '../constants.dart';

Future<List<Contact>?> showForwardDialog(
    BuildContext context, List<Contact> contacts) {
  return showDialog<List<Contact>>(
    context: context,
    builder: (context) => ForwardDialog(
      contacts: contacts,
    ),
  );
}

class ForwardDialog extends StatefulWidget {
  final List<Contact> contacts;

  const ForwardDialog({Key? key, required this.contacts}) : super(key: key);

  @override
  _ForwardDialogState createState() => _ForwardDialogState();
}

class _ForwardDialogState extends State<ForwardDialog> {
  final List<Contact> _selectedContacts = [];

  String query = "";
  List<Contact> contacts = [];

  @override
  void initState() {
    super.initState();
    contacts = widget.contacts;
  }

  @override
  Widget build(BuildContext context) {
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
                  onChanged: (String input) {
                    _searchContacts(input, contacts);
                  },
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
          margin: EdgeInsets.only(top: 15),
          height: 320,
          width: 200,
          child: ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (BuildContext context, int index) {
                return _buildContactItem(contacts[index],
                    _selectedContacts.contains(contacts[index]));
              }),
        ));
  }

  Widget _buildContactItem(Contact contact, bool selected) {
    Widget widget;

    if (contact.status != "")
      widget = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(contact.displayName),
          Text(contact.status),
        ],
      );
    else
      widget = Text(contact.displayName);

    return Column(
      children: [
        InkWell(
          onTap: () {
            _selectedContacts.add(contact);
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
            child: Row(
              children: [
                AvatarIcon.fromString(contact.profileImage),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: widget,
                ),
              ],
            ),
          ),
        ),
        Divider(
          height: 1,
          color: Constants.darkGrey,
        ),
      ],
    );
  }

  void _searchContacts(String query, List<Contact> contacts) {
    final filteredContacts = widget.contacts.where((contact) {
      return contact.displayName.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      this.query = query;
      this.contacts = filteredContacts;
      //TODO: Update contacts state variable.
    });
  }
}
