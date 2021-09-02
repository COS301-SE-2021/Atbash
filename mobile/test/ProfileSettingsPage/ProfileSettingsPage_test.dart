import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/controllers/ProfileSettingsPageController.dart';
import 'package:mobile/pages/ProfileSettingsPage.dart';
import 'package:mockito/annotations.dart';

import 'ProfileSettingsPage_test.mocks.dart';

@GenerateMocks([
  ProfileSettingsPageController
])
void main() {
  final controller = MockProfileSettingsPageController();

  group("Widget tests for entering the page for the first time.", () {
    testWidgets("Info text should be visible",
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: ProfileSettingsPage(
          setup: true,
          controller: controller,
        ),
      ));

      expect(find.byKey(Key('infoText')), findsOneWidget);
      expect(find.text("Next"), findsOneWidget);
    });

    testWidgets("Button should display 'next'", (WidgetTester tester) async{
      await tester.pumpWidget(MaterialApp(
        home: ProfileSettingsPage(
          setup: true,
          controller: controller,
        ),
      ));

      expect(find.widgetWithText(MaterialButton, "Next"), findsOneWidget);
    });

    testWidgets("When clicking next, should display alertDialog",
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: ProfileSettingsPage(
          setup: true,
          controller: controller,
        ),
      ));

      final button = find.byKey(Key('button'));

      await tester.tap(button);
      await tester.pump();

      expect(find.byKey(Key('alertDialog')), findsOneWidget);
    });
  });

  group("Widget tests for entering the page after initial setup", () {
    testWidgets(
        "Info text should not be visible",
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: ProfileSettingsPage(
          setup: false,
          controller: controller,
        ),
      ));

      expect(find.byKey(Key('infoText')), findsNothing);
    });

    testWidgets(
        "Button should display 'Save'",
            (WidgetTester tester) async {
          await tester.pumpWidget(MaterialApp(
            home: ProfileSettingsPage(
              setup: false,
              controller: controller,
            ),
          ));

          expect(find.widgetWithText(MaterialButton, "Save"), findsOneWidget);
        });
  });
}
