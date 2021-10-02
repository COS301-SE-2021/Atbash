import 'package:flutter/material.dart';

class ProfanityPackageCreationPage extends StatefulWidget {
  const ProfanityPackageCreationPage({Key? key}) : super(key: key);

  @override
  _ProfanityPackageCreationPageState createState() =>
      _ProfanityPackageCreationPageState();
}

class _ProfanityPackageCreationPageState
    extends State<ProfanityPackageCreationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profanity Package Creation"),
      ),
    );
  }
}
