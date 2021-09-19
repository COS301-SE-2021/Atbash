import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/pages/ProfileSettingsPage.dart';
import 'package:mobile/services/CommunicationService.dart';
import 'package:mobile/services/ContactService.dart';
import 'package:mobile/services/UserService.dart';
import 'package:mobile/widgets/AvatarIcon.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'ProfileSettingsPage_test.mocks.dart';

@GenerateMocks([UserService, ContactService, CommunicationService])
void main() {
  final userService = MockUserService();
  final contactService = MockContactService();
  final communicationService = MockCommunicationService();

  GetIt.I.registerSingleton<UserService>(userService);
  GetIt.I.registerSingleton<ContactService>(contactService);
  GetIt.I.registerSingleton<CommunicationService>(communicationService);

  setUp(() {
    when(userService.getPhoneNumber()).thenAnswer((_) => Future.value(""));
    when(userService.getDisplayName()).thenAnswer((_) => Future.value(""));
    when(userService.getStatus()).thenAnswer((_) => Future.value(""));
    when(userService.getBirthday()).thenAnswer((_) => Future.value(null));
    when(userService.getProfileImage()).thenAnswer((_) => Future.value(null));
    when(contactService.fetchAll()).thenAnswer((_) => Future.value([]));
  });

  testWidgets("Page should contain correct widgets",
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: ProfileSettingsPage(
        setup: true,
      ),
    ));

    expect(find.byType(IconButton), findsNWidgets(2));
    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.byType(AvatarIcon), findsOneWidget);
    expect(find.byType(TextButton), findsOneWidget);
    expect(find.byType(MaterialButton), findsOneWidget);
  });

  group("Widget tests for entering the page for the first time.", () {
    testWidgets("Info text should be visible", (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: ProfileSettingsPage(
          setup: true,
        ),
      ));

      expect(find.byKey(Key('infoText')), findsOneWidget);
      expect(find.text("Next"), findsOneWidget);
    });

    testWidgets("Button should display 'next'", (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: ProfileSettingsPage(
          setup: true,
        ),
      ));

      expect(find.widgetWithText(MaterialButton, "Next"), findsOneWidget);
    });

    testWidgets("Birthday selector should be defaulted to 'Select Birthday'",
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: ProfileSettingsPage(
          setup: true,
        ),
      ));

      expect(
          find.widgetWithText(TextButton, "Select Birthday"), findsOneWidget);
    });

    testWidgets("When clicking next with blank display name, show snackBar",
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: ProfileSettingsPage(
          setup: true,
        ),
      ));

      final button = find.byKey(Key('button'));

      await tester.tap(button);
      await tester.pump();

      expect(find.byKey(Key('importContactDialog')), findsNothing);
      expect(find.byKey(Key("snackBar")), findsOneWidget);
    });

    testWidgets(
        "When clicking next with filled displayName, should display alertDialog",
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: ProfileSettingsPage(
          setup: true,
        ),
      ));

      final button = find.byKey(Key('button'));
      final textField = find.byKey(Key('displayNameText'));

      await tester.enterText(textField, "MockName");
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.tap(button);
      await tester.pump();

      expect(find.byKey(Key('importContactDialog')), findsOneWidget);
    });
  });

  group("Widget tests for entering the page after initial setup", () {
    testWidgets("Info text should not be visible", (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: ProfileSettingsPage(
          setup: false,
        ),
      ));

      expect(find.byKey(Key('infoText')), findsNothing);
    });

    testWidgets("Button should display 'Save'", (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: ProfileSettingsPage(
          setup: false,
        ),
      ));

      expect(find.widgetWithText(MaterialButton, "Save"), findsOneWidget);
    });

    testWidgets("Fields should display data from database",
        (WidgetTester tester) async {
      when(userService.getDisplayName())
          .thenAnswer((_) => Future.value("Connor"));
      when(userService.getStatus())
          .thenAnswer((_) => Future.value("Living life"));

      await tester.pumpWidget(MaterialApp(
        home: ProfileSettingsPage(
          setup: false,
        ),
      ));

      expect(find.widgetWithText(TextField, "Connor"), findsOneWidget);
      expect(find.widgetWithText(TextField, "Living life"), findsOneWidget);
    });
  });
}
