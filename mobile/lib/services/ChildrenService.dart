import 'dart:core';

import 'package:mobile/domain/Child.dart';
import 'package:mobile/services/DatabaseService.dart';

class ChildrenService {
  final DatabaseService databaseService;

  ChildrenService(this.databaseService);

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


}

class ChildDoesNotExistException implements Exception {}

class DuplicateChildException implements Exception {}
