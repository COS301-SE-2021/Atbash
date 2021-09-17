import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobile/controllers/ContactInfoPageController.dart';
import 'package:mobile/pages/ContactEditPage.dart';
import 'package:mobile/widgets/AvatarIcon.dart';

class ContactInfoPage extends StatefulWidget {
  final String phoneNumber;
  final ContactInfoPageController? controller;

  const ContactInfoPage({
    Key? key,
    required this.phoneNumber,
    this.controller,
  }) : super(key: key);

  @override
  _ContactInfoPageState createState() => _ContactInfoPageState(
        phoneNumber: phoneNumber,
      );
}

class _ContactInfoPageState extends State<ContactInfoPage> {
  final ContactInfoPageController controller;

  _ContactInfoPageState(
      {required String phoneNumber, ContactInfoPageController? controller})
      : controller =
            controller ?? ContactInfoPageController(phoneNumber: phoneNumber);

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
            Navigator.of(context)
                .push(
                  MaterialPageRoute(
                    builder: (_) =>
                        ContactEditPage(phoneNumber: controller.phoneNumber),
                  ),
                )
                .then((_) => this.controller.reload());
          },
          icon: Icon(Icons.edit),
        )
      ],
    );
  }

  Widget _buildBody() {
    return Observer(
      builder: (context) {
        return ListView(
          children: [
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: AvatarIcon.fromString(
                controller.model.profilePicture,
                radius: MediaQuery.of(context).size.width * 0.35,
              ),
            ),
            Observer(
              builder: (context) {
                return Text(
                  controller.model.contactName,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                );
              },
            ),
            SizedBox(
              height: 10,
            ),
            Observer(
              builder: (context) {
                return Text(
                  controller.model.status,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                );
              },
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              controller.phoneNumber,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              //TODO: Implement retrieving birthday from database.
              "11 September 2000",
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 30,
            ),
            if (controller.model.isBlocked)
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 120),
                child: ElevatedButton(
                  onPressed: () => controller.unblockContact(),
                  child: Text("Unblock Contact"),
                ),
              ),
            if (!controller.model.isBlocked)
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 120),
                child: ElevatedButton(
                  onPressed: () => controller.blockContact(),
                  child: Text("Block Contact"),
                ),
              ),
          ],
        );
      },
    );
  }
}
