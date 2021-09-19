import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/domain/Contact.dart';
import 'package:mobile/pages/ContactsPage.dart';
import 'package:mobile/services/ChatService.dart';
import 'package:mobile/services/CommunicationService.dart';
import 'package:mobile/services/ContactService.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'ContactsPage_test.mocks.dart';

@GenerateMocks([CommunicationService, ContactService, ChatService])
void main() {
  final communicationService = MockCommunicationService();
  final contactService = MockContactService();
  final chatService = MockChatService();

  GetIt.I.registerSingleton<CommunicationService>(communicationService);
  GetIt.I.registerSingleton<ContactService>(contactService);
  GetIt.I.registerSingleton<ChatService>(chatService);

  setUp(() {
    when(contactService.fetchAll()).thenAnswer((_) => Future.value([
          Contact(
              phoneNumber: "0728954829",
              displayName: "Connor",
              status: "Living life",
              profileImage: ""),
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
              profileImage: ""),
        ]));
  });

  testWidgets("Page should contain correct base widgets",
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: ContactsPage(),
    ));

    expect(find.text("New contact"), findsOneWidget);
  });

  group("Tests that check all 5 contacts are rendered properly", () {
    testWidgets("Page should contain 5 contacts", (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: ContactsPage(),
      ));

      await tester.pump();

      expect(find.byType(Slidable), findsNWidgets(5));
    });

    testWidgets("Page should contain all 5 contacts names",
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: ContactsPage(),
      ));

      await tester.pump();

      expect(find.text("Connor"), findsOneWidget);
      expect(find.text("Kim"), findsOneWidget);
      expect(find.text("Joshua"), findsOneWidget);
      expect(find.text("Andrew"), findsOneWidget);
      expect(find.text("Kirsten"), findsOneWidget);
    });

    testWidgets("Page should contain all 5 contacts status'",
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: ContactsPage(),
      ));

      await tester.pump();

      expect(find.text("Living life"), findsOneWidget);
      expect(find.text("Sad"), findsOneWidget);
      expect(find.text("Happy"), findsOneWidget);
      expect(find.text("Vacationing"), findsOneWidget);
      expect(find.text("Proud mom"), findsOneWidget);
    });

    testWidgets("Page should contain 5 bubbles for ordering names'",
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: ContactsPage(),
      ));

      await tester.pumpAndSettle();

      expect(find.text("A"), findsOneWidget);
    });
  });
}
