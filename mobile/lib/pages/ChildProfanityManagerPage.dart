import 'package:flutter/material.dart';
import 'package:mobile/constants.dart';
import 'package:mobile/controllers/ChildProfanityManagerPageController.dart';
import 'package:mobile/dialogs/ConfirmDialog.dart';
import 'package:mobile/dialogs/InputDialog.dart';
import 'package:mobile/domain/ChildProfanityWord.dart';
import 'package:mobile/util/Utils.dart';

import 'ChildProfanityPackageManagerPage.dart';

class ChildProfanityManagerPage extends StatefulWidget {
  final String childNumber;

  ChildProfanityManagerPage({required this.childNumber});

  @override
  _ChildProfanityManagerPageState createState() =>
      _ChildProfanityManagerPageState(childNumber: childNumber);
}

class _ChildProfanityManagerPageState extends State<ChildProfanityManagerPage> {
  final searchBarController = TextEditingController();
  final ChildProfanityManagerPageController controller;
  final childNumber;

  _ChildProfanityManagerPageState({required this.childNumber})
      : this.controller =
            ChildProfanityManagerPageController(childNumber: childNumber);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Child Profanity Management"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.black),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.search),
                  Expanded(
                    child: TextField(
                      onChanged: (newValue) {
                        controller.model.filter = newValue;
                      },
                      controller: searchBarController,
                      decoration: InputDecoration(border: InputBorder.none),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ChildProfanityPackageManagerPage()));
              },
              tileColor: Constants.orange,
              title: Text("Add New Packages"),
              trailing: Icon(Icons.add),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: controller.model.filteredPackageCounts.length,
                itemBuilder: (_, i) {
                  final packageName =
                      controller.model.filteredPackageCounts[i].second;
                  return InkWell(
                    onLongPress: () {
                      showConfirmDialog(context,
                              "Are you sure you want to delete this profanity package?")
                          .then((value) {
                        if (value != null && value)
                          controller.deletePackage(packageName);
                      });
                    },
                    child: ExpansionTile(
                      childrenPadding: EdgeInsets.zero,
                      title: Text("Package Name"),
                      //TODO: Replace with _buildWords
                      children: _buildWords(controller
                          .model.filteredProfanityWords
                          .where((word) => word.packageName == packageName)
                          .toList()),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildWords(List<ChildProfanityWord> profanityWords) {
    List<Widget> children = [];
    children.add(
      ListTile(
        onTap: () {
          showInputDialog(context, "Please enter the new word to add.")
              .then((value) {
            if (value != null && value.trim() != "")
              controller.addWord(value, profanityWords[0].packageName);
            else if (value != null && value.trim() == "")
              showSnackBar(context, "Words cannot be empty.");
          });
        },
        title: Text("Add new word to this package."),
        trailing: Icon(Icons.add),
      ),
    );
    profanityWords.forEach((profanityWord) {
      children.add(
        ListTile(
          title: Text(profanityWord.word),
          dense: true,
          trailing: IconButton(
            onPressed: () {
              controller.deleteWord(profanityWord);
            },
            icon: Icon(Icons.cancel),
          ),
        ),
      );
    });
    return children;
  }
}
