import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/domain/StoredProfanityWord.dart';

class ProfanityPackageDetailsPage extends StatelessWidget {
  final String packageName;
  final List<StoredProfanityWord> profanityWords;
  ProfanityPackageDetailsPage(
      {required this.packageName, required this.profanityWords});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$packageName Details"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
              child: Text(
                packageName,
                style: TextStyle(fontSize: 20),
              ),
            ),
            Expanded(
                child: ListView.builder(
                    itemCount: profanityWords.length,
                    itemBuilder: (_, i) {
                      return ListTile(
                        title: Text("\u2022 ${profanityWords[i].word}"),
                      );
                    })),
          ],
        ),
      ),
    );
  }
}
