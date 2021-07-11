import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/dialogs/NewContactDialog.dart';
import 'package:mobile/domain/Contact.dart';
import 'package:mobile/pages/ChatPage.dart';
import 'package:mobile/services/ContactsService.dart';
import 'package:mobile/services/responses/ContactsServiceResponses.dart';
import 'package:mobile/widgets/ProfileIcon.dart';

class NewChatPage extends StatefulWidget {
  @override
  _NewChatPageState createState() => _NewChatPageState();
}

class _NewChatPageState extends State<NewChatPage> {
  final ContactsService _contactsService = GetIt.I.get();

  List<Contact> _contacts = [];

  @override
  void initState() {
    super.initState();

    _contactsService.onContactsChanged(_populateContacts);
    _populateContacts();
  }

  @override
  void dispose() {
    super.dispose();

    _contactsService.disposeContactsChangedListener(_populateContacts);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(context),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Row(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Select a Contact",
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.search),
        ),
      ],
    );
  }

  ListView _buildBody(BuildContext context) {
    return ListView(
      children: [
        _buildNewContactItem(context),
        ..._buildContactList(context),
      ],
    );
  }

  InkWell _buildNewContactItem(BuildContext context) {
    return InkWell(
      onTap: () => _addContact(context),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.all(4.0),
              child: Icon(Icons.person_add),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  "New contact",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addContact(BuildContext context) {
    showNewContactDialog(context).then(
      (nameNumberPair) {
        if (nameNumberPair != null) {
          _contactsService
              .addContact(
            nameNumberPair.phoneNumber,
            nameNumberPair.name,
            false,
          )
              .then((response) {
            if (response.status == AddContactResponseStatus.DUPLICATE_NUMBER) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "This number already exists in your contacts",
                  ),
                ),
              );
            } else if (response.status ==
                AddContactResponseStatus.GENERAL_ERROR) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("An error occurred"),
                ),
              );
            }
          });
        }
      },
    );
  }

  List<InkWell> _buildContactList(BuildContext context) {
    return _contacts.map((e) => _buildContact(context, e)).toList();
  }

  InkWell _buildContact(BuildContext context, Contact contact) {
    return InkWell(
      onTap: () => _startChat(context, contact),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          children: [
            EmptyProfileIcon(Colors.black),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  contact.displayName,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _populateContacts() {
    _contactsService.getAllContacts().then((allContacts) {
      setState(() {
        _contacts = allContacts;
      });
    });
  }

  void _startChat(BuildContext context, Contact contact) {
    _contactsService.startChatWithContact(contact.phoneNumber);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(contact),
      ),
    );
  }
}
