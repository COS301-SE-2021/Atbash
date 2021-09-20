import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/main.dart';
import 'package:mobile/pages/HomePage.dart';
import 'package:mobile/services/ChatService.dart';
import 'package:mobile/services/CommunicationService.dart';
import 'package:mobile/services/ContactService.dart';
import 'package:mobile/services/MessageService.dart';
import 'package:mobile/services/NotificationService.dart';
import 'package:mobile/services/SettingsService.dart';
import 'package:mobile/services/UserService.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'HomePage_test.mocks.dart';

@GenerateMocks([
  NavigationObserver,
  UserService,
  ChatService,
  ContactService,
  MessageService,
  CommunicationService,
  SettingsService,
  NotificationService
])
void main() {
  final navigationObserver = MockNavigationObserver();
  final userService = MockUserService();
  final chatService = MockChatService();
  final contactService = MockContactService();
  final messageService = MockMessageService();
  final communicationService = MockCommunicationService();
  final settingsService = MockSettingsService();
  final notificationService = MockNotificationService();

  GetIt.I.registerSingleton<NavigationObserver>(navigationObserver);
  GetIt.I.registerSingleton<UserService>(userService);
  GetIt.I.registerSingleton<ChatService>(chatService);
  GetIt.I.registerSingleton<ContactService>(contactService);
  GetIt.I.registerSingleton<MessageService>(messageService);
  GetIt.I.registerSingleton<CommunicationService>(communicationService);
  GetIt.I.registerSingleton<SettingsService>(settingsService);
  GetIt.I.registerSingleton<NotificationService>(notificationService);

  setUp(() {
    when(userService.getDisplayName())
        .thenAnswer((realInvocation) => Future.value("Connor"));
    when(userService.getStatus())
        .thenAnswer((realInvocation) => Future.value("Happy"));
    when(userService.getProfileImage())
        .thenAnswer((realInvocation) => Future.value(null));
    when(chatService.fetchByChatType(any))
        .thenAnswer((realInvocation) => Future.value([]));
    when(settingsService.getSafeMode())
        .thenAnswer((realInvocation) => Future.value(false));
  });

  testWidgets("Page should contain correct base widgets",
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: HomePage(),
    ));

    expect(find.byKey(Key('searchButton')), findsOneWidget);
    expect(find.byKey(Key('settingsButton')), findsOneWidget);
  });
}
