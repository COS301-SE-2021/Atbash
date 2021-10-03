import 'package:flutter/material.dart';
import 'package:mobile/constants.dart';
import 'package:mobile/pages/ProfanityPackageCreationPage.dart';
import 'package:mobile/pages/ProfanityPackageDetailsPage.dart';

class ProfanityPackageManagerPage extends StatefulWidget {
  ProfanityPackageManagerPage();

  @override
  _ProfanityPackageManagerPageState createState() =>
      _ProfanityPackageManagerPageState();
}

class _ProfanityPackageManagerPageState
    extends State<ProfanityPackageManagerPage> {
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
                  "Profanity packages contain profanity words blah blah blah.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => ProfanityPackageCreationPage()));
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
              _buildPackageTile("Package Name"),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Text(
                  "My Packages",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              _buildPackageTile("Package Name"),
              _buildPackageTile("Package Name"),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Text(
                  "Imported Packages",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              _buildPackageTile("Package Name")
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPackageTile(String title) {
    return ExpansionTile(
      title: Text(title),
      children: [
        TextButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ProfanityPackageDetailsPage()));
            },
            child: Text("View Details")),
        ListTile(
          leading: TextButton(
            onPressed: () {},
            child: Text("Add"),
          ),
          trailing: TextButton(
            onPressed: () {},
            child: Text("Delete"),
          ),
        )
      ],
    );
  }
}
