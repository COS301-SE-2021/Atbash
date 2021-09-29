import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobile/constants.dart';
import 'package:mobile/controllers/NewChildPageController.dart';
import 'package:mobile/domain/Child.dart';
import 'package:mobile/domain/Contact.dart';
import 'package:mobile/widgets/AvatarIcon.dart';

class NewChildPage extends StatefulWidget {
  const NewChildPage({Key? key}) : super(key: key);

  @override
  _NewChildPageState createState() => _NewChildPageState();
}

class _NewChildPageState extends State<NewChildPage> {
  final NewChildPageController controller;

  _NewChildPageState() : controller = NewChildPageController();

  final filterTextController = TextEditingController();
  Contact? chosenContact;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                "Select the contact you wish to add as a child.",
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
            _buildSearchBar(),
            Observer(builder: (context) {
              return Expanded(child: _buildContacts());
            }),
            if (chosenContact != null)
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Constants.orange,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TextButton(
                  onPressed: () {
                    final newContact = chosenContact;
                    if (newContact != null) {
                      final child = Child(
                          phoneNumber: newContact.phoneNumber,
                          name: newContact.displayName);
                      Navigator.pop(context);
                    }
                    return;
                  },
                  child: Text(
                    "Add ${chosenContact?.displayName}",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }

  Widget _buildContacts() {
    return ListView.builder(
      itemCount: controller.model.filteredContacts.length,
      itemBuilder: (context, index) {
        return _buildContact(controller.model.filteredContacts[index]);
      },
    );
  }

  ListTile _buildContact(Contact contact) {
    return ListTile(
      tileColor: contact.phoneNumber == chosenContact?.phoneNumber
          ? Constants.orange.withOpacity(0.88)
          : null,
      title: Text(contact.displayName),
      subtitle: Text(contact.status),
      leading: AvatarIcon.fromString(contact.profileImage),
      onTap: () {
        setState(() {
          chosenContact = contact;
        });
      },
      dense: true,
    );
  }

  Container _buildSearchBar() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 35),
      child: Row(
        children: [
          Icon(Icons.search),
          SizedBox(
            width: 5,
          ),
          Expanded(
              child: TextField(
            onChanged: (String newValue) {
              controller.model.filter = newValue;
            },
            controller: filterTextController,
            decoration: InputDecoration(isDense: true),
          )),
        ],
      ),
    );
  }
}
