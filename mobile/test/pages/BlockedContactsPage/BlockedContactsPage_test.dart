import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/domain/BlockedNumber.dart';
import 'package:mobile/domain/Contact.dart';
import 'package:mobile/pages/BlockedContactsPage.dart';
import 'package:mobile/services/BlockedNumbersService.dart';
import 'package:mobile/services/ContactService.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'BlockedContactsPage_test.mocks.dart';

@GenerateMocks([BlockedNumbersService, ContactService])
void main() {
  final blockedNumbersService = MockBlockedNumbersService();
  final contactsService = MockContactService();

  GetIt.I.registerSingleton<BlockedNumbersService>(blockedNumbersService);
  GetIt.I.registerSingleton<ContactService>(contactsService);

  setUpAll(() {
    when(contactsService.fetchAll()).thenAnswer(
      (_) => Future.value([
        Contact(
          phoneNumber: "123",
          displayName: "Dylan",
          status: "Hello",
          profileImage: "",
        ),
        Contact(
          phoneNumber: "456",
          displayName: "Connor",
          status: "Hey",
          profileImage: "",
        ),
        Contact(
          phoneNumber: "789",
          displayName: "Josh",
          status: "Sup",
          profileImage: "",
        )
      ]),
    );

    when(blockedNumbersService.fetchAll()).thenAnswer((_) => Future.value([]));
  });

  testWidgets("Widgets present", (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlockedContactsPage(),
      ),
    );

    final searchFinder = find.byKey(Key('BlockedContactsPage_search'));
    expect(searchFinder, findsOneWidget);
  });

  testWidgets("Number of blocked contacts", (tester) async {
    when(blockedNumbersService.fetchAll()).thenAnswer(
      (_) => Future.value([
        BlockedNumber(phoneNumber: "123"),
        BlockedNumber(phoneNumber: "789"),
      ]),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: BlockedContactsPage(),
      ),
    );

    await tester.pump();

    final number123Finder = find.text("Dylan");
    final number456Finder = find.text("Connor");
    final number789Finder = find.text("Josh");

    expect(number123Finder, findsOneWidget);
    expect(number456Finder, findsNothing);
    expect(number789Finder, findsOneWidget);
  });

  testWidgets(
    "Clicking 'remove' and then 'Yes' removes blocked contact",
    (tester) async {
      when(blockedNumbersService.fetchAll()).thenAnswer(
        (_) => Future.value([
          BlockedNumber(phoneNumber: "123"),
          BlockedNumber(phoneNumber: "789"),
        ]),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: BlockedContactsPage(),
        ),
      );

      await tester.pump();

      final remove123Finder = find.byKey(Key('BlockedContactsPage_remove_123'));
      final dialogYesFinder = find.byKey(Key('ConfirmDialogPositive'));

      expect(remove123Finder, findsOneWidget);
      expect(dialogYesFinder, findsNothing);

      await tester.tap(remove123Finder);
      await tester.pump();

      expect(dialogYesFinder, findsOneWidget);

      await tester.tap(dialogYesFinder);
      await tester.pump();

      expect(find.text("Dylan"), findsNothing);
      expect(find.text("Josh"), findsOneWidget);
    },
  );

  testWidgets(
    "Clicking 'remove' and then 'No' does not remove contact",
    (tester) async {
      when(blockedNumbersService.fetchAll()).thenAnswer(
        (_) => Future.value([
          BlockedNumber(phoneNumber: "123"),
          BlockedNumber(phoneNumber: "789"),
        ]),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: BlockedContactsPage(),
        ),
      );
      await tester.pump();

      final remove123Finder = find.byKey(Key('BlockedContactsPage_remove_123'));
      final dialogNoFinder = find.byKey(Key('ConfirmDialogNegative'));

      expect(remove123Finder, findsOneWidget);
      expect(dialogNoFinder, findsNothing);

      await tester.tap(remove123Finder);
      await tester.pump();

      expect(dialogNoFinder, findsOneWidget);

      await tester.tap(dialogNoFinder);
      await tester.pump();

      expect(find.text("Dylan"), findsOneWidget);
      expect(find.text("Josh"), findsOneWidget);
    },
  );

  testWidgets("Clicking 'plus' and then 'Add' adds a contact", (tester) async {
    when(blockedNumbersService.insert(any))
        .thenAnswer((_) => Future.value(BlockedNumber(phoneNumber: "12345")));

    await tester.pumpWidget(
      MaterialApp(
        home: BlockedContactsPage(),
      ),
    );
    await tester.pump();

    final addActionFinder = find.byIcon(Icons.add);
    final phoneNumberFieldFinder = find.byKey(Key('NewNumberDialogField'));
    final addButtonFinder = find.byKey(Key('NewNumberDialogAdd'));

    expect(addActionFinder, findsOneWidget);
    expect(phoneNumberFieldFinder, findsNothing);
    expect(addButtonFinder, findsNothing);

    await tester.tap(addActionFinder);
    await tester.pump();

    expect(phoneNumberFieldFinder, findsOneWidget);
    expect(addButtonFinder, findsOneWidget);

    await tester.enterText(phoneNumberFieldFinder, "12345");
    await tester.pump();
    await tester.tap(addButtonFinder);
    await tester.pump();

    expect(find.text("+2712345"), findsOneWidget);
  });

  testWidgets("Clicking 'plus' and then 'Cancel' adds nothing", (tester) async {
    when(blockedNumbersService.insert(any))
        .thenAnswer((_) => Future.value(BlockedNumber(phoneNumber: "12345")));

    await tester.pumpWidget(
      MaterialApp(
        home: BlockedContactsPage(),
      ),
    );
    await tester.pump();

    final addActionFinder = find.byIcon(Icons.add);
    final phoneNumberFieldFinder = find.byKey(Key('NewNumberDialogField'));
    final cancelButtonFinder = find.byKey(Key('NewNumberDialogCancel'));

    expect(addActionFinder, findsOneWidget);
    expect(phoneNumberFieldFinder, findsNothing);
    expect(cancelButtonFinder, findsNothing);

    await tester.tap(addActionFinder);
    await tester.pump();

    expect(phoneNumberFieldFinder, findsOneWidget);
    expect(cancelButtonFinder, findsOneWidget);

    await tester.enterText(phoneNumberFieldFinder, "12345");
    await tester.tap(cancelButtonFinder);
    await tester.pump();

    final widgets = find.byType(Widget);
    tester.widgetList(widgets);

    expect(find.text("+2712345"), findsNothing);
  });
}
