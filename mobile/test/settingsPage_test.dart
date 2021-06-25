import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'mockingForPageTests.dart';

import 'package:mobile/pages/MainPage.dart';

void main() {
  mockingServicesSetup();
  mockFunctionsSetup();

  testWidgets(
      'Check for correct widget functionality for main screen navigation to other screens',
      (WidgetTester tester) async {

    //Changing testing screen size so all components are on screen
    tester.binding.window.physicalSizeTestValue = Size(800, 1000);
    tester.binding.window.devicePixelRatioTestValue = 1.0;

    //Build a MaterialApp with the LoginPage.
    final mockObserver = MockNavigatorObserver();
    await tester.pumpWidget(MaterialApp(
      home: MainPage(),
      navigatorObservers: [mockObserver],
    ));

    //Click menu button and verify settings button is now visible
    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle();
    expect(find.text('Settings'), findsOneWidget);

    //Navigate to settings
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();

    /// Verify that a push event happened
    verify(mockObserver.didPush(any, any));
    /// Verify that a pop event happened
    verify(mockObserver.didPop(any, any)); // Not sure why this passes??

    //Check for 'Settings' title
    expect(find.text('Settings'), findsOneWidget);

    //Check for text
    expect(find.text('Change profile picture:'), findsOneWidget);

    //Find change name textfield and enter text
    final Finder cText = find.text("Change display name", skipOffstage: false);
    final Finder cTextA = find.ancestor(of: cText, matching: find.byType(Column));
    final Finder textFc = find.descendant(of: cTextA, matching: find.byType(TextField));
    expect(textFc, findsOneWidget);
    final String newDisplayName = "new_display_name";
    await tester.enterText(textFc, newDisplayName);
    // await tester.pump(); //Needed??

    //Find change status textfield and enter text
    final Finder sText = find.text("Change status");
    final Finder sTextA = find.ancestor(of: sText, matching: find.byType(Column));
    final Finder textFs = find.descendant(of: sTextA, matching: find.byType(TextField));
    expect(textFs, findsOneWidget);
    final String newStatus = "new_status";
    await tester.enterText(textFs, newStatus);
    // await tester.pump(); //Needed??

    //tester.testTextInput.hide();

    //Find and tap Submit button
    final eButton = find.descendant(of: find.ancestor(of: find.text("SUBMIT"), matching: find.byType(Align)), matching: find.byType(ElevatedButton));
    expect(eButton, findsOneWidget);
    await tester.tap(eButton);
    await tester.pumpAndSettle();

    /// Verify that a pop event happened
    verify(mockObserver.didPop(any, any));

    //Check for text
    expect(find.text('Change profile picture:'), findsNothing);

    //Verified correct methods were called
    verify(mockUserService.setDisplayName(newDisplayName)).called(1);
    verify(mockUserService.setStatus(newStatus)).called(1);
    verify(mockUserService.setProfileImage("")).called(1);
  });
}
