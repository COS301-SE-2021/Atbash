import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/dialogs/ConfirmDialog.dart';
import 'package:mobile/domain/Contact.dart';
import 'package:mobile/pages/ChatPage.dart';
import 'package:mobile/pages/NewChatPage.dart';
import 'package:mobile/pages/SettingsPage.dart';
import 'package:mobile/services/AppService.dart';
import 'package:mobile/services/ContactsService.dart';
import 'package:mobile/services/UserService.dart';
import 'package:mobile/util/Tuple.dart';
import 'package:mobile/widgets/AvatarIcon.dart';
import 'package:mobile/widgets/ProfileIcon.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final UserService _userService = GetIt.I.get();
  final ContactsService _contactsService = GetIt.I.get();
  final AppService _appService = GetIt.I.get();

  String _displayName = "";
  Uint8List? _profileImage;
  List<Tuple<Contact, bool>> _chatContacts = [];
  List<Tuple<Contact, bool>> _filteredContacts = [];
  bool _searching = false;

  bool _selecting = false;

  final _searchController = TextEditingController();
  late final FocusNode _searchFocusNode;

  @override
  void initState() {
    super.initState();

    _searchFocusNode = FocusNode();

    _userService
        .onUserDisplayNameChanged(_onDisplayNameChanged)
        .then(_onDisplayNameChanged);

    _userService.getUserProfilePicture().then((value) {
      setState(() {
        _profileImage = value;
      });
    });

    _contactsService.onContactsChanged(() {
      _populateChats();
    });
    _populateChats();

    _appService.goOnline();
  }

  @override
  void dispose() {
    super.dispose();
    _userService.disposeUserDisplayNameListener(_onDisplayNameChanged);
    _searchFocusNode.dispose();
    _appService.disconnect();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool shouldPop = true;

        if (_selecting) {
          _stopSelecting();
          shouldPop = false;
        }

        if (_searching) {
          _stopSearching();
          shouldPop = false;
        }
        return shouldPop;
      },
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: _buildBody(),
        floatingActionButton: _buildFloatingActionButton(context),
      ),
    );
  }

  void _stopSearching() {
    setState(() {
      _searching = false;
      _filteredContacts = _chatContacts;
      _searchController.text = "";
    });
  }

  void _stopSelecting() {
    setState(() {
      _selecting = false;
      _chatContacts.forEach((element) => element.second = false);
      _filteredContacts.forEach((element) => element.second = false);
    });
  }

  AppBar _buildAppBar(BuildContext context) {
    Widget title = Row(
      children: [
        AvatarIcon.fromUIntList(_profileImage),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(_displayName),
        ),
      ],
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
      title: title,
      leading: _searching || _selecting
          ? IconButton(
              onPressed: () {
                if (_searching) _stopSearching();
                if (_selecting) _stopSelecting();
              },
              icon: Icon(Icons.arrow_back),
            )
          : null,
      actions: [
        if (!_selecting && !_searching)
          IconButton(
              onPressed: () {
                setState(() {
                  _searching = true;
                });
              },
              icon: Icon(Icons.search)),
        if (_selecting)
          IconButton(
            onPressed: () {
              final selectedChats = _filteredContacts
                  .where((element) => element.second == true)
                  .map((e) => e.first.phoneNumber)
                  .toList();

              showConfirmDialog(context,
                      "This will delete ${selectedChats.length} chat(s). Are you sure?")
                  .then((confirmed) {
                if (confirmed != null && confirmed) {
                  _contactsService.deleteChatsWithContacts(selectedChats);
                }
              });
            },
            icon: Icon(Icons.delete),
          ),
        PopupMenuButton(
          icon: new Icon(Icons.more_vert),
          itemBuilder: (context) {
            return ["Settings"].map((menuItem) {
              return PopupMenuItem(
                child: Text(menuItem),
                value: menuItem,
              );
            }).toList();
          },
          onSelected: (value) {
            if (value == "Settings") {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            }
          },
        ),
      ],
    );
  }

  void _filter(String searchQuery) {
    if (searchQuery.isNotEmpty) {
      setState(() {
        _filteredContacts = _chatContacts
            .where((c) =>
                c.first.displayName
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) ||
                c.first.phoneNumber.contains(searchQuery))
            .toList();
      });
    } else {
      setState(() {
        _filteredContacts = _chatContacts;
      });
    }
  }

  ListView _buildBody() {
    return ListView(
        children: _filteredContacts.map((chat) => _buildChat(chat)).toList());
  }

  InkWell _buildChat(Tuple<Contact, bool> contact) {
    return InkWell(
      onTap: () {
        if (_selecting) {
          setState(() {
            contact.second = !contact.second;
          });
        } else {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ChatPage(contact.first)));
        }
      },
      onLongPress: () {
        if (!_searching) {
          setState(() {
            _selecting = true;
            contact.second = true;
          });
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          children: [
            EmptyProfileIcon(Colors.black),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  contact.first.displayName.isNotEmpty
                      ? contact.first.displayName
                      : contact.first.phoneNumber,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            ),
            if (_selecting)
              Checkbox(
                  value: contact.second,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        contact.second = value;
                      });
                    }
                  })
          ],
        ),
      ),
    );
  }

  FloatingActionButton _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NewChatPage()),
        );
      },
      child: Icon(Icons.chat),
    );
  }

  void _populateChats() {
    _contactsService.getAllChats().then((contacts) {
      setState(() {
        _chatContacts = _selectableContactsFromContacts(contacts);
        _filteredContacts = _chatContacts;
      });
    });
  }

  List<Tuple<Contact, bool>> _selectableContactsFromContacts(List<Contact> l) {
    return l.map((e) => Tuple(e, false)).toList();
  }

  void _onDisplayNameChanged(String name) {
    setState(() {
      _displayName = name;
    });
  }
}
