import 'package:flutter/material.dart';
import 'package:mobile/constants.dart';
import 'package:mobile/dialogs/ConfirmDialog.dart';
import 'package:mobile/pages/ProfanityPackageManagerPage.dart';

class ProfanityManagerPage extends StatefulWidget {
  final childNumber;
  ProfanityManagerPage({required this.childNumber});

  @override
  _ProfanityManagerPageState createState() => _ProfanityManagerPageState();
}

class _ProfanityManagerPageState extends State<ProfanityManagerPage> {
  String choice = "Package 1";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profanity Management}"),
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
                        builder: (context) => ProfanityPackageManagerPage()));
              },
              tileColor: Constants.orange,
              title: Text("Add New Packages"),
              trailing: Icon(Icons.add),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 8,
                itemBuilder: (_, i) {
                  return InkWell(
                    onLongPress: () {
                      showConfirmDialog(context,
                          "Are you sure you want to delete this profanity package?");
                    },
                    child: ExpansionTile(
                      childrenPadding: EdgeInsets.zero,
                      title: Text("Package Name"),
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
}
