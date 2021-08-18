import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/domain/Contact.dart';
import 'package:mobile/models/ContactsModel.dart';
import 'package:mobile/pages/ContactEditPage.dart';
import 'package:mockito/annotations.dart';

import 'ContactEditPage_test.mocks.dart';

@GenerateMocks([ContactsModel])
void main() {
  final contactsModel = MockContactsModel();
  GetIt.I.registerSingleton<ContactsModel>(contactsModel);

  testWidgets("ContactEditPage has a TextField and a button",
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ContactEditPage(
            Contact("0721985674", "Joshua", "Hi", "", false, false, "")),
      ),
    );

    final textFieldFinder = find.byType(TextField);
    final buttonFinder = find.byType(MaterialButton);

    expect(textFieldFinder, findsOneWidget);
    expect(buttonFinder, findsOneWidget);
  });

  testWidgets("Verify that the initial text is the contacts name",
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ContactEditPage(
            Contact("0721985674", "Joshua", "Hi", "", false, false, "")),
      ),
    );

    //final textFieldFinder = find.byType(TextField);
    //final buttonFinder = find.byType(MaterialButton);
    //await tester.tap(buttonFinder);

    expect(find.text("Joshua"), findsOneWidget);
  });
}
