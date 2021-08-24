import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobile/domain/Contact.dart';
import 'package:mobile/pages/ContactEditPage.dart';
import 'package:mobile/widgets/AvatarIcon.dart';

class ContactInfoPage extends StatefulWidget {
  final Contact contact;

  const ContactInfoPage({
    Key? key,
    required this.contact,
  }) : super(key: key);

  @override
  _ContactInfoPageState createState() => _ContactInfoPageState();
}

class _ContactInfoPageState extends State<ContactInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      actions: [
        IconButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ContactEditPage(contact: widget.contact),
              ),
            );
          },
          icon: Icon(Icons.edit),
        )
      ],
    );
  }

  Widget _buildBody() {
    return Observer(builder: (context) {
      return ListView(
        children: [
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: AvatarIcon.fromString(
              widget.contact.profileImage,
              radius: MediaQuery.of(context).size.width * 0.35,
            ),
          ),
          Text(
            widget.contact.displayName,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            widget.contact.status,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            widget.contact.phoneNumber,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      );
    });
  }
}
