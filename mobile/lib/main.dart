import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/MainScreen.dart';

import 'ChatScreen.dart';
import 'domain/Contact.dart';

void main() {
  runApp(AtbashApp());
}

class AtbashApp extends StatefulWidget {
  @override
  _AtbashAppState createState() => _AtbashAppState();
}

class _AtbashAppState extends State<AtbashApp> {
  Contact? selectedContact;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Atbash',
      theme: ThemeData(primarySwatch: Colors.green),
      home: Navigator(
        pages: [
          MaterialPage(child: ChatScreen()),
        ],
        onPopPage: (route, result) => route.didPop(result),
      ),
    );
  }
}
