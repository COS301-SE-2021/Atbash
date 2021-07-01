import 'package:mobile/domain/Contact.dart';
import 'package:mobile/domain/Message.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseAccess {
  Future<Database> _database;

  DatabaseAccess() : _database = _init();

  static Future<Database> _init() async {
    String path = join(await getDatabasesPath(), "atbash.db");
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute(Message.CREATE_TABLE);
        db.execute(Contact.CREATE_TABLE);
      },
    );
  }

  Message saveMessage(String from, String to, String contents) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    Message message = new Message(
        from, to, contents, DateTime.fromMillisecondsSinceEpoch(timestamp));
    _database.then((db) {
      db.insert("message", message.toMap());
    });
    return message;
  }

  void deleteMessage(String id) {
    _database
        .then((db) => db.delete("message", where: "id = ?", whereArgs: [id]));
  }

  Future<List<Message>> getChatWithContact(String phoneNumber) async {
    final db = await _database;
    List<Message> messages = [];

    final response = await db.query("message",
        where: "number_from = ? OR number_to = ?",
        whereArgs: [phoneNumber, phoneNumber]);

    response.forEach((element) {
      final message = Message.fromMap(element);
      if (message != null) {
        messages.add(message);
      }
    });

    return messages;
  }

  Future<Contact?> fetchContact(String number) async {
    final db = await _database;
    final response = await db
        .query("contact", where: "phone_number = ?", whereArgs: [number]);

    if (response.isNotEmpty) {
      return Contact.fromMap(response.first);
    }

    return null;
  }

  Contact saveContact(String number, String displayName) {
    Contact contact = new Contact(number, displayName, false);
    _database.then((db) {
      db.insert("contact", contact.toMap());
    });
    return contact;
  }

  Future<List<Contact>> getContacts() async {
    final db = await _database;
    List<Contact> contacts = [];
    final response = await db.query("contact", distinct: true);

    response.forEach((element) {
      final contact = Contact.fromMap(element);
      if (contact != null) {
        contacts.add(contact);
      }
    });

    return contacts;
  }

  Future<List<Contact>> getContactsWithChats() async {
    final db = await _database;
    List<Contact> contacts = [];
    final response = await db.query("contact",
        distinct: true, where: "has_chat = ?", whereArgs: [1]);

    response.forEach((element) {
      final contact = Contact.fromMap(element);
      if (contact != null) {
        contacts.add(contact);
      }
    });

    return contacts;
  }

  Future<bool> createChatWithContact(String number) async {
    final db = await _database;
    int numChanges = await db.rawUpdate("""
      UPDATE contact
      SET has_chat = 1
      WHERE phone_number = ?;
      """, [number]);

    if (numChanges == 0) return false;

    return true;
  }
}
