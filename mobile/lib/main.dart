import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/encryption/services/IdentityKeyStoreService.dart';
import 'package:mobile/encryption/services/PreKeyStoreService.dart';
import 'package:mobile/encryption/services/SessionStoreService.dart';
import 'package:mobile/encryption/services/SignalProtocolStoreService.dart';
import 'package:mobile/encryption/services/SignedPreKeyStoreService.dart';
import 'package:mobile/models/ChatListModel.dart';
import 'package:mobile/models/ContactListModel.dart';
import 'package:mobile/models/MessagesModel.dart';
import 'package:mobile/models/SettingsModel.dart';
import 'package:mobile/pages/HomePage.dart';
import 'package:mobile/pages/RegistrationPage.dart';
import 'package:mobile/services/ChatService.dart';
import 'package:mobile/services/ContactService.dart';
import 'package:mobile/services/DatabaseService.dart';
import 'package:mobile/services/EncryptionService.dart';
import 'package:mobile/services/MessageService.dart';
import 'package:mobile/services/RegistrationService.dart';

import 'models/UserModel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final navigatorKey = GlobalKey<NavigatorState>();

  _registerServices();

  runApp(AtbashApp(navigatorKey));
}

class AtbashApp extends StatelessWidget {
  final RegistrationService registrationService = GetIt.I.get();

  final GlobalKey<NavigatorState> _navigatorKey;

  AtbashApp(this._navigatorKey);

  @override
  Widget build(BuildContext context) {
    final registered = registrationService.isRegistered();

    return FutureBuilder(
      future: registered,
      builder: (context, snapshot) {
        Widget page = Container();

        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data == true) {
            page = HomePage();
          } else {
            page = RegistrationPage();
          }
        }

        return MaterialApp(
          title: "Atbash",
          theme: ThemeData(primarySwatch: Colors.orange),
          navigatorKey: _navigatorKey,
          home: page,
        );
      },
    );
  }
}

void _registerServices() async {
  final databaseService = DatabaseService();
  final encryptionService = _initialiseEncryptionService(databaseService);
  final registrationService = RegistrationService(encryptionService);

  final chatService = ChatService(databaseService);
  final contactService = ContactService(databaseService);
  final messageService = MessageService(databaseService);

  GetIt.I.registerSingleton(databaseService);
  GetIt.I.registerSingleton(encryptionService);
  GetIt.I.registerSingleton(registrationService);

  GetIt.I.registerSingleton(chatService);
  GetIt.I.registerSingleton(contactService);
  GetIt.I.registerSingleton(messageService);

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

  await settingsModel.init();
}

EncryptionService _initialiseEncryptionService(
    DatabaseService databaseService) {
  final identityKeyStoreService = IdentityKeyStoreService(databaseService);
  final preKeyStoreService = PreKeyStoreService(databaseService);
  final sessionStoreService = SessionStoreService(databaseService);
  final signedPreKeyStoreService = SignedPreKeyStoreService(databaseService);
  final signalProtocolStoreService = SignalProtocolStoreService(
    preKeyStoreService,
    sessionStoreService,
    signedPreKeyStoreService,
    identityKeyStoreService,
  );
  return EncryptionService(
    signalProtocolStoreService,
    identityKeyStoreService,
    signedPreKeyStoreService,
    preKeyStoreService,
    sessionStoreService,
  );
}
