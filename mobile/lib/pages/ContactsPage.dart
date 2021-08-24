import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/dialogs/NewContactDialog.dart';
import 'package:mobile/domain/Chat.dart';
import 'package:mobile/domain/Contact.dart';
import 'package:mobile/models/ChatListModel.dart';
import 'package:mobile/models/ContactListModel.dart';
import 'package:mobile/pages/ChatPage.dart';
import 'package:mobile/pages/ContactInfoPage.dart';
import 'package:mobile/widgets/AvatarIcon.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({Key? key}) : super(key: key);

  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  final ContactListModel contactListModel = GetIt.I.get();
  final ChatListModel chatListModel = GetIt.I.get();

  bool _searching = false;
  String _filterQuery = "";
  TextEditingController _searchController = TextEditingController();
  late final FocusNode _searchFocusNode;

  @override
  void initState() {
    super.initState();

    _searchFocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();

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
    showNewContactDialog(context).then((nameNumberPair) {
      if (nameNumberPair != null) {
        contactListModel.addContact(
          nameNumberPair.phoneNumber,
          nameNumberPair.name,
        );
      }
    });
  }

  List<InkWell> _buildContactList(BuildContext context, bool filtered) {
    List<Contact> contacts = contactListModel.contacts;

    if (filtered) {
      final filterQuery = _filterQuery.toLowerCase();
      contacts = contacts
          .where((c) =>
              c.phoneNumber.contains(filterQuery) ||
              c.displayName.toLowerCase().contains(filterQuery))
          .toList();
    }

    return contacts.map((e) => _buildContact(e)).toList();
  }

  InkWell _buildContact(Contact contact) {
    return InkWell(
      onTap: () {
        final chat =
            chatListModel.startChatWithContact(contact, ChatType.general);
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => ChatPage(chat: chat)));
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
                    child: Text(
                      contact.displayName.isNotEmpty
                          ? contact.displayName
                          : contact.phoneNumber,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 18.0),
                    ),
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
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ContactInfoPage(contact: contact),
      ),
    );
  }

  void _deleteContact(Contact contact) {
    contactListModel.deleteContact(contact.phoneNumber);
  }
}
