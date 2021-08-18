import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/models/UserModel.dart';
import 'package:mobile/pages/ProfileSetupPage.dart';

import 'service/UserModelMock.dart';

void main() {
  UserModelMock userModelMock = UserModelMock();

  GetIt.I.registerSingleton<UserModel>(userModelMock);

  testWidgets("SetupPage has CircleAvatar, two IconButton's, two TextField's",
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ProfileSetupPage(),
      ),
    );
    final pictureFinder = find.byType(CircleAvatar);
    final iconFinder = find.byType(IconButton);
    final textFieldFinder = find.byType(TextField);

    expect(pictureFinder, findsOneWidget);
    expect(iconFinder, findsWidgets);
    expect(textFieldFinder, findsWidgets);
  });
}
