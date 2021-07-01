import 'package:mobile/domain/Contact.dart';

class ContactsService {
  /// Add a contact, saves to the database. Notifies listeners that contacts
  /// have changed.
  void addContact(String phoneNumber, String displayName, bool hasChat) {
    throw UnimplementedError();
  }

  /// Returns a list of all the user's contacts
  Future<List<Contact>> getAllContacts() {
    throw UnimplementedError();
  }

  /// Returns a list of all the user's contacts where there is a chat with the
  /// contact
  Future<List<Contact>> getAllChats() {
    throw UnimplementedError();
  }

  /// Starts a chat with the contact by setting the flag that there is a chat
  /// with the contact. Notifies listeners that contacts have changed.
  void startChatWithContact(String phoneNumber) {
    throw UnimplementedError();
  }

  /// Adds [fn] as a callback to the callback map. Returns the generated map key
  /// for this callback.
  String onContactsChanged(void Function() fn) {
    throw UnimplementedError();
  }

  /// Removes callback with id [callbackId] from the callback map.
  void disposeContactsChangedListener(String callbackId) {
    throw UnimplementedError();
  }
}
