import 'package:mobile/domain/Contact.dart';
import 'package:mobile/domain/Message.dart';

class DatabaseService {
  /// Fetches a list of all contacts from the database, ordered by display name.
  Future<List<Contact>> fetchContacts() async {
    throw UnimplementedError();
  }

  /// Fetches a list of all contacts that are flagged as having a chat from the
  /// database, ordered by display name.
  Future<List<Contact>> fetchContactsWithChats() async {
    throw UnimplementedError();
  }

  /// Creates and saves a contact in the database. Returns null if attempted
  /// save caused some key or constraint violation.
  Future<Contact?> createContact(
    String phoneNumber,
    String displayName,
    bool hasChat,
  ) async {
    throw UnimplementedError();
  }

  /// Flags contact with phone number [phoneNumber] as having a chat.
  Future<void> startChatWithContact(String phoneNumber) async {
    throw UnimplementedError();
  }

  /// Fetches all messages from a contact with phone number [phoneNumber],
  /// ordered by timestamp.
  Future<List<Message>> fetchMessagesWith(String phoneNumber) async {
    throw UnimplementedError();
  }

  /// Saves a message in the database and returns.
  Message saveMessage(
    String senderPhoneNumber,
    String recipientPhoneNumber,
    String contents,
  ) {
    throw UnimplementedError();
  }
}
