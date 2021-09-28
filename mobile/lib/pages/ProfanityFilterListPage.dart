import 'package:flutter/material.dart';

class ProfanityFilterListPage extends StatefulWidget {
  const ProfanityFilterListPage({Key? key}) : super(key: key);

  @override
  _ProfanityFilterListPageState createState() =>
      _ProfanityFilterListPageState();
}

class _ProfanityFilterListPageState extends State<ProfanityFilterListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profanity Filter List"),
      ),
      body: SafeArea(
        child: Container(),
      ),
    );
  }
}
