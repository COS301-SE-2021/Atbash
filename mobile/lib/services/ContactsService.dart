import 'package:mobile/domain/Contact.dart';
import 'package:mobile/services/DatabaseService.dart';

class ContactsService {
  final DatabaseService _databaseService;
  List<void Function()> _onContactsChangedListeners = [];

  ContactsService(this._databaseService);

  /// Add a contact, saves to the database. Notifies listeners that contacts
  /// have changed.
  void addContact(String phoneNumber, String displayName, bool hasChat) {
    throw UnimplementedError();
  }

  /// Returns a list of all the user's contacts
  Future<List<Contact>> getAllContacts() {
    return _databaseService.fetchContacts();
  }

  /// Returns a list of all the user's contacts where there is a chat with the
  /// contact
  Future<List<Contact>> getAllChats() {
    return _databaseService.fetchContactsWithChats();
  }

  /// Starts a chat with the contact by setting the flag that there is a chat
  /// with the contact. Notifies listeners that contacts have changed.
  void startChatWithContact(String phoneNumber) {
    throw UnimplementedError();
  }

  /// Adds [fn] as a callback to the callback list
  void onContactsChanged(void Function() fn) {
    _onContactsChangedListeners.add(fn);
  }

  /// Removes callback [fn] from the callback list.
  void disposeContactsChangedListener(void Function() fn) {
    throw UnimplementedError();
  }
}
