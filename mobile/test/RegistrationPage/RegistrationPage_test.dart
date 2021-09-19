import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/pages/RegistrationPage.dart';
import 'package:mobile/services/RegistrationService.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'RegistrationPage_test.mocks.dart';

@GenerateMocks([RegistrationService])
void main() {
  final registrationService = MockRegistrationService();

  GetIt.I.registerSingleton<RegistrationService>(registrationService);

  testWidgets("Registration has image, country code, phone number, and button",
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: RegistrationPage(),
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
    when(registrationService.register(any)).thenAnswer((_) => Future.value(""));

    await tester.pumpWidget(
      MaterialApp(
        home: RegistrationPage(),
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
  });

  testWidgets(
      "clicking 'REGISTER' shows loading icon and fails, showing 'REGISTER' button again",
      (WidgetTester tester) async {
    when(registrationService.register(any))
        .thenAnswer((_) => Future.value(null));
    await tester.pumpWidget(
      MaterialApp(
        home: RegistrationPage(),
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
  });
}
