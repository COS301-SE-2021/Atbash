import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/pages/VerificationPage.dart';

void main() {
  testWidgets("Test widgets present", (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: VerificationPage(),
    ));

    final textFinder = find.byType(Text);
    final textFieldFinder = find.byType(TextField);
    final buttonFinder = find.byType(ElevatedButton);

    expect(textFinder, findsNWidgets(2));
    expect(textFieldFinder, findsOneWidget);
    expect(buttonFinder, findsOneWidget);
  });

  testWidgets(
    "Test clicking VERIFY shows SnackBar if invalid code length",
    (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: VerificationPage(),
      ));

      final buttonFinder = find.byType(ElevatedButton);
      final snackBarFinder = find.byKey(Key('snackBar'));

      expect(buttonFinder, findsOneWidget);
      expect(snackBarFinder, findsNothing);

      await tester.tap(buttonFinder);
      await tester.pump();

      expect(snackBarFinder, findsOneWidget);
    },
  );
}
