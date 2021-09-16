import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/encryption/services/IdentityKeyStoreService.dart';
import 'package:mobile/encryption/services/PreKeyStoreService.dart';
import 'package:mobile/encryption/services/SessionStoreService.dart';
import 'package:mobile/encryption/services/SignalProtocolStoreService.dart';
import 'package:mobile/encryption/services/SignedPreKeyStoreService.dart';
import 'package:mobile/pages/HomePage.dart';
import 'package:mobile/pages/RegistrationPage.dart';
import 'package:mobile/pages/VerificationPage.dart';
import 'package:mobile/services/BlockedNumbersService.dart';
import 'package:mobile/services/ChatCacheService.dart';
import 'package:mobile/services/ChatService.dart';
import 'package:mobile/services/CommunicationService.dart';
import 'package:mobile/services/ContactService.dart';
import 'package:mobile/services/DatabaseService.dart';
import 'package:mobile/services/EncryptionService.dart';
import 'package:mobile/services/MediaService.dart';
import 'package:mobile/services/MemoryStoreService.dart';
import 'package:mobile/services/MessageService.dart';
import 'package:mobile/services/NotificationService.dart';
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
  final NotificationService notificationService = GetIt.I.get();
  final ContactService contactService = GetIt.I.get();

  final GlobalKey<NavigatorState> _navigatorKey;

  AtbashApp(this._navigatorKey);

  @override
  Widget build(BuildContext context) {
    final registrationState = _registrationState();

    return FutureBuilder(
      future: registrationState,
      builder: (context, snapshot) {
        Widget page = Container();

        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data == RegistrationState.registered) {
            page = HomePage();
          } else if (snapshot.data == RegistrationState.unverified) {
            page = VerificationPage();
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

  Future<RegistrationState> _registrationState() async {
    final verified =
        await FlutterSecureStorage().read(key: "verification_flag") != null;

    if (verified) {
      return RegistrationState.registered;
    } else {
      final registered = await registrationService.isRegistered();
      return registered
          ? RegistrationState.unverified
          : RegistrationState.unregistered;
    }
  }
}

enum RegistrationState { unregistered, unverified, registered }

void _registerServices() async {
  final navigationObserver = NavigationObserver();
  GetIt.I.registerSingleton(navigationObserver);

  final userService = UserService();

  final databaseService = DatabaseService();
  final encryptionService =
      _initialiseEncryptionService(databaseService, userService);

  final registrationService =
      RegistrationService(encryptionService, userService);

  GetIt.I.registerSingleton(registrationService);

  final chatService = ChatService(databaseService);
  final contactService = ContactService(databaseService);
  final messageService = MessageService(databaseService);
  final blockedNumbersService = BlockedNumbersService(databaseService);
  final settingsService = SettingsService();
  final chatCacheService = ChatCacheService();
  final mediaEncryptionService = MediaService();
  final memoryStoreService = MemoryStoreService();
  final notificationService = NotificationService();
  final communicationService = CommunicationService(
    blockedNumbersService,
    encryptionService,
    userService,
    chatService,
    contactService,
    messageService,
    settingsService,
    mediaEncryptionService,
    memoryStoreService,
    notificationService,
  );

  GetIt.I.registerSingleton(chatService);
  GetIt.I.registerSingleton(contactService);
  GetIt.I.registerSingleton(messageService);
  GetIt.I.registerSingleton(blockedNumbersService);
  GetIt.I.registerSingleton(userService);
  GetIt.I.registerSingleton(settingsService);
  GetIt.I.registerSingleton(chatCacheService);
  GetIt.I.registerSingleton(mediaEncryptionService);
  GetIt.I.registerSingleton(memoryStoreService);
  GetIt.I.registerSingleton(notificationService);

  GetIt.I.registerSingleton(communicationService);

  await notificationService.init();
}

EncryptionService _initialiseEncryptionService(
    DatabaseService databaseService, UserService userService) {
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
    userService,
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
