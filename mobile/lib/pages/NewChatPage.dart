import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/domain/Contact.dart';
import 'package:mobile/pages/ChatPage.dart';
import 'package:mobile/services/UserService.dart';
import 'package:mobile/widgets/ProfileIcon.dart';

class NewChatPage extends StatefulWidget {
  @override
  _NewChatPageState createState() => _NewChatPageState();
}

class _NewChatPageState extends State<NewChatPage> {
  final _userService = GetIt.I.get<UserService>();

  List<Contact> _contacts = [];

  _NewChatPageState() {
    _userService.getContacts().then((contacts) {
      setState(() {
        _contacts = contacts;
      });
    });
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
      onTap: () {
        _userService.newChat(contact.phoneNumber).then((contact) {
          if (contact != null) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ChatPage(contact)),
            );
          }
        });
      },
    );
  }
}
