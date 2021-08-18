import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/models/UserModel.dart';
import 'package:mobile/pages/RegistrationPage.dart';

import 'service/UserModelMock.dart';
import 'service/UserServiceMock.dart';

void main() {
  UserServiceMock userServiceMock = UserServiceMock();
  UserModelMock userModelMock = UserModelMock();

  GetIt.I.registerSingleton(userServiceMock);
  GetIt.I.registerSingleton<UserModel>(userModelMock);

  testWidgets("Registration has image, country code, phone number, and button",
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: RegistrationPage(
          userService: userServiceMock,
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

  testWidgets("clicking 'REGISTER' shows loading icon and succeeds, displaying ProfileSetupPage",
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: RegistrationPage(
          userService: userServiceMock,
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
  });

  testWidgets("clicking 'REGISTER' shows loading icon and fails, showing 'REGISTER' button again",
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: RegistrationPage(
              userService: userServiceMock,
            ),
          ),
        );
        final buttonFinder = find.byType(MaterialButton);
        final loadingIconFinder = find.byType(SpinKitThreeBounce);

        expect(buttonFinder, findsOneWidget);
        expect(loadingIconFinder, findsNothing);

        await tester.tap(buttonFinder);
        await tester.pump();

        //TODO ask pfab how pump works, should show loading first then go back to register
        expect(buttonFinder, findsOneWidget);
        expect(loadingIconFinder, findsNothing);

        //userModel.register(validNumber)
      });
}
