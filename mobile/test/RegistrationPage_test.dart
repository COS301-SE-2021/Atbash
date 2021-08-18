import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/pages/RegistrationPage.dart';

import 'service/UserServiceMock.dart';

void main() {
  UserServiceMock userServiceMock = UserServiceMock();

  testWidgets("Registration has image, country code, phone number, and button",
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: RegistrationPage(userService: userServiceMock),
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
}
