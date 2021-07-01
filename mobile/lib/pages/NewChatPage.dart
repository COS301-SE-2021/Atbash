import 'package:flutter/material.dart';
import 'package:mobile/domain/Contact.dart';
import 'package:mobile/widgets/ProfileIcon.dart';

class NewChatPage extends StatefulWidget {
  @override
  _NewChatPageState createState() => _NewChatPageState();
}

class _NewChatPageState extends State<NewChatPage> {
  List<Contact> _contacts = [];

  @override
  void initState() {
    super.initState();

    // TODO set contacts and listen for changes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(context),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
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
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.search),
        ),
      ],
    );
  }

  ListView _buildBody(BuildContext context) {
    return ListView(
      children: _buildContactList(context),
    );
  }

  List<InkWell> _buildContactList(BuildContext context) {
    return _contacts.map((e) => _buildContact(context, e)).toList();
  }

  InkWell _buildContact(BuildContext context, Contact contact) {
    return InkWell(
      onTap: () => _startChat(context, contact),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          children: [
            EmptyProfileIcon(Colors.black),
            Expanded(
              child: Padding(
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

  void _startChat(BuildContext context, Contact contact) {
    // TODO needs implementation
  }
}
