import 'package:mobile/domain/Contact.dart';
import 'package:mobile/domain/Message.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  Future<Database> _database;

  DatabaseService() : _database = _init();

  static Future<Database> _init() async {
    final dbPath = await getDatabasesPath();
    String path = join(dbPath, "atbash.db");
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute(Contact.CREATE_TABLE);
        db.execute(Message.CREATE_TABLE);
      },
    );
  }

  /// Fetches the name of the contact with phone number [phoneNumber]. Returns
  /// null if contact is not in the database.
  Future<String?> fetchContactNameByPhoneNumber(String phoneNumber) async {
    final db = await _database;
    final response = await db.rawQuery(
      "select ${Contact.COLUMN_DISPLAY_NAME} from ${Contact.TABLE_NAME} where ${Contact.COLUMN_PHONE_NUMBER} = ?",
      [phoneNumber],
    );

    if (response.isNotEmpty) {
      return response[0][Contact.COLUMN_DISPLAY_NAME] as String;
    } else {
      return null;
    }
  }

  /// Fetches a list of all contacts from the database, ordered by display name.
  Future<List<Contact>> fetchContacts() async {
    final db = await _database;
    final response = await db.query(
      Contact.TABLE_NAME,
      orderBy: "${Contact.COLUMN_DISPLAY_NAME} asc",
    );
    final list = <Contact>[];
    response.forEach((element) {
      final contact = Contact.fromMap(element);
      if (contact != null) {
        list.add(contact);
      }
    });
    return list;
  }

  /// Fetches a list of all contacts that are flagged as having a chat from the
  /// database, ordered by display name.
  Future<List<Contact>> fetchContactsWithChats() async {
    final db = await _database;
    final response = await db.query(
      Contact.TABLE_NAME,
      where: "${Contact.COLUMN_HAS_CHAT} = ?",
      whereArgs: [1],
      orderBy: "${Contact.COLUMN_DISPLAY_NAME} asc",
    );

    final list = <Contact>[];

    response.forEach((element) {
      final contact = Contact.fromMap(element);
      if (contact != null) {
        list.add(contact);
      }
    });

    return list;
  }

  /// Creates and saves a contact in the database. Returns null if attempted
  /// save caused some key or constraint violation.
  Future<Contact?> createContact(
    String phoneNumber,
    String displayName,
    bool hasChat,
  ) async {
    final db = await _database;
    final contact = Contact(phoneNumber, displayName, hasChat);

    final response = await db.insert(Contact.TABLE_NAME, contact.toMap());
    if (response != 0) {
      return contact;
    } else {
      return null;
    }
  }

  /// Flags contact with phone number [phoneNumber] as having a chat.
  Future<void> startChatWithContact(String phoneNumber) async {
    final db = await _database;
    db.rawUpdate(
      "update contact set ${Contact.COLUMN_HAS_CHAT}=1 where ${Contact.COLUMN_PHONE_NUMBER}=?",
      [phoneNumber],
    );
  }

  /// Fetches all messages from a contact with phone number [phoneNumber],
  /// ordered by timestamp.
  Future<List<Message>> fetchMessagesWith(String phoneNumber) async {
    final db = await _database;
    final response = await db.query(
      Message.TABLE_NAME,
      where:
          "${Message.COLUMN_RECIPIENT_PHONE_NUMBER} = ? or ${Message.COLUMN_SENDER_PHONE_NUMBER} = ?",
      whereArgs: [phoneNumber, phoneNumber],
    );

    final list = <Message>[];

    response.forEach((element) {
      final message = Message.fromMap(element);
      if (message != null) {
        list.add(message);
      }
    });

    return list;
  }

  /// Saves a message in the database and returns.
  Message saveMessage(
    String senderPhoneNumber,
    String recipientPhoneNumber,
    String contents,
  ) {
    final message = Message(
      senderPhoneNumber,
      recipientPhoneNumber,
      contents,
      DateTime.now(),
    );

    _database.then((db) {
      db.insert(Message.TABLE_NAME, message.toMap());
    });

    return message;
  }
}
