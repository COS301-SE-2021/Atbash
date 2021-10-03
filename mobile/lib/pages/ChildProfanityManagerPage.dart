import 'package:flutter/material.dart';
import 'package:mobile/constants.dart';
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
      _ChildProfanityManagerPageState();
}

class _ChildProfanityManagerPageState extends State<ChildProfanityManagerPage> {
  final searchBarController = TextEditingController();

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
                        //TODO: Update filter in model
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
                //TODO: Set item count to filteredPackageCount length
                itemCount: 8,
                itemBuilder: (_, i) {
                  //TODO: Set packageName to controller.model.packageCount[i].second
                  final packageName = "";
                  return InkWell(
                    onLongPress: () {
                      showConfirmDialog(context,
                          "Are you sure you want to delete this profanity package?");
                      //TODO: Add a then and delete by package
                    },
                    child: ExpansionTile(
                      childrenPadding: EdgeInsets.zero,
                      title: Text("Package Name"),
                      //TODO: Replace with _buildWords
                      children: getChildren(5),
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

  List<Widget> getChildren(int count) {
    List<Widget> children = [];
    children.add(
      ListTile(
        onTap: () {},
        title: Text("Add new word to this package."),
        trailing: Icon(Icons.add),
      ),
    );
    for (int i = 0; i < count; i++) {
      children.add(
        ListTile(
          title: Text("Profanity Word"),
          dense: true,
          trailing: IconButton(
            onPressed: () {},
            icon: Icon(Icons.cancel),
          ),
        ),
      );
    }
    return children;
  }

  // List<Widget> _buildWords(List<ChildProfanityWord> profanityWords) {
  //   List<Widget> children = [];
  //   children.add(
  //     ListTile(
  //       onTap: () {
  //         showInputDialog(context, "Please enter the new word to add.")
  //             .then((value) {
  //           if (value != null && value.trim() != "")
  //             controller.addWord(value, profanityWords[0].packageName);
  //           else if (value != null && value.trim() == "")
  //             showSnackBar(context, "Words cannot be empty.");
  //         });
  //       },
  //       title: Text("Add new word to this package."),
  //       trailing: Icon(Icons.add),
  //     ),
  //   );
  //   profanityWords.forEach((profanityWord) {
  //     children.add(
  //       ListTile(
  //         title: Text(profanityWord.word),
  //         dense: true,
  //         trailing: IconButton(
  //           onPressed: () {
  //             controller.deleteWord(profanityWord);
  //           },
  //           icon: Icon(Icons.cancel),
  //         ),
  //       ),
  //     );
  //   });
  //   return children;
  // }
}
