import 'package:mobile/domain/BlockedNumber.dart';
import 'package:mobile/domain/Chat.dart';
import 'package:mobile/domain/Child.dart';
import 'package:mobile/domain/ChildBlockedNumber.dart';
import 'package:mobile/domain/ChildChat.dart';
import 'package:mobile/domain/ChildContact.dart';
import 'package:mobile/domain/ChildMessage.dart';
import 'package:mobile/domain/ChildProfanityWord.dart';
import 'package:mobile/domain/Contact.dart';
import 'package:mobile/domain/Message.dart';
import 'package:mobile/domain/MessagePayload.dart';
import 'package:mobile/domain/MessageResendRequest.dart';
import 'package:mobile/domain/Parent.dart';
import 'package:mobile/domain/ProfanityWord.dart';
import 'package:mobile/domain/StoredProfanityWord.dart';
import 'package:mobile/domain/Tag.dart';
import 'package:mobile/encryption/FailedDecryptionCounter.dart';
import 'package:mobile/encryption/Messagebox.dart';
import 'package:mobile/encryption/MessageboxToken.dart';
import 'package:mobile/encryption/PreKeyDBRecord.dart';
import 'package:mobile/encryption/SessionDBRecord.dart';
import 'package:mobile/encryption/SignedPreKeyDBRecord.dart';
import 'package:mobile/encryption/TrustedKeyDBRecord.dart';
import 'package:mobile/util/RegexGeneration.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

class DatabaseService {
  Future<Database> database;

  DatabaseService() : database = _init();

  static Future<Database> _init() async {
    final dbPath = await getDatabasesPath();
    String path = join(dbPath, "atbash.db");
    return openDatabase(path, version: 45, onCreate: (db, version) async {
      await _createTables(db);
      await _insertProfanityWords(db);
    }, onUpgrade: (db, oldVersion, newVersion) async {
      await _dropTables(db);
      await _createTables(db);
    });
  }

  static Future<void> _dropTables(Database db) async {
    await Future.wait([
      db.execute("drop table if exists ${Child.TABLE_NAME};"),
      db.execute("drop table if exists ${ChildBlockedNumber.TABLE_NAME};"),
      db.execute("drop table if exists ${ChildChat.TABLE_NAME};"),
      db.execute("drop table if exists ${ChildMessage.TABLE_NAME};"),
      db.execute("drop table if exists ${ChildContact.TABLE_NAME};"),
      db.execute("drop table if exists ${ChildProfanityWord.TABLE_NAME};"),
      db.execute("drop table if exists ${Parent.TABLE_NAME};"),
      db.execute("drop table if exists ${Chat.TABLE_NAME};"),
      db.execute("drop table if exists ${Message.TABLE_NAME};"),
      db.execute("drop table if exists ${Contact.TABLE_NAME};"),
      db.execute("drop table if exists ${Tag.TABLE_NAME};"),
      db.execute("drop table if exists ${PreKeyDBRecord.TABLE_NAME};"),
      db.execute("drop table if exists ${SessionDBRecord.TABLE_NAME};"),
      db.execute("drop table if exists ${SignedPreKeyDBRecord.TABLE_NAME};"),
      db.execute("drop table if exists ${TrustedKeyDBRecord.TABLE_NAME};"),
      db.execute(
          "drop table if exists ${Message.TABLE_NAME}_${Tag.TABLE_NAME};"),
      db.execute("drop table if exists ${BlockedNumber.TABLE_NAME};"),
      db.execute("drop table if exists ${MessageboxToken.TABLE_NAME};"),
      db.execute("drop table if exists ${Messagebox.TABLE_NAME};"),
      db.execute("drop table if exists ${ProfanityWord.TABLE_NAME};"),
      db.execute("drop table if exists ${StoredProfanityWord.TABLE_NAME};"),
      db.execute("drop table if exists ${FailedDecryptionCounter.TABLE_NAME};"),
      db.execute("drop table if exists ${MessagePayload.TABLE_NAME};"),
      db.execute("drop table if exists ${MessageResendRequest.TABLE_NAME};"),
    ]);
  }

