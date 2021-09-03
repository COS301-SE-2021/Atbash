import 'package:mobile/domain/Chat.dart';
import 'package:mobile/domain/Contact.dart';
import 'package:mobile/domain/Message.dart';
import 'package:mobile/domain/Tag.dart';
import 'package:mobile/encryption/PreKeyDBRecord.dart';
import 'package:mobile/encryption/SessionDBRecord.dart';
import 'package:mobile/encryption/SignedPreKeyDBRecord.dart';
import 'package:mobile/encryption/TrustedKeyDBRecord.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  Future<Database> database;

  DatabaseService() : database = _init();

  static Future<Database> _init() async {
    final dbPath = await getDatabasesPath();
    String path = join(dbPath, "atbash.db");
    return openDatabase(path, version: 12, onCreate: (db, version) async {
      await _createTables(db);
    }, onUpgrade: (db, oldVersion, newVersion) async {
      await _dropTables(db);
      await _createTables(db);
    });
  }

  static Future<void> _dropTables(Database db) async {
    await Future.wait([
      db.execute("drop table if exists ${Chat.TABLE_NAME};"),
      db.execute("drop table if exists ${Message.TABLE_NAME};"),
      db.execute("drop table if exists ${Contact.TABLE_NAME};"),
      db.execute("drop table if exists ${Tag.TABLE_NAME};"),
      db.execute("drop table if exists ${PreKeyDBRecord.TABLE_NAME};"),
      db.execute("drop table if exists ${SessionDBRecord.TABLE_NAME};"),
      db.execute("drop table if exists ${SignedPreKeyDBRecord.TABLE_NAME};"),
      db.execute("drop table if exists ${TrustedKeyDBRecord.TABLE_NAME};"),
      db.execute(
          "drop table if exists ${Message.TABLE_NAME}_${Tag.TABLE_NAME};")
    ]);
  }

  static Future<void> _createTables(Database db) async {
    await Future.wait([
      db.execute(Chat.CREATE_TABLE),
      db.execute(Message.CREATE_TABLE),
      db.execute(Contact.CREATE_TABLE),
      db.execute(Tag.CREATE_TABLE),
      db.execute(PreKeyDBRecord.CREATE_TABLE),
      db.execute(SessionDBRecord.CREATE_TABLE),
      db.execute(SignedPreKeyDBRecord.CREATE_TABLE),
      db.execute(TrustedKeyDBRecord.CREATE_TABLE),
    ]);

    await db.execute("create table ${Message.TABLE_NAME}_${Tag.TABLE_NAME} ("
        "${Message.COLUMN_ID} text not null,"
        "${Tag.COLUMN_ID} text not null"
        ");");
  }
}
