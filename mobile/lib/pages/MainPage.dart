import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/domain/Contact.dart';
import 'package:mobile/pages/ChatPage.dart';
import 'package:mobile/pages/LoginPage.dart';
import 'package:mobile/pages/NewChatPage.dart';
import 'package:mobile/pages/SettingsPage.dart';
import 'package:mobile/services/AppService.dart';
import 'package:mobile/services/ContactsService.dart';
import 'package:mobile/services/UserService.dart';
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
  List<Contact> _chatContacts = [];
  List<Contact> _filteredContacts = [];
  bool _searching = false;

  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _userService.onUserDisplayNameChanged((name) {
      setState(() {
        _displayName = name;
      });
    }).then((name) {
      setState(() {
        _displayName = name;
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

    _appService.disconnect();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_searching) {
          _stopSearching();
          return false;
        } else {
          return true;
        }
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

  AppBar _buildAppBar(BuildContext context) {
    Widget title = Text(_displayName);

    if (_searching) {
      title = TextField(
        controller: _searchController,
        onChanged: _filter,
      );
    }

    return AppBar(
      title: title,
      leading: _searching
          ? IconButton(onPressed: _stopSearching, icon: Icon(Icons.arrow_back))
          : null,
      actions: [
        if (!_searching)
          IconButton(
              onPressed: () {
                setState(() {
                  _searching = true;
                });
              },
              icon: Icon(Icons.search)),
        PopupMenuButton(
          icon: new Icon(Icons.more_vert),
          itemBuilder: (context) {
            return ["Settings", "Logout"].map((menuItem) {
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
            } else if (value == "Logout") {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
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
                c.displayName.toLowerCase().contains(searchQuery.toLowerCase()))
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

  InkWell _buildChat(Contact contact) {
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ChatPage(contact)));
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
        _chatContacts = contacts;
        _filteredContacts = contacts;
      });
    });
  }
}
