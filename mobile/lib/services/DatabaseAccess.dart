import 'package:mobile/domain/Contact.dart';
import 'package:mobile/domain/Message.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

class DatabaseAccess {
  Future<Database> _database;

  DatabaseAccess() : _database = _init();

  static Future<Database> _init() async {
    String path = join(await getDatabasesPath(), "atbash.db");
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute(
          """
          create table message (
            id text primary key,
            number_from text not null,
            number_to text not null,
            contents text not null
          );   
          """,
        );

        db.execute(
          """
          create table contact (
            phone_number text primary key,
            display_name text not null,
            has_chat tinyint not null
          );
          """,
        ).then((value) {
          db.execute(
            """
            insert into contact
            values
              ('011 123 1234', 'Liam', 1), 
              ('021 123 4567', 'Connor', 1), 
              ('031 456 1235', 'Josh', 0), 
              ('041 456 4567', 'Targo', 0)
            ;
            """,
          );
        });
      },
    );
  }

  Message saveMessage(String from, String to, String contents) {
    Uuid uuid = new Uuid();
    String randomID = uuid.v4();
    Message message = new Message(randomID, from, to, contents);
    _database.then((db) {
      db.insert("message", message.toMap());
    });
    return message;
  }

  Future<List<Message>> getChatWithContact(String phoneNumber) async {
    final db = await _database;
    List<Message> messages = [];

    final response = await db.query("message",
        where: "number_from = ? OR number_to = ?",
        whereArgs: [phoneNumber, phoneNumber]);

    response.forEach((element) {
      messages.add(Message.fromMap(element));
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
      contacts.add(Contact.fromMap(element));
    });

    return contacts;
  }

  Future<List<Contact>> getContactsWithChats() async {
    final db = await _database;
    List<Contact> contacts = [];
    final response = await db.query("contact",
        distinct: true, where: "has_chat = ?", whereArgs: [1]);

    response.forEach((element) {
      contacts.add(Contact.fromMap(element));
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
