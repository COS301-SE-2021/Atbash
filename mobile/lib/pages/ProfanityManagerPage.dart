import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobile/constants.dart';
import 'package:mobile/controllers/ProfanityManagerPageController.dart';
import 'package:mobile/dialogs/ConfirmDialog.dart';
import 'package:mobile/dialogs/InputDialog.dart';
import 'package:mobile/domain/ProfanityWord.dart';
import 'package:mobile/pages/ProfanityPackageManagerPage.dart';
import 'package:mobile/util/Utils.dart';

class ProfanityManagerPage extends StatefulWidget {
  ProfanityManagerPage();

  @override
  _ProfanityManagerPageState createState() => _ProfanityManagerPageState();
}

class _ProfanityManagerPageState extends State<ProfanityManagerPage> {
  final searchBarController = TextEditingController();
  final ProfanityManagerPageController controller;

  _ProfanityManagerPageState()
      : this.controller = ProfanityManagerPageController();

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Profanity Management"),
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
                        controller: searchBarController,
                        decoration: InputDecoration(border: InputBorder.none),
                        onChanged: (newValue) {
                          controller.model.filter = newValue;
                        },
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
                                  ProfanityPackageManagerPage()))
                      .then((value) => controller.reload());
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
                        controller.model.packageCounts[i].second;
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
                        title: Text(packageName),
                        children: _buildWords(controller
                            .model.filteredProfanityWords
                            .where(
                                (element) => element.packageName == packageName)
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
    });
  }

  List<Widget> _buildWords(List<ProfanityWord> profanityWords) {
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
