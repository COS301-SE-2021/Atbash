import 'package:flutter/material.dart';
import 'package:mobile/model/SystemModel.dart';
import 'package:provider/provider.dart';

import 'ChatScreen.dart';
import 'domain/Contact.dart';

class NewChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<SystemModel>(builder: (context, systemModel, child) {
      return Scaffold(
        appBar: NewChatScreenAppBar(),
        body: ListView(
          children: _buildContactList(systemModel),
        ),
      );
    });
  }

  List<Widget> _buildContactList(SystemModel systemModel) {
    return systemModel.userContacts
        .map((c) => ContactListItem(c, systemModel))
        .toList();
  }
}

class NewChatScreenAppBar extends AppBar {
  NewChatScreenAppBar()
      : super(
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
                )
              ],
            ),
            actions: [
              IconButton(onPressed: () {}, icon: Icon(Icons.search)),
            ]);
}

class ContactListItem extends StatelessWidget {
  final Contact _contact;
  final SystemModel _systemModel;

  ContactListItem(this._contact, this._systemModel);

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
                  _contact.displayName,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 18),
                ),
              ),
            )
          ],
        ),
      ),
      onTap: () {
        if (_contact.chat == null) {
          _systemModel.createChatWithContact(_contact.phoneNumber);
        }
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => ChatScreen(_contact)));
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
