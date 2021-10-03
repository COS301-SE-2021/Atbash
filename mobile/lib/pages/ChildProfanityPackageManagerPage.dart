import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobile/controllers/ChildProfanityPackageManagerPageController.dart';
import 'package:mobile/domain/StoredProfanityWord.dart';

class ChildProfanityPackageManagerPage extends StatefulWidget {
  final String childNumber;
  ChildProfanityPackageManagerPage({required this.childNumber});

  @override
  _ChildProfanityPackageManagerPageState createState() =>
      _ChildProfanityPackageManagerPageState(childNumber: childNumber);
}

class _ChildProfanityPackageManagerPageState
    extends State<ChildProfanityPackageManagerPage> {
  final ChildProfanityPackageManagerPageController controller;
  final String childNumber;

  _ChildProfanityPackageManagerPageState({required this.childNumber})
      : this.controller = ChildProfanityPackageManagerPageController(
            childNumber: childNumber);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Child Package Management"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                  "Please select the packages you wish to add to your child's profanity filter."),
            ),
            Expanded(
              child: Observer(
                builder: (_) {
                  return ListView.builder(
                      itemCount: controller.model.packageCounts.length,
                      itemBuilder: (_, i) {
                        final packageName =
                            controller.model.packageCounts[i].second;
                        return ExpansionTile(
                          title: Text(packageName),
                          leading: IconButton(
                            onPressed: () {
                              controller.addPackage(controller
                                  .model.storedProfanityWords
                                  .where((word) =>
                                      word.packageName.toLowerCase() ==
                                      packageName.toLowerCase())
                                  .toList());
                            },
                            icon: Icon(Icons.add),
                          ),
                          children: _buildWords(controller
                              .model.storedProfanityWords
                              .where((word) =>
                                  word.packageName.toLowerCase() ==
                                  packageName.toLowerCase())
                              .toList()),
                        );
                      });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildWords(List<StoredProfanityWord> profanityWords) {
    final words = <Widget>[];
    profanityWords.forEach((word) {
      words.add(ListTile(
        title: Text(word.word),
      ));
    });
    return words;
  }
}
