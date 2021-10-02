import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfanityPackageDetailsPage extends StatelessWidget {
  ProfanityPackageDetailsPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("'Profanity Package name' Details"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                child: Text(
                  "Package Name",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                child: Text(
                  "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              Column(
                children: _buildWords(5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildWords(int count) {
    List<Widget> words = [];
    for (int i = 0; i < count; i++) {
      words.add(Align(
        alignment: Alignment.centerLeft,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Text(
            "\u2022 Profanity Word",
            style: TextStyle(fontSize: 20),
          ),
        ),
      ));
    }

    return words;
  }
}
