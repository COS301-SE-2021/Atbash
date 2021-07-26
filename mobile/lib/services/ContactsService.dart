import 'package:mobile/domain/Contact.dart';
import 'package:mobile/services/DatabaseService.dart';
import 'package:mobile/services/responses/ContactsServiceResponses.dart';
import 'package:mobile/services/responses/DatabaseServiceResponses.dart';

class ContactsService {
  final DatabaseService _databaseService;
  List<void Function()> _onContactsChangedListeners = [];

  ContactsService(this._databaseService);

  /// Add a contact, saves to the database. Notifies listeners that contacts
  /// have changed.
  Future<AddContactResponse> addContact(
    String phoneNumber,
    String displayName,
    bool hasChat,
    bool save,
  ) async {
    final response = await _databaseService.createContact(
      phoneNumber,
      displayName,
      hasChat,
      save,
    );

    switch (response.status) {
      case CreateContactResponseStatus.SUCCESS:
        if (response.contact == null) {
          throw StateError(
              "DatabaseService::createContact returned success status with null contact");
        } else {
          _notifyOnContactsChangedListeners();

          return AddContactResponse(
            AddContactResponseStatus.SUCCESS,
            response.contact,
          );
        }

      case CreateContactResponseStatus.DUPLICATE_NUMBER:
        return AddContactResponse(
          AddContactResponseStatus.DUPLICATE_NUMBER,
          null,
        );

      case CreateContactResponseStatus.GENERAL_ERROR:
        return AddContactResponse(
          AddContactResponseStatus.GENERAL_ERROR,
          null,
        );
    }
  }

  /// Returns a list of all the user's contacts
  Future<List<Contact>> getAllContacts() {
    return _databaseService.fetchContacts();
  }

  /// Returns a list of all the user's saved contacts
  Future<List<Contact>> getAllSavedContacts() {
    return _databaseService.fetchSavedContacts();
  }

  /// Returns a list of all the user's contacts where there is a chat with the
  /// contact
  Future<List<Contact>> getAllChats() {
    return _databaseService.fetchContactsWithChats();
  }

  /// Starts a chat with the contact by setting the flag that there is a chat
  /// with the contact. Notifies listeners that contacts have changed.
  void startChatWithContact(String phoneNumber) {
    _databaseService.startChatWithContact(phoneNumber);
    _notifyOnContactsChangedListeners();
  }

  /// Deletes the chat with specified contact. Deletes all messages, and marks contact's [hasChat] as false
  void deleteChatsWithContacts(List<String> phoneNumbers) {
    List<Future<dynamic>> futures = [];
    phoneNumbers.forEach((phoneNumber) {
      futures.add(_databaseService.markContactNoChat(phoneNumber));
      futures.add(_databaseService.deleteMessagesWithContact(phoneNumber));
    });
    Future.wait(futures).then((value) => _notifyOnContactsChangedListeners());
  }

  /// Adds [fn] as a callback to the callback list
  void onContactsChanged(void Function() fn) {
    _onContactsChangedListeners.add(fn);
  }

  /// Removes callback [fn] from the callback list.
  void disposeContactsChangedListener(void Function() fn) {
    _onContactsChangedListeners.remove(fn);
  }

  void _notifyOnContactsChangedListeners() {
    _onContactsChangedListeners.forEach((element) => element());
  }
}
