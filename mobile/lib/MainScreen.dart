import 'package:flutter/material.dart';
import 'package:mobile/NewChatScreen.dart';

import 'domain/Contact.dart';

class MainScreen extends StatelessWidget {
  final contacts = [
    Contact("1", "Contact 1"),
    Contact("2", "Contact 2"),
    Contact("3", "Contact 3"),
    Contact("4", "Contact 4"),
    Contact("5", "Contact 5"),
    Contact("6", "Contact 6"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainScreenAppBar(),
      body: ListView(
        children: _buildContactList(),
      ),
    );
  }

  List<Widget> _buildContactList() {
    List<Widget> contactList = [];
    contacts.forEach((contact) => contactList.add(ContactListItem(contact)));
    return contactList;
  }
}

class MainScreenAppBar extends AppBar {
  MainScreenAppBar()
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
              IconButton(onPressed: () {}, icon: Icon(Icons.search)), //Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => NewChatScreen()));
              IconButton(onPressed: () {}, icon: Icon(Icons.more_vert))
            ]);
}

class ContactListItem extends StatelessWidget {
  final Contact _contact;

  ContactListItem(this._contact);

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
                  _contact.name,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 18),
                ),
              ),
            )
          ],
        ),
      ),
      onTap: () {
        print("""Contact with id '${_contact.id}' clicked""");
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
