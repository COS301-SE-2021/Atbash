import 'dart:core';

import 'package:mobile/domain/Child.dart';
import 'package:mobile/services/DatabaseService.dart';

class ChildService {
  final DatabaseService databaseService;

  ChildService(this.databaseService);

  Future<List<Child>> fetchAll() async {
    final db = await databaseService.database;

    final response = await db.query(Child.TABLE_NAME, orderBy: "name");

    final children = <Child>[];
    response.forEach((element) {
      final child = Child.fromMap(element);

      if (child != null) children.add(child);
    });

    return children;
  }

  Future<Child> fetchByPhoneNumber(String phoneNumber) async {
    final db = await databaseService.database;

    final response = await db.query(Child.TABLE_NAME,
        where: "${Child.COLUMN_PHONE_NUMBER} = ?", whereArgs: [phoneNumber]);

    if (response.isEmpty) throw ChildDoesNotExistException();

    final child = Child.fromMap(response.first);
    if (child == null) {
      throw ChildDoesNotExistException();
    } else {
      return child;
    }
  }

  Future<Child> insert(Child child) async {
    final db = await databaseService.database;

    await db.transaction((txn) async {
      final existingChild = await txn.query(Child.TABLE_NAME,
          where: "${Child.COLUMN_PHONE_NUMBER} = ?",
          whereArgs: [child.phoneNumber]);
      if (existingChild.isNotEmpty) throw DuplicateChildException();

      await txn.insert(Child.TABLE_NAME, child.toMap());
    });

    return child;
  }

  Future<void> update(String phoneNumber,
      {String? name,
      bool? editableSettings,
      bool? blurImages,
      bool? safeMode,
      bool? shareProfilePicture,
      bool? shareStatus,
      bool? shareReadReceipts,
      bool? shareBirthday,
      bool? lockedAccount,
      bool? privateChatAccess,
      bool? blockSaveMedia,
      bool? blockEditingMessages,
      bool? blockDeletingMessages}) async {
    final db = await databaseService.database;

    await db.transaction((txn) async {
      final existingChild = await txn.query(Child.TABLE_NAME,
          where: "${Child.COLUMN_PHONE_NUMBER} = ?", whereArgs: [phoneNumber]);

      if (existingChild.isEmpty) throw ChildDoesNotExistException();

      final child = Child.fromMap(existingChild.first);

      if (child != null) {
        if (name != null) child.name = name;
        if (editableSettings != null) child.editableSettings = editableSettings;
        if (blurImages != null) child.blurImages = blurImages;
        if (safeMode != null) child.safeMode = safeMode;
        if (shareProfilePicture != null)
          child.shareProfilePicture = shareProfilePicture;
        if (shareStatus != null) child.shareStatus = shareStatus;
        if (shareReadReceipts != null)
          child.shareReadReceipts = shareReadReceipts;
        if (shareBirthday != null) child.shareBirthday = shareBirthday;
        if (lockedAccount != null) child.lockedAccount = lockedAccount;
        if (privateChatAccess != null)
          child.privateChatAccess = privateChatAccess;
        if (blockSaveMedia != null) child.blockSaveMedia = blockSaveMedia;
        if (blockEditingMessages != null)
          child.blockEditingMessages = blockEditingMessages;
        if (blockDeletingMessages != null)
          child.blockDeletingMessages = blockDeletingMessages;

        await txn.update(Child.TABLE_NAME, child.toMap(),
            where: "${Child.COLUMN_PHONE_NUMBER} = ?",
            whereArgs: [child.phoneNumber]);
      }
    });
  }

  Future<void> deleteByNumber(String phoneNumber) async {
    final db = await databaseService.database;

    db.transaction((txn) async {
      final existingChild = await txn.query(Child.TABLE_NAME,
          where: "${Child.COLUMN_PHONE_NUMBER} = ?", whereArgs: [phoneNumber]);

      if (existingChild.isEmpty) throw ChildDoesNotExistException();

      final child = Child.fromMap(existingChild.first);

      if (child != null)
        txn.delete(Child.TABLE_NAME,
            where: "${Child.COLUMN_PHONE_NUMBER} = ?",
            whereArgs: [child.phoneNumber]);
    });
  }
}

class ChildDoesNotExistException implements Exception {}

class DuplicateChildException implements Exception {}
