import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/controllers/ContactInfoPageController.dart';
import 'package:mobile/pages/ContactInfoPage.dart';
import 'package:mobile/widgets/AvatarIcon.dart';
import 'package:mockito/annotations.dart';

import 'ContactInfoPage_test.mocks.dart';

@GenerateMocks([ContactInfoPageController])
void main() {
  final controller = MockContactInfoPageController();

  testWidgets("Page should contain correct widgets",
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: ContactInfoPage(
        phoneNumber: "0728954829",
        controller: controller,
      ),
    ));

    expect(find.byType(Text), findsNWidgets(4));
    expect(find.byType(AvatarIcon), findsOneWidget);
  });
}
