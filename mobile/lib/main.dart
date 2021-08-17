import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/models/UserModel.dart';
import 'package:mobile/pages/MainPage.dart';
import 'package:mobile/pages/RegistrationPage.dart';
import 'package:mobile/services/AppService.dart';
import 'package:mobile/services/DatabaseService.dart';
import 'package:mobile/services/EncryptionService.dart';
import 'package:mobile/services/KeyGenService.dart';
import 'package:mobile/services/NotificationService.dart';
import 'package:mobile/services/UserService.dart';

import 'models/ChatModel.dart';
import 'models/ContactsModel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final navigatorKey = GlobalKey<NavigatorState>();

  final databaseService = DatabaseService();
  final keyGenService = KeyGenService();
  final encryptionService = EncryptionService();

  final userModel = UserModel();
  final contactsModel = ContactsModel(databaseService, keyGenService);
  final chatModel = ChatModel(databaseService);

  final userService = UserService(keyGenService);
  final notificationService =
      NotificationService(databaseService, navigatorKey);
  final appService = AppService(
    userService,
    databaseService,
    encryptionService,
    notificationService,
    contactsModel,
    chatModel,
  );

  GetIt.I.registerSingleton(databaseService);
  GetIt.I.registerSingleton(keyGenService);
  GetIt.I.registerSingleton(encryptionService);
  GetIt.I.registerSingleton(userService);
  GetIt.I.registerSingleton(appService);
  GetIt.I.registerSingleton(notificationService);
  GetIt.I.registerSingleton(userModel);
  GetIt.I.registerSingleton(contactsModel);
  GetIt.I.registerSingleton(chatModel);

  await Future.wait([notificationService.init(), contactsModel.initialise()]);

  runApp(AtbashApp(navigatorKey));
}

class AtbashApp extends StatelessWidget {
  final _firebaseInitialization = Firebase.initializeApp();
  final _registered = GetIt.I.get<UserService>().isRegistered();

  final GlobalKey<NavigatorState> _navigatorKey;

  AtbashApp(this._navigatorKey);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([_firebaseInitialization, _registered]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (!(snapshot.data is List)) {
            throw StateError(
                "Failed to build. FutureBuilder did not return list");
          }

          if ((snapshot.data as List)[1] == true) {
            // if registered
            return MaterialApp(
              title: "Atbash",
              theme: ThemeData(primarySwatch: Colors.orange),
              navigatorKey: _navigatorKey,
              home: MainPage(),
            );
          } else {
            // if not registered
            return MaterialApp(
              title: "Atbash",
              theme: ThemeData(primarySwatch: Colors.orange),
              navigatorKey: _navigatorKey,
              home: RegistrationPage(),
            );
          }
        }

        return Container();
      },
    );
  }
}
