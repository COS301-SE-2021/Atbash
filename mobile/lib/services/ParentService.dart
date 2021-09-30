import 'package:mobile/domain/Parent.dart';
import 'package:mobile/services/DatabaseService.dart';

class ParentService {
  final DatabaseService databaseService;

  ParentService(this.databaseService);

  Future<Parent> fetchByNumber(String number) async {
    final db = await databaseService.database;

    final result = await db.query(Parent.TABLE_NAME,
        where: "${Parent.COLUMN_PHONE_NUMBER} = ?", whereArgs: [number]);

    if (result.isNotEmpty) {
      final parent = Parent.fromMap(result.first);
      if (parent == null) throw ParentDoesNotExistException();

      return parent;
    }

    throw ParentDoesNotExistException();
  }

  Future<Parent> fetchByCode(String code) async {
    final db = await databaseService.database;

    final result = await db.query(Parent.TABLE_NAME,
        where: "${Parent.COLUMN_CODE} = ?", whereArgs: [code]);

    if (result.isNotEmpty) {
      final parent = Parent.fromMap(result.first);
      if (parent == null) throw ParentDoesNotExistException();

      return parent;
    }

    throw ParentDoesNotExistException();
  }

  Future<Parent> fetchByEnabled(bool enabled) async {
    final db = await databaseService.database;

    final result = await db.query(Parent.TABLE_NAME,
        where: "${Parent.COLUMN_ENABLED} = ?", whereArgs: [enabled]);

    if (result.isNotEmpty) {
      final parent = Parent.fromMap(result.first);
      if (parent == null) throw ParentDoesNotExistException();

      return parent;
    }

    throw ParentDoesNotExistException();
  }

  Future<void> insert(Parent parent) async {
    final db = await databaseService.database;

    await db.transaction((txn) async {
      final parentAlreadyExists = await txn.query(Parent.TABLE_NAME,
          where: "${Parent.COLUMN_PHONE_NUMBER} = ?",
          whereArgs: [parent.phoneNumber]);

      if (parentAlreadyExists.isNotEmpty) {
        updateCode(parent.code, parent.phoneNumber);
      } else {
        txn.insert(Parent.TABLE_NAME, parent.toMap());
      }
    });
  }

  Future<void> updateCode(String code, String phoneNumber) async {
    final db = await databaseService.database;

    final response = await db.query(Parent.TABLE_NAME,
        where: "${Parent.COLUMN_PHONE_NUMBER} = ?", whereArgs: [phoneNumber]);

    if (response.isNotEmpty) {
      db.rawQuery(
          "UPDATE ${Parent.TABLE_NAME} where ${Parent.COLUMN_PHONE_NUMBER} = ? SET ${Parent.COLUMN_CODE} = ?",
          [phoneNumber, code]);
    }
  }

  Future<void> updateEnabledByCode(String code, bool enabled) async {
    final db = await databaseService.database;

    //Check if exists?
    final response = await db.query(Parent.TABLE_NAME,
        where: "${Parent.COLUMN_CODE} = ?", whereArgs: [code]);

    if (response.isNotEmpty) {
      final parent = Parent.fromMap(response.first);

      if (parent != null) {
        parent.enabled = enabled;
        db.update(Parent.TABLE_NAME, parent.toMap(),
            where: "${Parent.COLUMN_PHONE_NUMBER} = ?",
            whereArgs: [parent.phoneNumber]);
      }
    }
  }

  Future<void> deleteByNumber(String number) async {
    final db = await databaseService.database;

    await db.delete(Parent.TABLE_NAME,
        where: "${Parent.COLUMN_PHONE_NUMBER} = ?", whereArgs: [number]);
  }
}

class ParentAlreadyExistsException implements Exception {}

class ParentDoesNotExistException implements Exception {}
