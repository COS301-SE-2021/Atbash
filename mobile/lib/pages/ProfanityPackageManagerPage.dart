import 'package:flutter/material.dart';
import 'package:mobile/constants.dart';

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
                onTap: () {},
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
              ExpansionPanelList(
                children: [
                  ExpansionPanel(
                      headerBuilder: (context, isOpen) {
                        return Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Package Name 1",
                            style: TextStyle(fontSize: 18),
                          ),
                        );
                      },
                      body: Center(
                        child: Column(
                          children: [
                            Text(
                              "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
                              style: TextStyle(),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      isExpanded: false,
                      canTapOnHeader: true),
                  ExpansionPanel(
                      headerBuilder: (context, isOpen) {
                        return Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Package Name 2",
                            style: TextStyle(fontSize: 18),
                          ),
                        );
                      },
                      body: Center(
                        child: Column(
                          children: [
                            Text(
                              "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
                              style: TextStyle(),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      isExpanded: true,
                      canTapOnHeader: true),
                ],
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Text(
                  "Contacts Shared Packages",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              ExpansionPanelList(
                children: [
                  ExpansionPanel(
                      headerBuilder: (context, isOpen) {
                        return Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Package Name",
                            style: TextStyle(fontSize: 18),
                          ),
                        );
                      },
                      body: Center(
                        child: Text(
                          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
                          style: TextStyle(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      isExpanded: true,
                      canTapOnHeader: true),
                ],
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Text(
                  "My Created Packages",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              ExpansionPanelList(
                children: [
                  ExpansionPanel(
                      headerBuilder: (context, isOpen) {
                        return Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Package Name",
                            style: TextStyle(fontSize: 18),
                          ),
                        );
                      },
                      body: Center(
                        child: Text(
                          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
                          style: TextStyle(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      isExpanded: true,
                      canTapOnHeader: true),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
