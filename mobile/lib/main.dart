import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final navigatorKey = GlobalKey<NavigatorState>();

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
      home: MainPage(),
    );
  }
}
