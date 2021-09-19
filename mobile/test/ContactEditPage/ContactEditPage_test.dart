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

  testWidgets("ContactEditPage has a TextField and a button",
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: ContactEditPage(
        phoneNumber: "0721985674",
      ),
    ));

    final textFieldFinder = find.byType(TextField);
    final buttonFinder = find.byType(ElevatedButton);

    expect(textFieldFinder, findsOneWidget);
    expect(buttonFinder, findsOneWidget);
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

    expect(find.text("Joshua"), findsOneWidget);
  });
}
