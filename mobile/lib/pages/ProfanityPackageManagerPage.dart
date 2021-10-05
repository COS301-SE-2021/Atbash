import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobile/constants.dart';
import 'package:mobile/controllers/ProfanityPackageManagerPageController.dart';
import 'package:mobile/pages/ProfanityPackageCreationPage.dart';
import 'package:mobile/pages/ProfanityPackageDetailsPage.dart';
import 'package:mobile/util/Tuple.dart';

class ProfanityPackageManagerPage extends StatefulWidget {
  ProfanityPackageManagerPage();

  @override
  _ProfanityPackageManagerPageState createState() =>
      _ProfanityPackageManagerPageState();
}

class _ProfanityPackageManagerPageState
    extends State<ProfanityPackageManagerPage> {
  final ProfanityPackageManagerPageController controller;

  _ProfanityPackageManagerPageState()
      : this.controller = ProfanityPackageManagerPageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profanity Package Management"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Constants.darkGrey,
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(24)),
                child: Text(
                  "Profanity packages contain a list of words that can be added to your own profanity filter."
                  "You can also create your own to send to others.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ProfanityPackageCreationPage()))
                      .then((value) => controller.reload());
                },
                tileColor: Constants.orange,
                title: Text("Create your own package"),
                trailing: Icon(Icons.add),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Text(
                  "General Packages",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Observer(
                builder: (_) {
                  return Column(
                    children: _buildPackages(
                        controller.model.packageCountsGeneral.toList(), true),
                  );
                },
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Text(
                  "My Packages",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Observer(
                builder: (_) {
                  return Column(
                    children: _buildPackages(
                        controller.model.packageCountsCreated.toList(), false),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildPackages(List<Tuple<int, String>> words, bool general) {
    final packages = <Widget>[];
    words.forEach((element) {
      packages.add(_buildPackageTile(element.second, general));
    });
    return packages;
  }

  Widget _buildPackageTile(String title, bool general) {
    return ExpansionTile(
      title: Text(title),
      children: [
        TextButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ProfanityPackageDetailsPage(
                            packageName: title,
                            profanityWords: controller
                                .model.storedProfanityWords
                                .where(
                                    (element) => element.packageName == title)
                                .toList(),
                          )));
            },
            child: Text("View Details")),
        ListTile(
          leading: TextButton(
            onPressed: () {
              controller.addPackage(controller.model.storedProfanityWords
                  .where((element) => element.packageName == title)
                  .toList());
            },
            child: Text("Add"),
          ),
          trailing: general
              ? null
              : TextButton(
                  onPressed: () {
                    controller.deletePackage(title);
                  },
                  child: Text("Delete"),
                ),
        )
      ],
    );
  }
}
