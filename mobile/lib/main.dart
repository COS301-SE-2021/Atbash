import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/LoginScreen.dart';
import 'package:mobile/model/UserModel.dart';
import 'package:provider/provider.dart';

import 'domain/Contact.dart';

void main() {
  runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (context) => UserModel())],
    child: AtbashApp(),
  ));
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
      home: ChangeNotifierProvider(
        create: (context) => UserModel(),
        child: LoginScreen(),
      ),
    );
  }
}
