import 'package:flutter/material.dart';
import 'package:mobile/domain/Contact.dart';
import 'package:mobile/constants.dart';
import 'package:mobile/widgets/AvatarIcon.dart';

class ContactPage extends StatefulWidget {
  final Contact contact;

  ContactPage(this.contact);

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text("Contact Info"),
      actions: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "Edit",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
            ),
          ),
        )
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return ListView(
      children: [
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: AvatarIcon.fromString(
            widget.contact.profileImage,
            radius: MediaQuery.of(context).size.width * 0.35,
          ),
        ),
        Text(
          "Liam Mayston",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.bold,
          ),
        ),

      ],
    );
  }
}