  static Future<void> _createTables(Database db) async {
    await Future.wait([
      db.execute(Child.CREATE_TABLE),
      db.execute(ChildBlockedNumber.CREATE_TABLE),
      db.execute(ChildChat.CREATE_TABLE),
      db.execute(ChildMessage.CREATE_TABLE),
      db.execute(ChildContact.CREATE_TABLE),
      db.execute(ChildProfanityWord.CREATE_TABLE),
      db.execute(Parent.CREATE_TABLE),
      db.execute(Chat.CREATE_TABLE),
      db.execute(Message.CREATE_TABLE),
      db.execute(Contact.CREATE_TABLE),
      db.execute(Tag.CREATE_TABLE),
      db.execute(PreKeyDBRecord.CREATE_TABLE),
      db.execute(SessionDBRecord.CREATE_TABLE),
      db.execute(SignedPreKeyDBRecord.CREATE_TABLE),
      db.execute(TrustedKeyDBRecord.CREATE_TABLE),
      db.execute(BlockedNumber.CREATE_TABLE),
      db.execute(MessageboxToken.CREATE_TABLE),
      db.execute(Messagebox.CREATE_TABLE),
      db.execute(ProfanityWord.CREATE_TABLE),
      db.execute(StoredProfanityWord.CREATE_TABLE),
      db.execute(FailedDecryptionCounter.CREATE_TABLE),
      db.execute(MessagePayload.CREATE_TABLE),
      db.execute(MessageResendRequest.CREATE_TABLE),
    ]);

    await db.execute("create table ${Message.TABLE_NAME}_${Tag.TABLE_NAME} ("
        "${Message.COLUMN_ID} text not null,"
        "${Tag.COLUMN_ID} text not null"
        ");");
  }

