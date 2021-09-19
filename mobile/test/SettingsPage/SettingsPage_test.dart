import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/pages/SettingsPage.dart';
import 'package:mobile/services/CommunicationService.dart';
import 'package:mobile/services/ContactService.dart';
import 'package:mobile/services/SettingsService.dart';
import 'package:mobile/services/UserService.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'SettingsPage_test.mocks.dart';

@GenerateMocks(
    [SettingsService, UserService, ContactService, CommunicationService])
void main() {
  final settingsService = MockSettingsService();
  final userService = MockUserService();
  final contactService = MockContactService();
  final communicationService = MockCommunicationService();

  GetIt.I.registerSingleton<SettingsService>(settingsService);
  GetIt.I.registerSingleton<UserService>(userService);
  GetIt.I.registerSingleton<ContactService>(contactService);
  GetIt.I.registerSingleton<CommunicationService>(communicationService);

  setUp(() {
    when(userService.getDisplayName())
        .thenAnswer((realInvocation) => Future.value("Connor"));
    when(userService.getStatus())
        .thenAnswer((realInvocation) => Future.value("Happy"));
    when(userService.getProfileImage())
        .thenAnswer((realInvocation) => Future.value(null));
    when(settingsService.getBlurImages())
        .thenAnswer((realInvocation) => Future.value(false));
    when(settingsService.getSafeMode())
        .thenAnswer((realInvocation) => Future.value(false));
    when(settingsService.getShareProfilePicture())
        .thenAnswer((realInvocation) => Future.value(false));
    when(settingsService.getShareStatus())
        .thenAnswer((realInvocation) => Future.value(false));
    when(settingsService.getShareBirthday())
        .thenAnswer((realInvocation) => Future.value(false));
    when(settingsService.getShareReadReceipts())
        .thenAnswer((realInvocation) => Future.value(false));
    when(settingsService.getDisableNotifications())
        .thenAnswer((realInvocation) => Future.value(false));
    when(settingsService.getDisableMessagePreview())
        .thenAnswer((realInvocation) => Future.value(false));
    when(settingsService.getAutoDownloadMedia())
        .thenAnswer((realInvocation) => Future.value(false));
  });

  testWidgets("Page should contain correct base widgets",
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: SettingsPage(),
    ));

    expect(find.byType(SwitchListTile), findsNWidgets(6));
    expect(find.byType(ListTile), findsNWidgets(8));
  });

  group("Tests to see if data extracted from database correctly", () {
    testWidgets("Display name should say 'Connor'",
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: SettingsPage(),
      ));

      await tester.pump();

      expect(find.byKey(Key("SettingsPage_displayName")), findsOneWidget);
      expect(find.text("Connor"), findsOneWidget);
    });

    testWidgets("Status should say 'Happy'", (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: SettingsPage(),
      ));

      await tester.pump();

      expect(find.byKey(Key("SettingsPage_status")), findsOneWidget);
      expect(find.text("Happy"), findsOneWidget);
    });

    testWidgets("All settings should exist",
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: SettingsPage(),
      ));

      await tester.pump();

      final blurImages = find.byKey(Key("blurImages"));
      final safeMode = find.byKey(Key("safeMode"));
      final sharedProfilePicture = find.byKey(Key("sharedProfilePicture"));
      final shareStatus = find.byKey(Key("shareStatus"));
      final shareBirthday = find.byKey(Key("shareBirthday"));
      final shareReadReceipts = find.byKey(Key("shareReadReceipts"));
      final blockedContacts = find.byKey(Key("blockedContacts"));
      final changeWallpaper = find.byKey(Key("changeWallpaper"));
      final chatAnalytics = find.byKey(Key("chatAnalytics"));
      final importContacts = find.byKey(Key("importContacts"));
      final disableNotifications = find.byKey(Key("disableNotifications"));
      final disableMessagePreview = find.byKey(Key("disableMessagePreview"));
      final help = find.byKey(Key("help"));

      expect(blurImages, findsOneWidget);
      expect(safeMode, findsOneWidget);
      expect(sharedProfilePicture, findsOneWidget);
      expect(shareStatus, findsOneWidget);
      expect(shareBirthday, findsOneWidget);
      expect(shareReadReceipts, findsOneWidget);
      expect(blockedContacts, findsOneWidget);
      expect(changeWallpaper, findsOneWidget);
      //TODO change below
      expect(chatAnalytics, findsNothing);
      expect(importContacts, findsNothing);
      expect(disableNotifications, findsNothing);
      expect(disableMessagePreview, findsNothing);
      expect(help, findsNothing);
    });
  });
}
