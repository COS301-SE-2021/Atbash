import 'package:flutter/material.dart';
import 'package:mobile/ChatScreen.dart';
import 'package:mobile/NewChatScreen.dart';
import 'package:mobile/SettingsScreen.dart';

import 'LoginScreen.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainScreenAppBar(context),
      body: ListView(
        children: _buildChatList(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.chat),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => NewChatScreen()));
        },
      ),
    );
  }

  List<Widget> _buildChatList() {
    return [].map((c) => ChatListItem()).toList();
  }
}

enum MenuItem { settings, logout }

extension MenuItemExtension on MenuItem {
  get text {
    switch (this) {
      case MenuItem.settings:
        return "Settings";
      case MenuItem.logout:
        return "Logout";
    }
  }
}

class MainScreenAppBar extends AppBar {
  MainScreenAppBar(BuildContext context)
      : super(
            title: Row(
              children: [
                EmptyProfileIcon(Colors.white),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      "Dylan Pfab",
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )
              ],
            ),
            actions: [
              IconButton(onPressed: () {}, icon: Icon(Icons.search)),
              PopupMenuButton(
                onSelected: (value) =>
                    menuItemSelected(value as MenuItem, context),
                itemBuilder: (context) {
                  return MenuItem.values.map((menuItem) {
                    return PopupMenuItem(
                      child: Text(menuItem.text),
                      value: menuItem,
                    );
                  }).toList();
                },
              )
            ]);

  static void menuItemSelected(MenuItem selected, BuildContext context) {
    switch (selected) {
      case MenuItem.settings:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SettingsScreen()));
        break;
      case MenuItem.logout:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
        break;
    }
  }
}

class ChatListItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          children: [
            EmptyProfileIcon(Colors.black),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  "Chat with user",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 18),
                ),
              ),
            )
          ],
        ),
      ),
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ChatScreen()));
      },
    );
  }
}

class EmptyProfileIcon extends StatelessWidget {
  final Color _color;

  EmptyProfileIcon(this._color);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        border: Border.all(width: 1, color: _color),
      ),
      padding: EdgeInsets.all(4.0),
      child: Icon(
        Icons.person,
        color: _color,
      ),
    );
  }
}
