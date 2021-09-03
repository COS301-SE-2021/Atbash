import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/encryption/services/IdentityKeyStoreService.dart';
import 'package:mobile/encryption/services/PreKeyStoreService.dart';
import 'package:mobile/encryption/services/SessionStoreService.dart';
import 'package:mobile/encryption/services/SignalProtocolStoreService.dart';
import 'package:mobile/encryption/services/SignedPreKeyStoreService.dart';
import 'package:mobile/pages/HomePage.dart';
import 'package:mobile/pages/RegistrationPage.dart';
import 'package:mobile/services/ChatCacheService.dart';
import 'package:mobile/services/ChatService.dart';
import 'package:mobile/services/CommunicationService.dart';
import 'package:mobile/services/ContactService.dart';
import 'package:mobile/services/DatabaseService.dart';
import 'package:mobile/services/EncryptionService.dart';
import 'package:mobile/services/MediaService.dart';
import 'package:mobile/services/MessageService.dart';
import 'package:mobile/services/RegistrationService.dart';
import 'package:mobile/services/SettingsService.dart';
import 'package:mobile/services/UserService.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final navigatorKey = GlobalKey<NavigatorState>();

  _registerServices();

  runApp(AtbashApp(navigatorKey));
}

class AtbashApp extends StatelessWidget {
  final RegistrationService registrationService = GetIt.I.get();
  final NavigationObserver navigationObserver = GetIt.I.get();

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
          navigatorObservers: [navigationObserver],
          theme: ThemeData(primarySwatch: Colors.orange),
          navigatorKey: _navigatorKey,
          home: page,
        );
      },
    );
  }
}

void _registerServices() async {
  final navigationObserver = NavigationObserver();
  GetIt.I.registerSingleton(navigationObserver);

  final databaseService = DatabaseService();
  final encryptionService = _initialiseEncryptionService(databaseService);

  final registrationService = RegistrationService(encryptionService);

  GetIt.I.registerSingleton(registrationService);

  final chatService = ChatService(databaseService);
  final contactService = ContactService(databaseService);
  final messageService = MessageService(databaseService);
  final userService = UserService();
  final settingsService = SettingsService();
  final chatCacheService = ChatCacheService();
  final mediaEncryptionService = MediaService();
  final communicationService = CommunicationService(
    encryptionService,
    userService,
    chatService,
    contactService,
    messageService,
    settingsService,
    mediaEncryptionService,
  );

  GetIt.I.registerSingleton(chatService);
  GetIt.I.registerSingleton(contactService);
  GetIt.I.registerSingleton(messageService);
  GetIt.I.registerSingleton(userService);
  GetIt.I.registerSingleton(settingsService);
  GetIt.I.registerSingleton(chatCacheService);
  GetIt.I.registerSingleton(mediaEncryptionService);

  GetIt.I.registerSingleton(communicationService);
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

class NavigationObserver extends NavigatorObserver {
  List<void Function()> _onRoutePopListeners = [];

  void onRoutePop(void Function() cb) => _onRoutePopListeners.add(cb);

  void disposeOnRoutePop(void Function() cb) => _onRoutePopListeners.remove(cb);

  @override
  void didPop(Route route, Route? previousRoute) {
    _onRoutePopListeners.forEach((listener) => listener());
  }
}
