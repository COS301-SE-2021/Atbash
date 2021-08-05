import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/dialogs/NewContactDialog.dart';
import 'package:mobile/domain/Contact.dart';
import 'package:mobile/exceptions/DuplicateContactNumberException.dart';
import 'package:mobile/models/ContactsModel.dart';
import 'package:mobile/pages/ChatPage.dart';
import 'package:mobile/widgets/AvatarIcon.dart';

class NewChatPage extends StatefulWidget {
  @override
  _NewChatPageState createState() => _NewChatPageState();
}

class _NewChatPageState extends State<NewChatPage> {
  bool _searching = false;
  final ContactsModel _contactsModel = GetIt.I.get();

  final _searchController = TextEditingController();
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
          setState(() {
            _searching = false;
            _contactsModel.filter = "";
            _searchController.text = "";
          });
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        appBar: _buildAppBar(),
        body: _buildBody(context),
      ),
    );
  }

  AppBar _buildAppBar() {
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

      _searchFocusNode.requestFocus();
    }
    return AppBar(
      title: Row(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: title,
            ),
          ),
        ],
      ),
      actions: [
        if (!_searching)
          IconButton(
            onPressed: () {
              setState(() {
                _searching = true;
              });
            },
            icon: Icon(Icons.search),
          ),
      ],
    );
  }

  void _filter(String searchQuery) {
    _contactsModel.filter = searchQuery;
  }

  Observer _buildBody(BuildContext context) {
    return Observer(builder: (_) {
      return ListView(
        children: [
          _buildNewContactItem(context),
          ..._buildContactList(context, _contactsModel.filteredSavedContacts),
        ],
      );
    });
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
      (nameNumberPair) async {
        if (nameNumberPair != null) {
          try {
            await _contactsModel.addContact(
              nameNumberPair.phoneNumber,
              nameNumberPair.name,
              false,
              true,
            );
          } on DuplicateContactNumberException {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "This number already exists in your contacts",
                ),
              ),
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("An error occurred"),
              ),
            );
          }
        }
      },
    );
  }

  List<InkWell> _buildContactList(
    BuildContext context,
    List<Contact> contacts,
  ) {
    return contacts.map((e) => _buildContact(context, e)).toList();
  }

  InkWell _buildContact(BuildContext context, Contact contact) {
    return InkWell(
      onTap: () => _startChat(context, contact),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          children: [
            AvatarIcon.fromString(contact.profileImage),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
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
      ),
    );
  }

  void _startChat(BuildContext context, Contact contact) {
    _contactsModel.startChatWithContact(contact.phoneNumber);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(contact),
      ),
    );
  }
}
