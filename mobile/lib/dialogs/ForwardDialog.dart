import 'package:flutter/material.dart';
import 'package:mobile/domain/Contact.dart';
import 'package:mobile/widgets/AvatarIcon.dart';

import '../constants.dart';

Future<List<Contact>?> showForwardDialog(
    BuildContext context, List<Contact> contacts, String currentContactName) {
  return showDialog<List<Contact>>(
    context: context,
    builder: (context) => ForwardDialog(
      contacts: contacts,
      currentContactName: currentContactName,
    ),
  );
}

class ForwardDialog extends StatefulWidget {
  final List<Contact> contacts;
  final String currentContactName;

  const ForwardDialog(
      {Key? key, required this.contacts, required this.currentContactName})
      : super(key: key);

  @override
  _ForwardDialogState createState() => _ForwardDialogState();
}

class _ForwardDialogState extends State<ForwardDialog> {
  final List<Contact> _selectedContacts = [];

  String query = "";
  List<Contact> contacts = [];
  List<Contact> queriedContacts = [];

  @override
  void initState() {
    super.initState();
    contacts = widget.contacts;
    contacts.removeWhere(
        (contact) => contact.displayName == widget.currentContactName);
    queriedContacts = contacts;
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
                    _searchContacts(input);
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
              itemCount: queriedContacts.length,
              itemBuilder: (BuildContext context, int index) {
                return _buildContactItem(queriedContacts[index],
                    _selectedContacts.contains(queriedContacts[index]));
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
            setState(() {
              if (_selectedContacts.contains(contact))
                _selectedContacts.remove(contact);
              else
                _selectedContacts.add(contact);
            });
          },
          child: Container(
            color: selected ? Constants.orange.withOpacity(0.4) : null,
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

  void _searchContacts(String query) {
    final filteredContacts = contacts.where((contact) {
      return contact.displayName.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      this.query = query;
      this.queriedContacts = filteredContacts;
    });
  }
}
