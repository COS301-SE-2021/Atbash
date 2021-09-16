import 'dart:typed_data';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/models/UserModel.dart';
import 'package:mobile/pages/ProfileSetupPage.dart';
import 'package:mobile/pages/RegistrationPage.dart';
import 'package:mobile/services/UserService.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'RegistrationPage_test.mocks.dart';

// @GenerateMocks([UserService, UserModel])
void main() {
  final userService = MockUserService();
  final userModel = MockUserModel();

  GetIt.I.registerSingleton(userService);
  GetIt.I.registerSingleton<UserModel>(userModel);

  testWidgets("Registration has image, country code, phone number, and button",
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: RegistrationPage(
          userService: userService,
        ),
      ),
    );
    final logoFinder = find.byType(SvgPicture);
    final countryCodePickerFinder = find.byType(CountryCodePicker);
    final textFieldFinder = find.byType(TextField);
    final buttonFinder = find.byType(MaterialButton);

    expect(logoFinder, findsOneWidget);
    expect(countryCodePickerFinder, findsOneWidget);
    expect(textFieldFinder, findsOneWidget);
    expect(buttonFinder, findsOneWidget);
  });

  testWidgets(
      "clicking 'REGISTER' shows loading icon and succeeds, displaying ProfileSetupPage",
      (WidgetTester tester) async {
    when(userService.register(any)).thenAnswer((_) => Future.value(true));
    when(userModel.displayName).thenReturn("");
    when(userModel.status).thenReturn("");
    when(userModel.profileImage).thenReturn(Uint8List(0));

    await tester.pumpWidget(
      MaterialApp(
        home: RegistrationPage(
          userService: userService,
        ),
      ),
    );

    final buttonFinder = find.byType(MaterialButton);
    final loadingIconFinder = find.byType(SpinKitThreeBounce);

    expect(buttonFinder, findsOneWidget);
    expect(loadingIconFinder, findsNothing);

    await tester.tap(buttonFinder);
    await tester.pump();

    expect(buttonFinder, findsNothing);
    expect(loadingIconFinder, findsOneWidget);

    await tester.pump();

    expect(find.byType(ProfileSetupPage), findsOneWidget);
  });

  testWidgets(
      "clicking 'REGISTER' shows loading icon and fails, showing 'REGISTER' button again",
      (WidgetTester tester) async {
    when(userService.register(any)).thenAnswer((_) => Future.value(false));
    await tester.pumpWidget(
      MaterialApp(
        home: RegistrationPage(
          userService: userService,
        ),
      ),
    );

    final buttonFinder = find.byType(MaterialButton);
    final loadingIconFinder = find.byType(SpinKitThreeBounce);

    expect(buttonFinder, findsOneWidget);
    expect(loadingIconFinder, findsNothing);

    await tester.tap(buttonFinder);
    await tester.pump();

    expect(buttonFinder, findsOneWidget);
    expect(loadingIconFinder, findsNothing);

    await tester.pump();

    expect(find.byType(RegistrationPage), findsOneWidget);
  });
}
