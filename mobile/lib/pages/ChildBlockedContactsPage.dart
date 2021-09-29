import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobile/constants.dart';
import 'package:mobile/controllers/ChildBlockedContactsPageController.dart';
import 'package:mobile/dialogs/ConfirmDialog.dart';
import 'package:mobile/dialogs/NewNumberDialog.dart';
import 'package:mobile/domain/Child.dart';
import 'package:mobile/util/Utils.dart';

class ChildBlockedContactsPage extends StatefulWidget {
  final Child child;

  const ChildBlockedContactsPage({Key? key, required this.child})
      : super(key: key);

  @override
  _ChildBlockedContactsPageState createState() =>
      _ChildBlockedContactsPageState(child: child);
}

class _ChildBlockedContactsPageState extends State<ChildBlockedContactsPage> {
  final ChildBlockedContactsPageController controller;
  final childNumber;

  _ChildBlockedContactsPageState({required Child child})
      : controller = ChildBlockedContactsPageController(child.phoneNumber),
        childNumber = child.phoneNumber;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Blocked Contacts"),
        actions: [
          IconButton(
            onPressed: () => _addBlockedContact(childNumber),
            icon: Icon(
              Icons.add,
            ),
            splashRadius: 24,
          )
        ],
      ),
      body: Column(
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
                    key: Key('BlockedContactsPage_search'),
                    onChanged: (String input) {
                      //controller.updateQuery(input);
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
          Observer(
            builder: (_) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: controller.model.filteredNumbers.length,
                itemBuilder: (BuildContext context, int index) {
                  return _buildContactItem(
                      controller.model.filteredNumbers[index].blockedNumber,
                      controller.model.chats[index].otherPartyName == null
                          ? controller.model.chats[index].otherPartyNumber
                          : controller.model.chats[index].otherPartyName);
                },
              );
            },
          )
        ],
      ),
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
                  onPressed: () => showConfirmDialog(context,
                          "Are you sure you want to remove $contactName from your blocked contacts?")
                      .then((value) {
                    if (value != null && value)
                      _removeBlockedContact(blockedNumber);
                  }),
                  icon: Icon(
                    Icons.cancel,
                    key: Key('BlockedContactsPage_remove_$blockedNumber'),
                  ),
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

  void _addBlockedContact(String childNumber) async {
    final input = await showNewNumberDialog(
        context, "Please insert the number you wish to block.");
    if (input != null)
      controller.addNumber(childNumber, input).catchError((_) {
        showSnackBar(context, "This number has already been blocked.");
      });
  }

  void _removeBlockedContact(String blockedNumber) {
    controller.deleteNumber(childNumber, blockedNumber).catchError((_) {
      showSnackBar(context, "The number you tried to remove is not blocked.");
    });
  }
}