  static Future<void> _insertProfanityWords(Database db) async {
    await Future.wait([
      //pg13
      _generateInsertSQL("shit", "pg13", db),
      _generateInsertSQL("crap", "pg13", db),
      _generateInsertSQL("fuck", "pg13", db),
      _generateInsertSQL("fucked", "pg13", db),
      _generateInsertSQL("fucker", "pg13", db),
      _generateInsertSQL("fucking", "pg13", db),
      _generateInsertSQL("asshole", "pg13", db),
      _generateInsertSQL("asswipe", "pg13", db),
      _generateInsertSQL("bitch", "pg13", db),
      _generateInsertSQL("dickhead", "pg13", db),
      _generateInsertSQL("dick", "pg13", db),
      _generateInsertSQL("ass", "pg13", db),
      _generateInsertSQL("dumbass", "pg13", db),
      _generateInsertSQL("dumbfuck", "pg13", db),
      _generateInsertSQL("slut", "pg13", db),
      _generateInsertSQL("retard", "pg13", db),
      _generateInsertSQL("retarded", "pg13", db),
      _generateInsertSQL("motherfucker", "pg13", db),
      _generateInsertSQL("bullshit", "pg13", db),
      _generateInsertSQL("prick", "pg13", db),
      _generateInsertSQL("skank", "pg13", db),
      _generateInsertSQL("scumbag", "pg13", db),
      _generateInsertSQL("whore", "pg13", db),
      _generateInsertSQL("bastard", "pg13", db),
      _generateInsertSQL("damn", "pg13", db),
      _generateInsertSQL("twat", "pg13", db),
      _generateInsertSQL("wanker", "pg13", db),
      _generateInsertSQL("cunt", "pg13", db),
      //pg16
      _generateInsertSQL("fuck", "pg16", db),
      _generateInsertSQL("fucked", "pg16", db),
      _generateInsertSQL("fucker", "pg16", db),
      _generateInsertSQL("fucking", "pg16", db),
      _generateInsertSQL("dickhead", "pg16", db),
      _generateInsertSQL("dick", "pg16", db),
      _generateInsertSQL("dumbfuck", "pg16", db),
      _generateInsertSQL("slut", "pg16", db),
      _generateInsertSQL("retard", "pg16", db),
      _generateInsertSQL("retarded", "pg16", db),
      _generateInsertSQL("motherfucker", "pg16", db),
      _generateInsertSQL("prick", "pg16", db),
      _generateInsertSQL("skank", "pg16", db),
      _generateInsertSQL("whore", "pg16", db),
      _generateInsertSQL("twat", "pg16", db),
      _generateInsertSQL("cunt", "pg16", db),
      //racial slurs
      _generateInsertSQL("cracker", "racial slurs", db),
      _generateInsertSQL("nigger", "racial slurs", db),
      _generateInsertSQL("redlegs", "racial slurs", db),
      _generateInsertSQL("coon", "racial slurs", db),
      _generateInsertSQL("bluegum", "racial slurs", db),
      _generateInsertSQL("chink", "racial slurs", db),
      _generateInsertSQL("coolie", "racial slurs", db),
      _generateInsertSQL("dink", "racial slurs", db),
      _generateInsertSQL("gringo", "racial slurs", db),
      _generateInsertSQL("gyopo", "racial slurs", db),
      _generateInsertSQL("hairyback", "racial slurs", db),
      _generateInsertSQL("jewboy", "racial slurs", db),
      _generateInsertSQL("kebab", "racial slurs", db),
      _generateInsertSQL("paki", "racial slurs", db),
      _generateInsertSQL("kaffer", "racial slurs", db),
      _generateInsertSQL("abid", "racial slurs", db),
      _generateInsertSQL("abeed", "racial slurs", db),
      _generateInsertSQL("abo", "racial slurs", db),
      _generateInsertSQL("abbo", "racial slurs", db),
      _generateInsertSQL("chinaman", "racial slurs", db),
      _generateInsertSQL("cushi", "racial slurs", db),
      _generateInsertSQL("darky", "racial slurs", db),
      _generateInsertSQL("jap", "racial slurs", db),
      _generateInsertSQL("japa", "racial slurs", db),
      _generateInsertSQL("japie", "racial slurs", db),
      _generateInsertSQL("yarpie", "racial slurs", db),
      _generateInsertSQL("keko", "racial slurs", db),
      _generateInsertSQL("malon", "racial slurs", db),
      _generateInsertSQL("niglet", "racial slurs", db),
      _generateInsertSQL("roundeye", "racial slurs", db),
      _generateInsertSQL("shylock", "racial slurs", db),
      _generateInsertSQL("snowflake", "racial slurs", db),
      _generateInsertSQL("tacohead", "racial slurs", db),
      _generateInsertSQL("tanka", "racial slurs", db),
      _generateInsertSQL("turk", "racial slurs", db),
      //anti-lgbtq slurs
      _generateInsertSQL("queer", "anti-lgbtq slurs", db),
      _generateInsertSQL("fag", "anti-lgbtq slurs", db),
      _generateInsertSQL("faggot", "anti-lgbtq slurs", db),
      _generateInsertSQL("tranny", "anti-lgbtq slurs", db),
      _generateInsertSQL("shemale", "anti-lgbtq slurs", db),
      _generateInsertSQL("homintern", "anti-lgbtq slurs", db),
      _generateInsertSQL("dyke", "anti-lgbtq slurs", db),
      _generateInsertSQL("homo", "anti-lgbtq slurs", db),
      _generateInsertSQL("sod", "anti-lgbtq slurs", db),
      _generateInsertSQL("twink", "anti-lgbtq slurs", db),
      _generateInsertSQL("futanari", "anti-lgbtq slurs", db),
      _generateInsertSQL("lesbo", "anti-lgbtq slurs", db),
      _generateInsertSQL("kiki", "anti-lgbtq slurs", db),
      //sexual words
      _generateInsertSQL("cum", "sexual words", db),
      _generateInsertSQL("cumming", "sexual words", db),
      _generateInsertSQL("cumshot", "sexual words", db),
      _generateInsertSQL("sex", "sexual words", db),
      _generateInsertSQL("seggs", "sexual words", db),
      _generateInsertSQL("anal", "sexual words", db),
      _generateInsertSQL("dick", "sexual words", db),
      _generateInsertSQL("penis", "sexual words", db),
      _generateInsertSQL("cock", "sexual words", db),
      _generateInsertSQL("vagina", "sexual words", db),
      _generateInsertSQL("pussy", "sexual words", db),
      _generateInsertSQL("cunt", "sexual words", db),
      _generateInsertSQL("blowjob", "sexual words", db),
      _generateInsertSQL("bj", "sexual words", db),
      _generateInsertSQL("boobies", "sexual words", db),
      _generateInsertSQL("boobs", "sexual words", db),
      _generateInsertSQL("titties", "sexual words", db),
      _generateInsertSQL("dildo", "sexual words", db),
      _generateInsertSQL("deepthroat", "sexual words", db),
      _generateInsertSQL("cunnilingus", "sexual words", db),
      _generateInsertSQL("slut", "sexual words", db),
      _generateInsertSQL("fingering", "sexual words", db),
      _generateInsertSQL("fingerfuck", "sexual words", db),
      _generateInsertSQL("fist", "sexual words", db),
      _generateInsertSQL("fisting", "sexual words", db),
      _generateInsertSQL("threesome", "sexual words", db),
      _generateInsertSQL("foursome", "sexual words", db),
      _generateInsertSQL("goldenshower", "sexual words", db),
      _generateInsertSQL("quickie", "sexual words", db),
      //religious slurs
      _generateInsertSQL("jewboy", "religious slurs", db),
      _generateInsertSQL("chuhra", "religious slurs", db),
      _generateInsertSQL("fundie", "religious slurs", db),
      _generateInsertSQL("kike", "religious slurs", db),
      _generateInsertSQL("raghead", "religious slurs", db),
      _generateInsertSQL("kadrun", "religious slurs", db),
      _generateInsertSQL("dothead", "religious slurs", db),
      _generateInsertSQL("shiksa", "religious slurs", db),
      _generateInsertSQL("shegetz", "religious slurs", db),
      _generateInsertSQL("heathen", "religious slurs", db),
      _generateInsertSQL("osama", "religious slurs", db),
      _generateInsertSQL("mick", "religious slurs", db),
      _generateInsertSQL("saai", "religious slurs", db),
      _generateInsertSQL("terrorist", "religious slurs", db),
    ]);
  }

  static Future<void> _generateInsertSQL(
      String word, String package, Database db) async {
    db.execute(
        "INSERT INTO ${StoredProfanityWord.TABLE_NAME} VALUES (?,?,?,?,?,?);",
        [Uuid().v4(), package, word, generateRegex(word), 0, 1]);
  }
}
