import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/domain/Contact.dart';
import 'package:mobile/pages/ChatPage.dart';
import 'package:mobile/pages/LoginPage.dart';
import 'package:mobile/pages/NewChatPage.dart';
import 'package:mobile/pages/SettingsPage.dart';
import 'package:mobile/services/UserService.dart';
import 'package:mobile/widgets/ProfileIcon.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _userService = GetIt.I.get<UserService>();

  String _displayName = "";
  List<Contact> _chatContacts = [];

  _MainPageState() {
    _displayName = _userService.getUser()?.displayName ?? "";

    _userService.getContactsWithChats().then((contacts) {
      setState(() {
        _chatContacts = contacts;
      });
    });

    _userService.onChangeUserInfo((user) {
      setState(() {
        _displayName = user.displayName;
      });
    });

    _userService.onChangeChats((chats) {
      setState(() {
        _chatContacts = chats;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(_displayName),
      actions: [
        IconButton(onPressed: () {}, icon: Icon(Icons.search)),
        PopupMenuButton(
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

  ListView _buildBody() {
    return ListView(
        children: _chatContacts.map((chat) => _buildChat(chat)).toList());
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
}
