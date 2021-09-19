import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/domain/BlockedNumber.dart';
import 'package:mobile/domain/Contact.dart';
import 'package:mobile/pages/ContactInfoPage.dart';
import 'package:mobile/services/BlockedNumbersService.dart';
import 'package:mobile/services/ContactService.dart';
import 'package:mobile/widgets/AvatarIcon.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'ContactInfoPage_test.mocks.dart';

@GenerateMocks([ContactService, BlockedNumbersService])
void main() {
  final contactService = MockContactService();
  final blockedNumberService = MockBlockedNumbersService();

  GetIt.I.registerSingleton<ContactService>(contactService);
  GetIt.I.registerSingleton<BlockedNumbersService>(blockedNumberService);

  setUp(() {
    when(contactService.fetchByPhoneNumber(any)).thenAnswer(
      (_) => Future.value(
        Contact(
          phoneNumber: "0728954829",
          displayName: "ABC",
          status: "Hello",
          profileImage: "",
        ),
      ),
    );

    when(blockedNumberService.checkIfBlocked(any))
        .thenAnswer((_) => Future.value(false));
  });

  testWidgets("Page should contain correct widgets",
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: ContactInfoPage(
        phoneNumber: "0728954829",
      ),
    ));

    expect(find.byType(Text), findsNWidgets(6));
    expect(find.byType(AvatarIcon), findsOneWidget);
  });

  group("Widget tests for when the contact is not blocked", () {
    testWidgets("Button should say 'Block Contact'",
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: ContactInfoPage(
          phoneNumber: "0728954829",
        ),
      ));

      expect(
          find.widgetWithText(ElevatedButton, "Block Contact"), findsOneWidget);
    });

    testWidgets("Display name should show 'ABC'", (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: ContactInfoPage(
          phoneNumber: "0728954829",
        ),
      ));

      await tester.pump();

      expect(find.byKey(Key('contactInfoPage_displayName')), findsOneWidget);
      expect(find.text('ABC'), findsOneWidget);
    });

    testWidgets("Status should show 'Hello'", (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: ContactInfoPage(
          phoneNumber: "0728954829",
        ),
      ));

      await tester.pump();

      expect(find.byKey(Key('contactInfoPage_status')), findsOneWidget);
      expect(find.text('Hello'), findsOneWidget);
    });

    testWidgets("Phone number should show '0728954829'",
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: ContactInfoPage(
          phoneNumber: "0728954829",
        ),
      ));

      await tester.pump();

      expect(find.byKey(Key('contactInfoPage_phoneNumber')), findsOneWidget);
      expect(find.text('0728954829'), findsOneWidget);
    });

    testWidgets("When birthday not set, should show 'Birthday not set'",
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: ContactInfoPage(
          phoneNumber: "0728954829",
        ),
      ));

      await tester.pump();

      expect(find.byKey(Key('contactInfoPage_birthday')), findsOneWidget);
      expect(find.text('Birthday not set'), findsOneWidget);
    });

    testWidgets("When birthday is set, should show birthday",
        (WidgetTester tester) async {
      when(contactService.fetchByPhoneNumber(any)).thenAnswer(
        (_) => Future.value(
          Contact(
            phoneNumber: "0728954829",
            displayName: "ABC",
            status: "Hello",
            profileImage: "",
            birthday: DateTime(2000, 9, 11),
          ),
        ),
      );

      await tester.pumpWidget(MaterialApp(
        home: ContactInfoPage(
          phoneNumber: "0728954829",
        ),
      ));

      await tester.pump();

      expect(find.byKey(Key('contactInfoPage_birthday')), findsOneWidget);
      expect(find.text('11 September 2000'), findsOneWidget);
    });

    testWidgets(
        "When contact is not blocked, clicking block should change text in button to 'unblock'",
        (WidgetTester tester) async {
      when(blockedNumberService.insert(any)).thenAnswer(
          (_) => Future.value(BlockedNumber(phoneNumber: "0728954829")));

      await tester.pumpWidget(MaterialApp(
        home: ContactInfoPage(
          phoneNumber: "0728954829",
        ),
      ));

      await tester.pump();

      final blockButton = find.byKey(Key('blockButton'));
      expect(blockButton, findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, "Block Contact"), findsOneWidget);
      expect(find.byKey(Key('unblockButton')), findsNothing);

      await tester.tap(blockButton);
      await tester.pump();
      expect(blockButton, findsNothing);
      expect(find.widgetWithText(ElevatedButton, "Unblock Contact"), findsOneWidget);
      expect(find.byKey(Key('unblockButton')), findsOneWidget);
    });
  });
}
