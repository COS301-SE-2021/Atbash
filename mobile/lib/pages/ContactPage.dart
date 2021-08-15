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
    return Column(
      children: [
        //Base64Decoder().convert(widget.contact.profileImage),
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: AvatarIcon.fromString(
            widget.contact.profileImage,
            radius: MediaQuery.of(context).size.width * 0.65,
          ),
        ),
        Divider(
          thickness: 5.0,
          color: Colors.black,
          height: 5.0,
        ),
        Row(children: [
          Text("Display Name:"),
          Text(widget.contact.displayName),
        ]),
        Divider(
          thickness: 5.0,
          color: Colors.black,
          height: 5.0,
        ),
        Container(
          padding: EdgeInsets.zero,
          color: Constants.orangeColor,
          child: Row(children: [
            Expanded(
              child: Text("Number:"),
              flex: 1,
            ),
            Expanded(
              child: Text(widget.contact.phoneNumber),
              flex: 2,
            ),
          ]),
        ),
        Divider(
          thickness: 5.0,
          color: Colors.black,
          height: 5.0,
        ),
        Row(children: [
          Text("Status:"),
          Text(widget.contact.status),
        ]),
      ],
    );
  }
}
