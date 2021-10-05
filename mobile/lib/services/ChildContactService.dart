import 'package:mobile/domain/ChildContact.dart';
import 'package:mobile/services/DatabaseService.dart';

class ChildContactService {
  final DatabaseService databaseService;

  ChildContactService(this.databaseService);

  Future<List<ChildContact>> fetchAllContactsByChildNumber(
      String phoneNumber) async {
    final db = await databaseService.database;

    final result = await db.query(ChildContact.TABLE_NAME,
        where: "${ChildContact.COLUMN_CHILD_PHONE_NUMBER} = ?",
        whereArgs: [phoneNumber]);

    final contacts = <ChildContact>[];
    result.forEach((element) {
      final contact = ChildContact.fromMap(element);

      if (contact != null) contacts.add(contact);
    });

    return contacts;
  }

  Future<void> insert(ChildContact contact) async {
    final db = await databaseService.database;

    await db.transaction((txn) async {
      final contactAlreadyExists = await txn.query(ChildContact.TABLE_NAME,
          where:
              "${ChildContact.COLUMN_CHILD_PHONE_NUMBER} = ? AND ${ChildContact.COLUMN_CONTACT_PHONE_NUMBER} = ?",
          whereArgs: [contact.childPhoneNumber, contact.contactPhoneNumber]);

      if (contactAlreadyExists.isNotEmpty)
        throw ChildContactAlreadyExistsException();

      txn.insert(ChildContact.TABLE_NAME, contact.toMap());
    });
  }

  Future<void> updateProfileImage(
      String childNumber, String contactNumber, String profileImage) async {
    final db = await databaseService.database;

    await db.transaction((txn) async {
      final contactAlreadyExists = await txn.query(ChildContact.TABLE_NAME,
          where:
              "${ChildContact.COLUMN_CHILD_PHONE_NUMBER} = ? AND ${ChildContact.COLUMN_CONTACT_PHONE_NUMBER} = ?",
          whereArgs: [childNumber, contactNumber]);

      if (contactAlreadyExists.isNotEmpty) {
        await txn.rawUpdate(
            "update ${ChildContact.TABLE_NAME} SET ${ChildContact.COLUMN_PROFILE_IMAGE} = ? where ${ChildContact.COLUMN_CHILD_PHONE_NUMBER} = ? AND ${ChildContact.COLUMN_CONTACT_PHONE_NUMBER} = ?",
            [profileImage, childNumber, contactNumber]);
      }
    });
  }

  Future<void> deleteByNumbers(String childNumber, String contactNumber) async {
    final db = await databaseService.database;

    await db.transaction((txn) async {
      final contactAlreadyExists = await txn.query(ChildContact.TABLE_NAME,
          where:
              "${ChildContact.COLUMN_CHILD_PHONE_NUMBER} = ? AND ${ChildContact.COLUMN_CONTACT_PHONE_NUMBER} = ?",
          whereArgs: [childNumber, contactNumber]);

      if (contactAlreadyExists.isEmpty)
        throw ChildContactDoesNotExistException();

      await txn.delete(ChildContact.TABLE_NAME,
          where:
              "${ChildContact.COLUMN_CHILD_PHONE_NUMBER} = ? AND ${ChildContact.COLUMN_CONTACT_PHONE_NUMBER} = ?",
          whereArgs: [childNumber, contactNumber]);
    });
  }

  Future<void> deleteAllByChildNumber(String childNumber) async {
    final db = await databaseService.database;

    await db.delete(ChildContact.TABLE_NAME,
        where: "${ChildContact.COLUMN_CHILD_PHONE_NUMBER} = ?",
        whereArgs: [childNumber]);
  }
}

class ChildContactAlreadyExistsException implements Exception {}

class ChildContactDoesNotExistException implements Exception {}
