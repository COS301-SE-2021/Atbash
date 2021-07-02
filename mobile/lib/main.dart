import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/pages/LoginPage.dart';
import 'package:mobile/services/AppService.dart';
import 'package:mobile/services/ContactsService.dart';
import 'package:mobile/services/DatabaseService.dart';
import 'package:mobile/services/NotificationService.dart';
import 'package:mobile/services/UserService.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final databaseService = DatabaseService();
  final contactsService = ContactsService(databaseService);
  final userService = UserService();
  final notificationService = NotificationService();
  final appService = AppService(
    userService,
    databaseService,
    notificationService,
  );

  GetIt.I.registerSingleton(databaseService);
  GetIt.I.registerSingleton(contactsService);
  GetIt.I.registerSingleton(userService);
  GetIt.I.registerSingleton(appService);
  GetIt.I.registerSingleton(notificationService);

  final permissionGranted = await notificationService.init();
  print("Notifications permitted: $permissionGranted");

  runApp(AtbashApp());
}

class AtbashApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          FirebaseMessaging.instance.getToken().then((value) => print(value));

          return MaterialApp(
            title: "Atbash",
            theme: ThemeData(primarySwatch: Colors.orange),
            home: LoginPage(),
          );
        }

        return Container();
      },
    );
  }
}
