import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/controllers/ProfileSettingsPageController.dart';
import 'package:mobile/pages/ProfileSettingsPage.dart';
import 'package:mobile/widgets/AvatarIcon.dart';
import 'package:mockito/annotations.dart';

import 'ProfileSettingsPage_test.mocks.dart';

@GenerateMocks([ProfileSettingsPageController])
void main() {
  final controller = MockProfileSettingsPageController();

  testWidgets("Page should contain correct widgets",
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: ProfileSettingsPage(
        setup: true,
        controller: controller,
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
          controller: controller,
        ),
      ));

      expect(find.byKey(Key('infoText')), findsOneWidget);
      expect(find.text("Next"), findsOneWidget);
    });

    testWidgets("Button should display 'next'", (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: ProfileSettingsPage(
          setup: true,
          controller: controller,
        ),
      ));

      expect(find.widgetWithText(MaterialButton, "Next"), findsOneWidget);
    });
  });

  group("Widget tests for entering the page after initial setup", () {
    testWidgets("Info text should not be visible", (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: ProfileSettingsPage(
          setup: false,
          controller: controller,
        ),
      ));

      expect(find.byKey(Key('infoText')), findsNothing);
    });

    testWidgets("Button should display 'Save'", (WidgetTester tester) async {
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
