import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobile/constants.dart';
import 'package:mobile/controllers/ProfanityPackageCreationPageController.dart';
import 'package:mobile/dialogs/InputDialog.dart';
import 'package:mobile/util/Utils.dart';

class ProfanityPackageCreationPage extends StatefulWidget {
  const ProfanityPackageCreationPage({Key? key}) : super(key: key);

  @override
  _ProfanityPackageCreationPageState createState() =>
      _ProfanityPackageCreationPageState();
}

class _ProfanityPackageCreationPageState
    extends State<ProfanityPackageCreationPage> {
  final ProfanityPackageCreationPageController controller;
  final packageNameController = TextEditingController();

  _ProfanityPackageCreationPageState()
      : this.controller = ProfanityPackageCreationPageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profanity Package Creation"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            ListTile(
              title: Text(
                "Please provide a name for the new profanity package:",
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
              child: TextField(
                controller: packageNameController,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: "Package Name",
                ),
              ),
            ),
            ListTile(
              tileColor: Constants.orange,
              onTap: () {
                showInputDialog(context, "Please enter the new profanity word:")
                    .then((value) {
                  if (value != null && value.trim() != "")
                    controller.addWord(value);
                  else if (value != null && value.trim() == "")
                    showSnackBar(context, "You cannot add an empty word");
                });
              },
              title: Text("Add Word"),
              trailing: Icon(Icons.add),
            ),
            Expanded(
              child: Observer(
                builder: (_) {
                  return ListView.builder(
                    itemCount: controller.model.storedProfanityWords.length,
                    itemBuilder: (_, i) {
                      final String word =
                          controller.model.storedProfanityWords[i];
                      return ListTile(
                        title: Text(word),
                        trailing: IconButton(
                          onPressed: () {
                            controller.removeWord(word);
                          },
                          icon: Icon(Icons.cancel),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                  color: Constants.orange,
                  borderRadius: BorderRadius.circular(24)),
              child: TextButton(
                onPressed: () {
                  if (packageNameController.text.trim() != "" &&
                      controller.model.storedProfanityWords.isNotEmpty) {
                    controller.createPackage(packageNameController.text);
                    Navigator.pop(context);
                  } else
                    showSnackBar(context,
                        "Please enter a name for the package and ensure there is at least one word.");
                },
                child: Text(
                  "Create New Package",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
