import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/domain/Contact.dart';
import 'package:mobile/pages/ContactEditPage.dart';
import 'package:mobile/services/ContactService.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'ContactEditPage_test.mocks.dart';

@GenerateMocks([ContactService])
void main() {
  final contactService = MockContactService();
  GetIt.I.registerSingleton<ContactService>(contactService);

  setUpAll(() {
    when(contactService.fetchByPhoneNumber(any)).thenAnswer(
      (realInvocation) => Future.value(
        Contact(
          phoneNumber: "0721985674",
          displayName: "Joshua",
          status: "Hello",
          profileImage: "",
        ),
      ),
    );
  });

  testWidgets(
      "ContactEditPage has a TextField, an ElevatedButton & a TextButton",
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: ContactEditPage(
        phoneNumber: "0721985674",
      ),
    ));

    final textFieldFinder = find.byType(TextField);
    final elevatedButtonFinder = find.byType(ElevatedButton);
    final textButtonFinder = find.byType(TextButton);

    expect(textFieldFinder, findsOneWidget);
    expect(elevatedButtonFinder, findsOneWidget);
    expect(textButtonFinder, findsOneWidget);
  });

  testWidgets("Verify that the initial text is the contacts name",
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ContactEditPage(
          phoneNumber: "0721985674",
        ),
      ),
    );

    expect(find.widgetWithText(TextField, "Joshua"), findsOneWidget);
  });

  testWidgets("Verify that if birthday is not set 'Select Birthday' shows",
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ContactEditPage(
          phoneNumber: "0721985674",
        ),
      ),
    );

    expect(find.widgetWithText(TextButton, "Select Birthday"), findsOneWidget);
  });

  testWidgets("Verify that if birthday is set the birthday shows",
      (WidgetTester tester) async {
    when(contactService.fetchByPhoneNumber(any)).thenAnswer(
      (realInvocation) => Future.value(
        Contact(
          phoneNumber: "0721985674",
          displayName: "Joshua",
          status: "Hello",
          profileImage: "",
          birthday: DateTime(2000, 9, 11),
        ),
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: ContactEditPage(
          phoneNumber: "0721985674",
        ),
      ),
    );

    await tester.pump();

    expect(find.widgetWithText(TextButton, "Sep 11, 2000"), findsOneWidget);
  });
}
