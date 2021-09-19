import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/pages/HomePage.dart';
import 'package:mobile/services/ChatService.dart';
import 'package:mobile/services/CommunicationService.dart';
import 'package:mobile/services/ContactService.dart';
import 'package:mobile/services/MessageService.dart';
import 'package:mobile/services/SettingsService.dart';
import 'package:mobile/services/UserService.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'HomePage_test.mocks.dart';

@GenerateMocks([
  UserService,
  ChatService,
  ContactService,
  MessageService,
  CommunicationService,
  SettingsService
])
void main() {
  final userService = MockUserService();
  final chatService = MockChatService();
  final contactService = MockContactService();
  final messageService = MockMessageService();
  final communicationService = MockCommunicationService();
  final settingsService = MockSettingsService();

  GetIt.I.registerSingleton<UserService>(userService);
  GetIt.I.registerSingleton<ChatService>(chatService);
  GetIt.I.registerSingleton<ContactService>(contactService);
  GetIt.I.registerSingleton<MessageService>(messageService);
  GetIt.I.registerSingleton<CommunicationService>(communicationService);
  GetIt.I.registerSingleton<SettingsService>(settingsService);

  setUp(() {
    when(communicationService.goOnline()).thenAnswer((realInvocation) => Future.value());
  });

  testWidgets("Page should contain correct base widgets",
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: HomePage(),
    ));

    expect(find.text("New contact"), findsOneWidget);
    expect(find.byKey(Key('searchButton')), findsOneWidget);
  });
}
