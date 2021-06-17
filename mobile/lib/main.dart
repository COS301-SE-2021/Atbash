import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/pages/LoginPage.dart';
import 'package:mobile/services/DatabaseAccess.dart';
import 'package:mobile/services/UserService.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  GetIt.I.registerSingleton(DatabaseAccess());
  GetIt.I.registerSingleton(UserService());

  runApp(AtbashApp());
}

class AtbashApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Atbash",
      theme: ThemeData(primarySwatch: Colors.orange),
      home: LoginPage(),
    );
  }
}
