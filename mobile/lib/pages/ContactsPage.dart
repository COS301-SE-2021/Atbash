import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mobile/controllers/ContactsPageController.dart';
import 'package:mobile/dialogs/NewContactDialog.dart';
import 'package:mobile/domain/Chat.dart';
import 'package:mobile/domain/Contact.dart';
import 'package:mobile/pages/ChatPage.dart';
import 'package:mobile/pages/ContactInfoPage.dart';
import 'package:mobile/util/Utils.dart';
import 'package:mobile/widgets/AvatarIcon.dart';

import '../constants.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({Key? key}) : super(key: key);

  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  final ContactsPageController controller;
  bool _searching = false;
  String _filterQuery = "";
  TextEditingController _searchController = TextEditingController();
  late final FocusNode _searchFocusNode;

  _ContactsPageState() : controller = ContactsPageController();

  @override
  void initState() {
    super.initState();

    _searchFocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();

    controller.dispose();
    _searchFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_searching) {
          _stopSearching();
          return false;
        }

        return true;
      },
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: _buildBody(),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    Widget title = Text(
      "Select a Contact",
      overflow: TextOverflow.ellipsis,
    );

    if (_searching) {
      title = TextField(
        controller: _searchController,
        focusNode: _searchFocusNode,
        onChanged: _filter,
        decoration: InputDecoration(border: InputBorder.none),
      );
    }

    return AppBar(
      title: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: title,
            ),
          ),
        ],
      ),
      actions: [
        if (!_searching)
          IconButton(
            onPressed: _startSearching,
            icon: Icon(Icons.search),
          )
      ],
    );
  }

  void _startSearching() {
    setState(() {
      _searching = true;
      _filterQuery = "";
    });
    _searchController.text = "";
    _searchFocusNode.requestFocus();
  }

  void _stopSearching() {
    setState(() {
      _searching = false;
      _filterQuery = "";
    });
    _searchController.text = "";
  }

  void _filter(String value) {
    setState(() {
      _filterQuery = value;
    });
  }

  Widget _buildBody() {
    return Observer(builder: (context) {
      return ListView(
        children: [
          _buildNewContactItem(context),
          ..._buildContactList(context, _searching)
        ],
      );
    });
  }

  InkWell _buildNewContactItem(BuildContext context) {
    return InkWell(
      onTap: () => _addContact(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Icon(Icons.person_add),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
    showNewContactDialog(context).then((nameNumberPair) async {
      if (nameNumberPair != null) {
        controller
            .addContact(
                context, nameNumberPair.phoneNumber, nameNumberPair.name)
            .catchError((_) {
          showSnackBar(
            context,
            "A contact already exists with the number ${nameNumberPair.phoneNumber}",
          );
        });
      }
    });
  }

  List<Widget> _buildContactList(BuildContext context, bool filtered) {
    List<Contact> contacts = controller.model.contacts;

    if (filtered) {
      final filterQuery = _filterQuery.toLowerCase();
      contacts = contacts
          .where((c) =>
              c.phoneNumber.contains(filterQuery) ||
              c.displayName.toLowerCase().contains(filterQuery))
          .toList();
    }

    List<Widget> contactList = [];

    if (contacts.isNotEmpty) contactList.add(_buildContact(contacts[0], true));

    for (int i = 1; i < contacts.length; i++) {
      String prevContactFirstLetter =
          contacts[i - 1].displayName.substring(0, 1);
      String currentContactFirstLetter =
          contacts[i].displayName.substring(0, 1);

      if (prevContactFirstLetter.compareTo(currentContactFirstLetter) < 0)
        contactList.add(_buildContact(contacts[i], true));
      else
        contactList.add(_buildContact(contacts[i], false));
    }

    return contactList;
  }

  Widget _buildContact(Contact contact, bool isFirstInLetterGroup) {
    if (isFirstInLetterGroup)
      return Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Constants.darkGrey.withOpacity(0.2),
            ),
            child: Text(contact.displayName.substring(0, 1)),
          ),
          _createContactItem(contact)
        ],
      );

    return _createContactItem(contact);
  }

  InkWell _createContactItem(Contact contact) {
    Widget contactDetails = Text(
      contact.displayName.isNotEmpty
          ? contact.displayName
          : contact.phoneNumber,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(fontSize: 18.0),
    );

    if (contact.status.isNotEmpty)
      contactDetails = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 5,
          ),
          Expanded(
            flex: 1,
            child: Text(
              contact.displayName.isNotEmpty
                  ? contact.displayName
                  : contact.phoneNumber,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(contact.status),
          ),
        ],
      );

    return InkWell(
      onTap: () {
        controller.startChat(contact, ChatType.general).then((chat) =>
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => ChatPage(chatId: chat.id))));
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Container(
          height: 50,
          child: Slidable(
            actionPane: SlidableScrollActionPane(),
            child: Row(
              children: [
                AvatarIcon.fromString(contact.profileImage),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: contactDetails,
                  ),
                ),
              ],
            ),
            secondaryActions: [
              IconSlideAction(
                caption: "Edit",
                color: Colors.blue,
                icon: Icons.edit,
                onTap: () => _editContact(contact),
              ),
              IconSlideAction(
                caption: "Delete",
                color: Colors.red,
                icon: Icons.delete,
                onTap: () => _deleteContact(contact),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _editContact(Contact contact) {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (_) => ContactInfoPage(phoneNumber: contact.phoneNumber),
          ),
        )
        .then((_) => controller.reload());
  }

  void _deleteContact(Contact contact) {
    controller.deleteContact(contact.phoneNumber);
  }
}
