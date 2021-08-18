import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/domain/Contact.dart';
import 'package:mobile/models/ContactsModel.dart';
import 'package:mobile/models/UserModel.dart';
import 'package:mobile/pages/MainPage.dart';
import 'package:mobile/services/AppService.dart';
import 'package:mobile/services/DatabaseService.dart';
import 'package:mobx/mobx.dart' as mobx;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'MainPage_test.mocks.dart';

@GenerateMocks([UserModel, ContactsModel, AppService, DatabaseService])
void main() {
  final userModel = MockUserModel();
  final contactsModel = MockContactsModel();
  final appService = MockAppService();
  final databaseService = MockDatabaseService();

  GetIt.I.registerSingleton<AppService>(appService);
  GetIt.I.registerSingleton<DatabaseService>(databaseService);
  GetIt.I.registerSingleton<UserModel>(userModel);
  GetIt.I.registerSingleton<ContactsModel>(contactsModel);

  testWidgets("When page loaded, displayName and status should appear",
      (WidgetTester tester) async {
    when(contactsModel.filteredChatContacts)
        .thenReturn(mobx.ObservableList.of(<Contact>[]));
    when(userModel.profileImage).thenReturn(Uint8List(0));
    when(userModel.displayName).thenReturn("Connor");
    when(userModel.status).thenReturn("Happy");

    await tester.pumpWidget(
      MaterialApp(
        home: MainPage(),
      ),
    );

    expect(find.text("Connor"), findsOneWidget);
    expect(find.text("Happy"), findsOneWidget);
  });

  testWidgets("When page loaded, displayName and status should appear",
      (WidgetTester tester) async {
    when(contactsModel.filteredChatContacts)
        .thenReturn(mobx.ObservableList.of(<Contact>[]));
    when(userModel.profileImage).thenReturn(Uint8List(0));
    when(userModel.displayName).thenReturn("Connor");
    when(userModel.status).thenReturn("Happy");

    await tester.pumpWidget(
      MaterialApp(
        home: MainPage(),
      ),
    );

    final searchButton = find.byKey(Key('searchButton'));

    await tester.tap(searchButton);
    await tester.pump();

    expect(find.byKey(Key('searchField')), findsOneWidget);
  });
}
