import 'package:flutter/material.dart';

import './domain/Contact.dart';

class NewChatScreen extends StatelessWidget {
  final contactsList = [
    Contact("1", "Contact 1"),
    Contact("2", "Contact 2"),
    Contact("3", "Contact 3"),
    Contact("4", "Contact 4"),
    Contact("5", "Contact 5"),
    Contact("6", "Contact 6"),
    Contact("7", "Contact 7"),
    Contact("8", "Contact 8"),
    Contact("9", "Contact 9"),
    Contact("10", "Contact 10"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NewChatScreenAppBar(),
      body: ListView(
        children: _buildContactList(),
      ),
    );
  }

  List<Widget> _buildContactList() {
    List<Widget> contactList = [];
    contactsList.forEach((contact) => contactList.add(ContactListItem(contact)));
    return contactList;
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
        //IconButton(onPressed: () {}, icon: Icon(Icons.more_vert))
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
        print("""Creating new Chat for Contact with id '${_contact.id}'"""); //Change this to navigate to Chat screen
        //Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ChatScreen()));
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
