import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/pages/WallpaperPage.dart';
import 'package:mobile/services/SettingsService.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'WallpaperPage_test.mocks.dart';

@GenerateMocks([SettingsService])
void main() {
  final settingsService = MockSettingsService();
  GetIt.I.registerSingleton<SettingsService>(settingsService);

  testWidgets("Snackbar_appears_when_tick_is_clicked",
      (WidgetTester tester) async {
    when(settingsService.getWallpaperImage())
        .thenAnswer((_) => Future.value(null));
    await tester.pumpWidget(MaterialApp(
      home: WallpaperPage(),
    ));

    await tester.pump();

    final tickButton = find.byKey(Key("WallpaperPage_snackbarAppears"));
    expect(tickButton, findsOneWidget);

    await tester.tap(tickButton);
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
  });
}
