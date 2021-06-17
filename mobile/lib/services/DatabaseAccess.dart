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
    _database.then((db) {});
    return Message("", from, to, contents);
  }

  Future<List<Message>> getChatWithContact(String phoneNumber) async {
    final db = await _database;

    return [];
  }

  Future<Contact?> fetchContact(String number) async {
    final db = await _database;
    return null;
  }

  Contact saveContact(String number, String displayName) {
    _database.then((db) {});
    return Contact(number, displayName, false);
  }

  Future<List<Contact>> getContacts() async {
    final db = await _database;
    return [];
  }

  Future<List<Contact>> getContactsWithChats() async {
    final db = await _database;
    return [];
  }
}
