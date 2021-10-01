import 'package:flutter/material.dart';

class ProfanityManagerPage extends StatefulWidget {
  const ProfanityManagerPage({Key? key}) : super(key: key);

  @override
  _ProfanityManagerPageState createState() => _ProfanityManagerPageState();
}

class _ProfanityManagerPageState extends State<ProfanityManagerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profanity Management",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
