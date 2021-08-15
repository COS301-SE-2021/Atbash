import 'package:flutter/material.dart';
import 'package:mobile_ui/pages/ChatPage.dart';
import 'package:mobile_ui/pages/MainPage.dart';
import 'package:mobile_ui/pages/ProfileSetupPage.dart';
import 'package:mobile_ui/pages/RegistrationPage.dart';
import 'package:mobile_ui/pages/SettingsPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: SettingsPage(),
    );
  }
}
