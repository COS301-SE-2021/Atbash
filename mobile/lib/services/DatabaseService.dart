import 'package:mobile/domain/Contact.dart';
import 'package:mobile/domain/Message.dart';
import 'package:mobile/services/responses/DatabaseServiceResponses.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

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

  /// Fetches a list of all contacts with 'saved' being true, ordered by display name.
  Future<List<Contact>> fetchSavedContacts() async {
    final db = await _database;
    final response = await db.query(
      Contact.TABLE_NAME,
      orderBy: "${Contact.COLUMN_DISPLAY_NAME} asc",
      where: "${Contact.COLUMN_SAVED} = 1",
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

  /// Fetches a contact by the phone number, or null if does not exist
  Future<Contact?> fetchContactByNumber(String number) async {
    final db = await _database;
    final response = await db.query(
      Contact.TABLE_NAME,
      where: "${Contact.COLUMN_PHONE_NUMBER} = ?",
      whereArgs: [number],
    );

    if (response.isNotEmpty) {
      final contact = Contact.fromMap(response[0]);
      return contact;
    } else {
      return null;
    }
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

  Future<List<Message>> fetchUnseenMessagesWith(
      String senderPhoneNumber) async {
    final db = await _database;
    final response = await db.query(
      Message.TABLE_NAME,
      where:
          "${Message.COLUMN_READ_RECEIPT} = ? and ${Message.COLUMN_SENDER_PHONE_NUMBER} = ?",
      whereArgs: [ReadReceipt.seen.toString(), senderPhoneNumber],
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

  /// Creates and saves a contact in the database. Returns null if attempted
  /// save caused some key or constraint violation.
  Future<CreateContactResponse> createContact(
    String phoneNumber,
    String displayName,
    String status,
    String profileImage,
    bool hasChat,
    bool save,
  ) async {
    final db = await _database;

    final existingContact = await fetchContactByNumber(phoneNumber);

    if (existingContact == null) {
      final contact = Contact(
          phoneNumber, displayName, status, profileImage, hasChat, save);

      try {
        final response = await db.insert(Contact.TABLE_NAME, contact.toMap());
        if (response != 0) {
          return CreateContactResponse(
            CreateContactResponseStatus.SUCCESS,
            contact,
          );
        } else {
          return CreateContactResponse(
            CreateContactResponseStatus.GENERAL_ERROR,
            null,
          );
        }
      } catch (exception) {
        print(exception);
        return CreateContactResponse(
          CreateContactResponseStatus.GENERAL_ERROR,
          null,
        );
      }
    } else if (existingContact.saved == false) {
      existingContact.displayName = displayName;
      existingContact.saved = save;

      try {
        final response = await db.update(
          Contact.TABLE_NAME,
          existingContact.toMap(),
          where: "${Contact.COLUMN_PHONE_NUMBER} = ?",
          whereArgs: [phoneNumber],
        );

        if (response != 0) {
          return CreateContactResponse(
            CreateContactResponseStatus.UPDATED,
            existingContact,
          );
        } else {
          return CreateContactResponse(
            CreateContactResponseStatus.GENERAL_ERROR,
            null,
          );
        }
      } catch (exception) {
        print(exception);
        return CreateContactResponse(
          CreateContactResponseStatus.GENERAL_ERROR,
          null,
        );
      }
    } else {
      return CreateContactResponse(
        CreateContactResponseStatus.DUPLICATE_NUMBER,
        null,
      );
    }
  }

  /// Flags contact with phone number [phoneNumber] as having a chat.
  Future<void> startChatWithContact(String phoneNumber) async {
    final db = await _database;
    await db.rawUpdate(
      "update ${Contact.TABLE_NAME} set ${Contact.COLUMN_HAS_CHAT}=1 where ${Contact.COLUMN_PHONE_NUMBER}=?",
      [phoneNumber],
    );
  }

  /// Marks a contact's [hasChat] as false
  Future<void> setContactHasChat(String phoneNumber, bool hasChat) async {
    final db = await _database;
    await db.rawUpdate(
        "update ${Contact.TABLE_NAME} set ${Contact.COLUMN_HAS_CHAT} = ? where ${Contact.COLUMN_PHONE_NUMBER} = ?",
        [hasChat ? 1 : 0, phoneNumber]);
  }

  Future<void> updateContactProfileImage(
    String phoneNumber,
    String base64Image,
  ) async {
    final db = await _database;
    await db.rawUpdate(
      "update ${Contact.TABLE_NAME} set ${Contact.COLUMN_PROFILE_IMAGE} = ? where ${Contact.COLUMN_PHONE_NUMBER} = ?",
      [base64Image, phoneNumber],
    );
  }

  Future<void> updateContactStatus(
    String phoneNumber,
    String status,
  ) async {
    final db = await _database;
    await db.rawUpdate(
      "update ${Contact.TABLE_NAME} set ${Contact.COLUMN_STATUS} = ? where ${Contact.COLUMN_PHONE_NUMBER} = ?",
      [status, phoneNumber],
    );
  }

  Future<bool> messageWithIdExists(String id) async {
    final db = await _database;
    final response = await db.rawQuery(
      "select ${Message.COLUMN_ID} from ${Message.TABLE_NAME} where ${Message.COLUMN_ID} = ?",
      [id],
    );

    return response.length > 0;
  }

  /// Fetches all messages from a contact with phone number [phoneNumber],
  /// ordered by timestamp.
  Future<List<Message>> fetchMessagesWith(String phoneNumber, int page) async {
    const pageSize = 25;

    final db = await _database;
    final response = await db.query(Message.TABLE_NAME,
        where:
            "${Message.COLUMN_RECIPIENT_PHONE_NUMBER} = ? or ${Message.COLUMN_SENDER_PHONE_NUMBER} = ?",
        whereArgs: [phoneNumber, phoneNumber],
        limit: pageSize,
        offset: pageSize * page,
        orderBy: "${Message.COLUMN_TIMESTAMP} desc");

    final list = <Message>[];

    response.forEach((element) {
      final message = Message.fromMap(element);
      if (message != null) {
        list.add(message);
      }
    });

    return list;
  }

  Future<void> deleteContact(String phoneNumber) async {
    final db = await _database;
    await db.delete(
      Contact.TABLE_NAME,
      where: "${Contact.COLUMN_PHONE_NUMBER} = ?",
      whereArgs: [phoneNumber],
    );
  }

  /// Deletes all messages with a contact
  Future<void> deleteMessagesWithContact(String phoneNumber) async {
    final db = await _database;
    await db.delete(Message.TABLE_NAME,
        where:
            "${Message.COLUMN_RECIPIENT_PHONE_NUMBER} = ? or ${Message.COLUMN_SENDER_PHONE_NUMBER} = ?",
        whereArgs: [phoneNumber, phoneNumber]);
  }

  Future<void> deleteMessages(List<String> ids) async {
    final db = await _database;
    String where = "(" + ids.map((e) => "?").join(", ") + ")";
    await db.delete(
      Message.TABLE_NAME,
      where: "${Message.COLUMN_ID} in $where",
      whereArgs: ids,
    );
  }

  Future<void> markMessagesDeleted(
    String contactPhoneNumber,
    List<String> ids,
  ) async {
    final db = await _database;
    String where = "(" + ids.map((e) => "?").join(", ") + ")";

    await db.rawUpdate(
      "update ${Message.TABLE_NAME} set contents = '', deleted = 1 where ${Message.COLUMN_SENDER_PHONE_NUMBER} = ? and ${Message.COLUMN_ID} in $where",
      [contactPhoneNumber, ...ids],
    );
  }

  /// Saves a message in the database and returns.
  Message saveMessage(
      String senderPhoneNumber, String recipientPhoneNumber, String contents,
      {String? id, int? timestamp}) {
    final message = Message(
      id == null ? Uuid().v4() : id,
      senderPhoneNumber,
      recipientPhoneNumber,
      contents,
      timestamp == null
          ? DateTime.now()
          : DateTime.fromMillisecondsSinceEpoch(timestamp),
      ReadReceipt.undelivered,
      false,
    );

    _database.then((db) {
      db.insert(Message.TABLE_NAME, message.toMap());
    });

    return message;
  }

  void markMessageDelivered(String id) async {
    final db = await _database;
    await db.rawUpdate(
      "update ${Message.TABLE_NAME} set ${Message.COLUMN_READ_RECEIPT} = ? where ${Message.COLUMN_ID} = ?",
      [ReadReceipt.delivered.toString(), id],
    );
  }

  void markMessagesSeen(List<String> ids) async {
    final db = await _database;
    String where = "(" + ids.map((e) => "?").join(", ") + ")";
    await db.rawUpdate(
      "update ${Message.TABLE_NAME} set ${Message.COLUMN_READ_RECEIPT} = ? where ${Message.COLUMN_ID} in $where",
      [ReadReceipt.seen.toString(), ...ids],
    );
  }
}
