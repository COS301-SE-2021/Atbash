import 'package:flutter/material.dart';

class NewChatScreen extends StatelessWidget {
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
    [].forEach((contact) => contactList.add(ContactListItem()));
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
                  "Contact name",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 18),
                ),
              ),
            )
          ],
        ),
      ),
      onTap: () {
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
