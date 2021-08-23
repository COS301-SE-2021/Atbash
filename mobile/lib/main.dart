import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/models/ChatListModel.dart';
import 'package:mobile/models/ContactListModel.dart';
import 'package:mobile/models/MessagesModel.dart';
import 'package:mobile/models/SettingsModel.dart';
import 'package:mobile/pages/RegistrationPage.dart';

import 'models/UserModel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final navigatorKey = GlobalKey<NavigatorState>();

  final userModel = UserModel();
  final settingsModel = SettingsModel();
  final chatListModel = ChatListModel();
  final contactListModel = ContactListModel();
  final messagesModel = MessagesModel();

  GetIt.I.registerSingleton(userModel);
  GetIt.I.registerSingleton(settingsModel);
  GetIt.I.registerSingleton(chatListModel);
  GetIt.I.registerSingleton(contactListModel);
  GetIt.I.registerSingleton(messagesModel);

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
