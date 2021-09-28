import 'package:flutter/material.dart';

class NewParentPage extends StatefulWidget {
  const NewParentPage({Key? key}) : super(key: key);

  @override
  _NewParentPageState createState() => _NewParentPageState();
}

class _NewParentPageState extends State<NewParentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Text("HEY"),
            Expanded(
              child: ListView.builder(
                  itemCount: 18,
                  itemBuilder: (_, i) {
                    return Text("LOL");
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
