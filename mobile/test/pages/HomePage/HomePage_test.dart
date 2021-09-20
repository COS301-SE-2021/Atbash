import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/domain/Chat.dart';
import 'package:mobile/domain/Contact.dart';
import 'package:mobile/domain/Message.dart';
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
    final contacts = [
      Contact(
          phoneNumber: "0728977004",
          displayName: "Kim",
          status: "Sad",
          profileImage: ""),
      Contact(
          phoneNumber: "0729871093",
          displayName: "Joshua",
          status: "Happy",
          profileImage: ""),
      Contact(
          phoneNumber: "0765498345",
          displayName: "Andrew",
          status: "Vacationing",
          profileImage: ""),
      Contact(
          phoneNumber: "0823489087",
          displayName: "Kirsten",
          status: "Proud mom",
          profileImage: "")
    ];

    when(userService.getDisplayName())
        .thenAnswer((realInvocation) => Future.value("Connor"));
    when(userService.getStatus())
        .thenAnswer((realInvocation) => Future.value("Happy"));
    when(userService.getProfileImage())
        .thenAnswer((realInvocation) => Future.value(null));
    when(chatService.fetchByChatType(any))
        .thenAnswer((realInvocation) => Future.value([
              Chat(
                  id: "0",
                  contactPhoneNumber: "0728977004",
                  chatType: ChatType.general,
                  contact: contacts[0],
                  mostRecentMessage: Message(
                      id: "0",
                      chatId: "0",
                      isIncoming: false,
                      otherPartyPhoneNumber: "0728977004",
                      contents: "Hello",
                      timestamp: DateTime.now())),
              Chat(
                  id: "1",
                  contactPhoneNumber: "0729871093",
                  chatType: ChatType.general,
                  contact: contacts[1],
                  mostRecentMessage: Message(
                      id: "1",
                      chatId: "1",
                      isIncoming: false,
                      otherPartyPhoneNumber: "0729871093",
                      contents: "Goodbye",
                      timestamp: DateTime.now())),
              Chat(
                  id: "2",
                  contactPhoneNumber: "0765498345",
                  chatType: ChatType.general,
                  contact: contacts[2],
                  mostRecentMessage: Message(
                      id: "2",
                      chatId: "2",
                      isIncoming: false,
                      otherPartyPhoneNumber: "0765498345",
                      contents: "damn",
                      timestamp: DateTime.now())),
              Chat(
                  id: "3",
                  contactPhoneNumber: "0823489087",
                  chatType: ChatType.general,
                  contact: contacts[3],
                  mostRecentMessage: Message(
                      id: "3",
                      chatId: "3",
                      isIncoming: false,
                      otherPartyPhoneNumber: "0823489087",
                      contents: "Sticker",
                      timestamp: DateTime.now())),
              Chat(
                  id: "4",
                  contactPhoneNumber: "0986547832",
                  chatType: ChatType.general,
                  mostRecentMessage: Message(
                      id: "4",
                      chatId: "4",
                      isIncoming: false,
                      otherPartyPhoneNumber: "0986547832",
                      contents: "Insurance",
                      timestamp: DateTime.now()))
            ]));
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

  testWidgets(
      "Page should contain all contacts names plus number of chat without contact",
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: HomePage(),
    ));

    await tester.pump();

    expect(find.text("Kim"), findsOneWidget);
    expect(find.text("Joshua"), findsOneWidget);
    expect(find.text("Andrew"), findsOneWidget);
    expect(find.text("Kirsten"), findsOneWidget);
    expect(find.text("0986547832"), findsOneWidget);
  });

  testWidgets("Page should contain all preview messages from chats",
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: HomePage(),
    ));

    await tester.pump();

    expect(find.text("Hello"), findsOneWidget);
    expect(find.text("Goodbye"), findsOneWidget);
    expect(find.text("damn"), findsOneWidget);
    expect(find.text("Sticker"), findsOneWidget);
    expect(find.text("Insurance"), findsOneWidget);
  });

  testWidgets("When profanity filter is on, text 'damn' should be '****'",
      (WidgetTester tester) async {
    when(settingsService.getSafeMode())
        .thenAnswer((realInvocation) => Future.value(true));
    await tester.pumpWidget(MaterialApp(
      home: HomePage(),
    ));

    await tester.pump();

    expect(find.text("damn"), findsNothing);
    expect(find.text("****"), findsOneWidget);
  });

  testWidgets("When you delete a chat, it should no longer appear on screen",
      (WidgetTester tester) async {
    when(settingsService.getSafeMode())
        .thenAnswer((realInvocation) => Future.value(true));
    await tester.pumpWidget(MaterialApp(
      home: HomePage(),
    ));

    await tester.pump();

    final chatCard = find.byKey(Key("chatCard0728977004"));
    expect(chatCard, findsOneWidget);
    await tester.drag(chatCard, Offset(-500,0));
    await tester.pump();

    final deleteButton = find.byKey(Key("deleteButton0728977004"));
    expect(deleteButton, findsOneWidget);
    await tester.tap(deleteButton);
    await tester.pump();

    expect(chatCard, findsNothing);
  });
}
