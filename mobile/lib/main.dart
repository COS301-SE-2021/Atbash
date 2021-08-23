import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/pages/RegistrationPage.dart';

import 'models/UserModel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final navigatorKey = GlobalKey<NavigatorState>();

  final userModel = UserModel();

  GetIt.I.registerSingleton(userModel);

  runApp(AtbashApp(navigatorKey));
}

class AtbashApp extends StatelessWidget {
  final GlobalKey<NavigatorState> _navigatorKey;

  AtbashApp(this._navigatorKey);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Atbash",
      theme: ThemeData(primarySwatch: Colors.orange),
      navigatorKey: _navigatorKey,
      home: RegistrationPage(),
    );
  }
}
