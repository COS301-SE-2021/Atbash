import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/domain/Chat.dart';
import 'package:mobile/domain/Message.dart';
import 'package:mobile/pages/AnalyticsPage.dart';
import 'package:mobile/services/ChatService.dart';
import 'package:mobile/services/ContactService.dart';
import 'package:mobile/services/MessageService.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mobile/domain/Contact.dart';

import 'AnalyticsPage_test.mocks.dart';

@GenerateMocks([ContactService, MessageService, ChatService])
void main() {
  final contactService = MockContactService();
  final messageService = MockMessageService();
  final chatService = MockChatService();

  GetIt.I.registerSingleton<ContactService>(contactService);
  GetIt.I.registerSingleton<MessageService>(messageService);
  GetIt.I.registerSingleton<ChatService>(chatService);

  setUpAll(() {
    when(chatService.fetchByChatType(any)).thenAnswer((_) => Future.value([
          Chat(
              id: "123",
              contactPhoneNumber: "0837772222",
              contact: Contact(
                  phoneNumber: "0837772222",
                  displayName: "John",
                  profileImage: "",
                  status: "Hi"),
              chatType: ChatType.general),
          Chat(
              id: "789",
              contactPhoneNumber: "0836006179",
              contact: Contact(
                  phoneNumber: "0836006179",
                  displayName: "Dylan",
                  profileImage: "",
                  status: "Yum"),
              chatType: ChatType.general)
        ]));

    when(messageService.fetchAllByChatId("123"))
        .thenAnswer((_) => Future.value([
              Message(
                  id: "12345",
                  chatId: "123",
                  isIncoming: false,
                  otherPartyPhoneNumber: "0836006179",
                  contents: "Hi, how are you?",
                  timestamp: DateTime.now()),
              Message(
                  id: "45643",
                  chatId: "123",
                  isIncoming: true,
                  otherPartyPhoneNumber: "0836006179",
                  contents: "I'm good. What are you doing?",
                  timestamp: DateTime.now(),
                  liked: true),
              Message(
                  id: "35287",
                  chatId: "123",
                  isIncoming: false,
                  otherPartyPhoneNumber: "0836006179",
                  contents: "what's up",
                  timestamp: DateTime.now()),
              Message(
                  id: "17264",
                  chatId: "123",
                  isIncoming: false,
                  otherPartyPhoneNumber: "0836006179",
                  contents: "",
                  timestamp: DateTime.now(),
                  isMedia: true,
                  liked: true),
              Message(
                  id: "04737",
                  chatId: "123",
                  isIncoming: false,
                  otherPartyPhoneNumber: "0836006179",
                  contents: "",
                  timestamp: DateTime.now(),
                  isMedia: true),
              Message(
                  id: "17265",
                  chatId: "123",
                  isIncoming: false,
                  otherPartyPhoneNumber: "0836006179",
                  contents: "",
                  timestamp: DateTime.now(),
                  isMedia: true,
                  liked: true)
            ]));

    when(messageService.fetchAllByChatId("789"))
        .thenAnswer((_) => Future.value([
              Message(
                  id: "54353",
                  chatId: "789",
                  isIncoming: false,
                  otherPartyPhoneNumber: "0837772222",
                  contents: "I am good and you?",
                  timestamp: DateTime.now(),
                  liked: true),
              Message(
                  id: "89775",
                  chatId: "789",
                  isIncoming: true,
                  otherPartyPhoneNumber: "0837772222",
                  contents: "TV and you?",
                  timestamp: DateTime.now(),
                  liked: true),
              Message(
                  id: "63527",
                  chatId: "789",
                  isIncoming: false,
                  otherPartyPhoneNumber: "0837772222",
                  contents: "jolly",
                  timestamp: DateTime.now(),
                  liked: true),
              Message(
                  id: "26354",
                  chatId: "789",
                  isIncoming: false,
                  otherPartyPhoneNumber: "0837772222",
                  contents: "",
                  timestamp: DateTime.now(),
                  isMedia: true),
              Message(
                  id: "26358",
                  chatId: "789",
                  isIncoming: true,
                  otherPartyPhoneNumber: "0837772222",
                  contents: "",
                  timestamp: DateTime.now(),
                  isMedia: true,
                  liked: true),
              Message(
                  id: "06985",
                  chatId: "789",
                  isIncoming: false,
                  otherPartyPhoneNumber: "0837772222",
                  contents: "",
                  timestamp: DateTime.now(),
                  isMedia: true)
            ]));
  });

  testWidgets("Total_text_messages_sent", (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: AnalyticsPage(),
    ));
    await tester.pump();
    final finder = find.byKey(Key("AnalyticsPage_totalMessagesSent"));
    final widget = tester.widget(finder) as Text;

    expect(widget.data, "4");
  });

  testWidgets("Total_text_messages_received", (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: AnalyticsPage(),
    ));
    await tester.pump();
    final finder = find.byKey(Key("AnalyticsPage_totalMessagesReceived"));
    final widget = tester.widget(finder) as Text;

    expect(widget.data, "2");
  });

  testWidgets("Total_photos_sent", (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: AnalyticsPage(),
    ));
    await tester.pump();
    final finder = find.byKey(Key("AnalyticsPage_totalPhotosSent"));
    final widget = tester.widget(finder) as Text;

    expect(widget.data, "5");
  });

  testWidgets("Total_photos_received", (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: AnalyticsPage(),
    ));
    await tester.pump();
    final finder = find.byKey(Key("AnalyticsPage_totalPhotosReceived"));
    final widget = tester.widget(finder) as Text;

    expect(widget.data, "1");
  });

  testWidgets("Total_liked_messages", (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: AnalyticsPage(),
    ));
    await tester.pump();
    final finder = find.byKey(Key("AnalyticsPage_totalLikedMessages"));
    final widget = tester.widget(finder) as Text;

    expect(widget.data, "7");
  });

  testWidgets("Total_messages_between_contacts", (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: AnalyticsPage(),
    ));
    await tester.pump();
    final finder =
        find.byKey(Key("AnalyticsPage_totalMessagesBetweenContacts_789"));
    final widget = tester.widget(finder) as Text;

    expect(widget.data, "Total messages: 6");
  });
}
