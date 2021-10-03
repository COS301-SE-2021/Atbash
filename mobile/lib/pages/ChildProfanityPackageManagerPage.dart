import 'package:flutter/material.dart';
import 'package:mobile/domain/StoredProfanityWord.dart';

class ChildProfanityPackageManagerPage extends StatefulWidget {
  const ChildProfanityPackageManagerPage({Key? key}) : super(key: key);

  @override
  _ChildProfanityPackageManagerPageState createState() =>
      _ChildProfanityPackageManagerPageState();
}

class _ChildProfanityPackageManagerPageState
    extends State<ChildProfanityPackageManagerPage> {
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
            Expanded(child: ListView.builder(itemBuilder: (_, i) {
              return ExpansionTile(
                title: Text("Package Name"),
                leading: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.add),
                ),
                children: _buildWords(8),
              );
            })),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildWords(int count) {
    final words = <Widget>[];
    for (int i = 0; i < count; i++) {
      words.add(
        ListTile(
          title: Text("Profanity Word"),
          dense: true,
        ),
      );
    }

    return words;
  }
}
