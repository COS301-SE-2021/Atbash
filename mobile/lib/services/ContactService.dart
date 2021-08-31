import 'package:mobile/domain/Contact.dart';
import 'package:mobile/services/DatabaseService.dart';

class ContactService {
  final DatabaseService databaseService;

  ContactService(this.databaseService);

  final List<void Function()> _onChangedListeners = [];

  void onChanged(void Function() cb) => _onChangedListeners.add(cb);

  void disposeOnChanged(void Function() cb) => _onChangedListeners.remove(cb);

  Future<List<Contact>> fetchAll() async {
    final db = await databaseService.database;

    final response =
        await db.query(Contact.TABLE_NAME, orderBy: "contact_display_name");

    final contacts = <Contact>[];
    response.forEach((e) {
      final contact = Contact.fromMap(e);

      if (contact != null) contacts.add(contact);
    });

    return contacts;
  }

  Future<Contact> fetchByPhoneNumber(String phoneNumber) async {
    final db = await databaseService.database;

    final response = await db.query(Contact.TABLE_NAME,
        where: "${Contact.COLUMN_PHONE_NUMBER} = ?", whereArgs: [phoneNumber]);

    if (response.isEmpty) throw ContactWithPhoneNumberDoesNotExistException();

    final contact = Contact.fromMap(response.first);
    if (contact == null) {
      throw ContactWithPhoneNumberDoesNotExistException();
    } else {
      return contact;
    }
  }

  Future<Contact> insert(Contact contact) async {
    final db = await databaseService.database;

    await db.transaction((txn) async {
      final existingContact = await txn.query(Contact.TABLE_NAME,
          where: "${Contact.COLUMN_PHONE_NUMBER} = ?",
          whereArgs: [contact.phoneNumber]);

      if (existingContact.isNotEmpty)
        throw DuplicateContactPhoneNumberException();

      await txn.insert(Contact.TABLE_NAME, contact.toMap());
    });

    _notifyListeners();

    return contact;
  }

  Future<Contact> update(Contact contact) async {
    final db = await databaseService.database;

    await db.transaction((txn) async {
      final existingContact = await txn.query(Contact.TABLE_NAME,
          where: "${Contact.COLUMN_PHONE_NUMBER} = ?",
          whereArgs: [contact.phoneNumber]);

      if (existingContact.isEmpty)
        throw ContactWithPhoneNumberDoesNotExistException();

      await txn.update(Contact.TABLE_NAME, contact.toMap(),
          where: "${Contact.COLUMN_PHONE_NUMBER} = ?",
          whereArgs: [contact.phoneNumber]);
    });

    _notifyListeners();

    return contact;
  }

  Future<void> setContactProfileImage(
      String contactPhoneNumber, String profileImage) async {
    final db = await databaseService.database;

    await db.rawUpdate(
      "update ${Contact.TABLE_NAME} set ${Contact.COLUMN_PROFILE_IMAGE} = ? where ${Contact.COLUMN_PHONE_NUMBER} = ?",
      [profileImage, contactPhoneNumber],
    );
  }

  Future<void> deleteByPhoneNumber(String phoneNumber) async {
    final db = await databaseService.database;

    await db.transaction((txn) async {
      final existingContact = await txn.query(Contact.TABLE_NAME,
          where: "${Contact.COLUMN_PHONE_NUMBER} = ?",
          whereArgs: [phoneNumber]);

      if (existingContact.isEmpty)
        throw ContactWithPhoneNumberDoesNotExistException();

      await txn.delete(Contact.TABLE_NAME,
          where: "${Contact.COLUMN_PHONE_NUMBER} =?", whereArgs: [phoneNumber]);
    });

    _notifyListeners();
  }

  void _notifyListeners() {
    _onChangedListeners.forEach((listener) => listener());
  }
}

class DuplicateContactPhoneNumberException implements Exception {}

class ContactWithPhoneNumberDoesNotExistException implements Exception {}
