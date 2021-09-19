import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/domain/Contact.dart';
import 'package:mobile/pages/ContactsPage.dart';
import 'package:mobile/services/ChatService.dart';
import 'package:mobile/services/CommunicationService.dart';
import 'package:mobile/services/ContactService.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'ContactsPage_test.mocks.dart';

@GenerateMocks([CommunicationService, ContactService, ChatService, http.Client])
void main() {
  final communicationService = MockCommunicationService();
  final contactService = MockContactService();
  final chatService = MockChatService();
  final mockClient = MockClient();

  GetIt.I.registerSingleton<CommunicationService>(communicationService);
  GetIt.I.registerSingleton<ContactService>(contactService);
  GetIt.I.registerSingleton<ChatService>(chatService);
  GetIt.I.registerSingleton<http.Client>(mockClient);

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
    expect(find.byKey(Key('searchButton')), findsOneWidget);
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

    testWidgets("Page should contain bubbles for ordering names'",
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: ContactsPage(),
      ));

      await tester.pump();

      expect(find.text("C"), findsOneWidget);
      expect(find.text("K"), findsWidgets);
    });
  });

  group("Functionality testing for ContactsPage", () {

    testWidgets("Clicking the search icon hides 'Add Contact' text",
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: ContactsPage(),
      ));

      await tester.pump();

      final searchButton = find.byKey(Key("searchButton"));
      expect(searchButton, findsOneWidget);

      await tester.tap(searchButton);
      await tester.pump();

      expect(searchButton, findsNothing);
      expect(find.byKey(Key("searchField")), findsOneWidget);
    });

    testWidgets("Clicking the search icon hides 'Add Contact' text",
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: ContactsPage(),
      ));

      await tester.pump();

      final searchButton = find.byKey(Key("searchButton"));
      expect(searchButton, findsOneWidget);

      await tester.tap(searchButton);
      await tester.pump();

      expect(searchButton, findsNothing);
      expect(find.byKey(Key("searchField")), findsOneWidget);
    });

    testWidgets("Searching for 'Con' hides all contacts but Connor",
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: ContactsPage(),
      ));

      await tester.pump();

      final searchButton = find.byKey(Key("searchButton"));
      expect(searchButton, findsOneWidget);

      await tester.tap(searchButton);
      await tester.pump();

      final searchTextInput = find.byKey(Key("searchField"));

      await tester.enterText(searchTextInput, "Con");
      await tester.pump();

      expect(find.text("Connor"), findsOneWidget);
      expect(find.text("Kim"), findsNothing);
      expect(find.text("Joshua"), findsNothing);
      expect(find.text("Andrew"), findsNothing);
      expect(find.text("Kirsten"), findsNothing);
    });

    testWidgets("Searching for '072897' hides all contacts but Kim",
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: ContactsPage(),
      ));

      await tester.pump();

      final searchButton = find.byKey(Key("searchButton"));
      expect(searchButton, findsOneWidget);

      await tester.tap(searchButton);
      await tester.pump();

      final searchTextInput = find.byKey(Key("searchField"));

      await tester.enterText(searchTextInput, "072897");
      await tester.pump();

      expect(find.text("Connor"), findsNothing);
      expect(find.text("Kim"), findsOneWidget);
      expect(find.text("Joshua"), findsNothing);
      expect(find.text("Andrew"), findsNothing);
      expect(find.text("Kirsten"), findsNothing);
    });

    testWidgets("Clicking the New Contact button opens up a dialog",
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: ContactsPage(),
      ));

      await tester.pump();

      final newContactButton = find.byKey(Key("newContactButton"));
      expect(newContactButton, findsOneWidget);

      await tester.tap(newContactButton);
      await tester.pump();

      final newContactDialog = find.byType(AlertDialog);

      expect(newContactDialog, findsOneWidget);
    });

    testWidgets(
        "Trying to add a contact without a name or number shows 'Both name and number are required' snackbar",
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: ContactsPage(),
      ));

      await tester.pump();

      final newContactButton = find.byKey(Key("newContactButton"));
      expect(newContactButton, findsOneWidget);

      await tester.tap(newContactButton);
      await tester.pump();

      final newContactDialog = find.byType(AlertDialog);
      expect(newContactDialog, findsOneWidget);

      final nameField = find.byKey(Key("NewContactDialog_nameField"));
      final numberField = find.byKey(Key("NewContactDialog_phoneField"));
      expect(nameField, findsOneWidget);
      expect(numberField, findsOneWidget);

      await tester.pump();

      final addButton = find.byKey(Key("NewContactDialog_AddButton"));
      expect(addButton, findsOneWidget);

      await tester.tap(addButton);
      await tester.pump();

      expect(find.widgetWithText(SnackBar, "Both name and number are required"),
          findsOneWidget);
    });

    testWidgets(
        "Trying to add a contact that doesn't exist on the server shows 'No user with phone number 0728954829 exists' snackbar",
        (WidgetTester tester) async {
      when(mockClient.get(any))
          .thenAnswer((_) => Future.value(http.Response("", 404)));

      await tester.pumpWidget(MaterialApp(
        home: ContactsPage(),
      ));

      await tester.pump();

      final newContactButton = find.byKey(Key("newContactButton"));
      expect(newContactButton, findsOneWidget);

      await tester.tap(newContactButton);
      await tester.pump();

      final newContactDialog = find.byType(AlertDialog);
      expect(newContactDialog, findsOneWidget);

      final nameField = find.byKey(Key("NewContactDialog_nameField"));
      final numberField = find.byKey(Key("NewContactDialog_phoneField"));
      expect(nameField, findsOneWidget);
      expect(numberField, findsOneWidget);

      await tester.enterText(nameField, "Connor");
      await tester.enterText(numberField, "0728954829");

      await tester.pump();

      final addButton = find.byKey(Key("NewContactDialog_AddButton"));
      expect(addButton, findsOneWidget);

      await tester.tap(addButton);
      await tester.pump();

      expect(
          find.widgetWithText(
              SnackBar, "No user with phone number +27728954829 exists"),
          findsOneWidget);
    });

    testWidgets(
        "Trying to add a contact that already exists shows 'A contact already exists with the number ...' snackbar",
        (WidgetTester tester) async {
      when(mockClient.get(any))
          .thenAnswer((_) => Future.value(http.Response("", 204)));
      when(contactService.insert(any))
          .thenThrow(DuplicateContactPhoneNumberException());

      await tester.pumpWidget(MaterialApp(
        home: ContactsPage(),
      ));

      await tester.pump();

      final newContactButton = find.byKey(Key("newContactButton"));
      expect(newContactButton, findsOneWidget);

      await tester.tap(newContactButton);
      await tester.pump();

      final newContactDialog = find.byType(AlertDialog);
      expect(newContactDialog, findsOneWidget);

      final nameField = find.byKey(Key("NewContactDialog_nameField"));
      final numberField = find.byKey(Key("NewContactDialog_phoneField"));
      expect(nameField, findsOneWidget);
      expect(numberField, findsOneWidget);

      await tester.enterText(nameField, "Connor");
      await tester.enterText(numberField, "0728954829");

      await tester.pump();

      final addButton = find.byKey(Key("NewContactDialog_AddButton"));
      expect(addButton, findsOneWidget);

      await tester.tap(addButton);
      await tester.pumpAndSettle();

      expect(
          find.widgetWithText(SnackBar,
              "A contact already exists with the number +27728954829"),
          findsOneWidget);
    });

    testWidgets("Adding a contact successfully adds the list item",
        (WidgetTester tester) async {
      when(mockClient.get(any))
          .thenAnswer((_) => Future.value(http.Response("", 204)));
      when(contactService.insert(any)).thenAnswer((realInvocation) =>
          Future.value(Contact(
              phoneNumber: "", displayName: "", status: "", profileImage: "")));
      when(communicationService.sendRequestStatus(any))
          .thenAnswer((realInvocation) => Future.value());
      when(communicationService.sendRequestProfileImage(any))
          .thenAnswer((realInvocation) => Future.value());
      when(communicationService.sendRequestBirthday(any))
          .thenAnswer((realInvocation) => Future.value());

      await tester.pumpWidget(MaterialApp(
        home: ContactsPage(),
      ));

      await tester.pump();

      final newContactButton = find.byKey(Key("newContactButton"));
      expect(newContactButton, findsOneWidget);

      await tester.tap(newContactButton);
      await tester.pump();

      final newContactDialog = find.byType(AlertDialog);
      expect(newContactDialog, findsOneWidget);

      final nameField = find.byKey(Key("NewContactDialog_nameField"));
      final numberField = find.byKey(Key("NewContactDialog_phoneField"));
      expect(nameField, findsOneWidget);
      expect(numberField, findsOneWidget);

      await tester.enterText(nameField, "Adam");
      await tester.enterText(numberField, "07245341231828");

      await tester.pump();

      final addButton = find.byKey(Key("NewContactDialog_AddButton"));
      expect(addButton, findsOneWidget);

      await tester.tap(addButton);
      await tester.pump();

      expect(find.byKey(Key("inkWellAdam")), findsOneWidget);
    });

    testWidgets("Deleting a contact (Connor) removes them from the page",
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: ContactsPage(),
      ));

      await tester.pump();

      final contactCard = find.byKey(Key("inkWellConnor"));
      expect(contactCard, findsOneWidget);

      await tester.drag(contactCard, Offset(-500, 0));
      await tester.pumpAndSettle();

      final deleteContact = find.byKey(Key("deleteConnor"));
      expect(deleteContact, findsOneWidget);
      await tester.tap(deleteContact);
      await tester.pump();

      expect(contactCard, findsNothing);
    });

    //TODO test navigation
  });
}
