import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseAccess {
  Future<Database> _database;

  DatabaseAccess() : _database = _init();

  static Future<Database> _init() async {
    String path = join(await getDatabasesPath(), "atbash.db");
    return openDatabase(path, version: 1, onCreate: (db, version) {
      return db.execute(
        """
        """,
      );
    });
  }
}
