import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobile/controllers/BlockedContactsPageController.dart';
import 'package:mobile/dialogs/NewNumberDialog.dart';
import 'package:mobile/util/Utils.dart';

import '../constants.dart';

class BlockedContactsPage extends StatefulWidget {
  const BlockedContactsPage({Key? key}) : super(key: key);

  @override
  _BlockedContactsPageState createState() => _BlockedContactsPageState();
}

class _BlockedContactsPageState extends State<BlockedContactsPage> {
  final BlockedContactsPageController controller;
  _BlockedContactsPageState() : controller = BlockedContactsPageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text("Blocked Contacts"),
      actions: [
        IconButton(
          onPressed: () => _addBlockedContact(),
          icon: Icon(
            Icons.add,
          ),
          splashRadius: 24,
        )
      ],
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 4 / 5,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Constants.darkGrey.withOpacity(0.5),
          ),
          child: Row(
            children: [
              Icon(
                Icons.search,
                size: 20,
              ),
              Expanded(
                child: TextField(
                  onChanged: (String input) {
                    controller.updateQuery(input);
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintText: "Search",
                    contentPadding: EdgeInsets.all(2),
                    isDense: true,
                  ),
                ),
              ),
            ],
          ),
        ),
        Observer(builder: (_) {
          String name = "";

          return ListView.builder(
              shrinkWrap: true,
              itemCount: controller.model.filteredNumbers.length,
              itemBuilder: (BuildContext context, int index) {
                if (controller.model.contacts.any((element) =>
                    element.phoneNumber ==
                    controller.model.filteredNumbers[index].phoneNumber))
                  name = controller.model.contacts
                      .firstWhere((element) =>
                          element.phoneNumber ==
                          controller.model.filteredNumbers[index].phoneNumber)
                      .displayName;
                else
                  name = controller.model.filteredNumbers[index].phoneNumber;
                return _buildContactItem(
                    controller.model.filteredNumbers[index].phoneNumber, name);
              });
        })
      ],
    );
  }

  Widget _buildContactItem(String blockedNumber, contactName) {
    return Container(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15),
            padding: EdgeInsets.all(5),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    contactName,
                    textAlign: TextAlign.left,
                  ),
                ),
                IconButton(
                  onPressed: () => _removeBlockedContact(blockedNumber),
                  icon: Icon(Icons.cancel),
                  splashRadius: 24,
                )
              ],
            ),
          ),
          Divider(
            height: 2,
            thickness: 2,
          ),
        ],
      ),
    );
  }

  void _addBlockedContact() async {
    final input = await showNewNumberDialog(context);
    if (input != null)
      controller.addNumber(input).catchError((_) {
        showSnackBar(context, "This number has already been blocked.");
      });
  }

  void _removeBlockedContact(String blockedNumber) {
    controller.deleteNumber(blockedNumber).catchError((_) {
      showSnackBar(context, "The number you tried to remove is not blocked.");
    });
  }
}
