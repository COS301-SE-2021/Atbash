import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/LoginScreen.dart';
import 'package:mobile/model/SystemModel.dart';
import 'package:mobile/service/MessageService.dart';
import 'package:provider/provider.dart';

import 'domain/Contact.dart';

void main() {
  GetIt.I.registerSingleton(MessageService());

  runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (context) => SystemModel())],
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
      home: LoginScreen(),
    );
  }
}
