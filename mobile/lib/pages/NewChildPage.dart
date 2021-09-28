import 'package:flutter/material.dart';
import 'package:mobile/constants.dart';
import 'package:mobile/controllers/NewChildPageController.dart';
import 'package:mobile/domain/Child.dart';
import 'package:mobile/domain/Contact.dart';
import 'package:mobile/util/Utils.dart';
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
  final pinTextController = TextEditingController();
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
            Container(child: Expanded(child: _buildContacts())),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.black)),
              child: Text(
                "Please provide a 4 digit pin that will be used to control the child's account.",
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.2),
              child: TextField(
                keyboardType: TextInputType.number,
                maxLength: 4,
                controller: pinTextController,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  isDense: true,
                  hintText: "1234",
                ),
              ),
            ),
            //if(contact selected)
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Constants.orange,
                borderRadius: BorderRadius.circular(16),
              ),
              child: TextButton(
                onPressed: () {
                  if (RegExp(r"^[0-9]{4}$")
                          .firstMatch(pinTextController.text) !=
                      null) {
                    final newContact = chosenContact;
                    if (newContact != null) {
                      final child = Child(
                          phoneNumber: newContact.phoneNumber,
                          name: newContact.displayName,
                          pin: pinTextController.text);
                      controller.addChild(child);
                    }
                    return;
                  } else
                    showSnackBar(context, "The pin must be exactly 4 digits");
                },
                child: Text(
                  "Add child",
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
      title: Text(contact.displayName),
      subtitle: Text(contact.status),
      leading: AvatarIcon.fromString(contact.profileImage),
      onTap: () => chosenContact = contact,
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
