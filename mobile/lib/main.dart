import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          FirebaseMessaging.instance.getToken().then((value) => print(value));

          return MaterialApp(
            key: Key('K'),
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
