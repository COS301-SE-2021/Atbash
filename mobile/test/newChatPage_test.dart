import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'mockingForPageTests.dart';

import 'package:mobile/pages/MainPage.dart';

void main() {
  mockingServicesSetup();
  mockFunctionsSetup();

  //Test Initializations
  //setUp((){}); Called before every test
  //tearDown((){}); Called after every test

  testWidgets(
      'Check for correct widget functionality for new chat screen navigation to other screens',
          (WidgetTester tester) async {
        //Build a MaterialApp with the LoginPage.
        final mockObserver = MockNavigatorObserver();
        await tester.pumpWidget(MaterialApp(
          home: MainPage(),
          navigatorObservers: [mockObserver],
        ));

        //Navigate to new chat
        await tester.tap(find.byType(FloatingActionButton));
        await tester.pumpAndSettle();

        /// Verify that a push event happened
        verify(mockObserver.didPush(any, any));

        //Verify on New Chat Screen
        expect(find.text("Select a Contact"), findsOneWidget);

        //Verify contacts appear on New Chat Screen
        expect(find.text(cList[0].displayName), findsOneWidget);
        expect(find.text(cList[1].displayName), findsOneWidget);

        //Navigate to chat screen
        await tester.tap(find.text(cList[0].displayName));
        await tester.pumpAndSettle();

        /// Verify that a replace event happened
        verify(mockObserver.didReplace(newRoute: any, oldRoute: any));

        //Verify contact name on Chat Screen
        expect(find.text(cList[0].displayName), findsOneWidget);
        expect(find.text(cList[1].displayName), findsNothing);
      });
}