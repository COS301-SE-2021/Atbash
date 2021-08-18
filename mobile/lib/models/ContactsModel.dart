import 'package:http/http.dart';
import 'package:mobile/domain/Contact.dart';
import 'package:mobile/exceptions/DuplicateContactNumberException.dart';
import 'package:mobile/services/DatabaseService.dart';
import 'package:mobile/services/KeyGenService.dart';
import 'package:mobile/services/responses/DatabaseServiceResponses.dart';
import 'package:mobx/mobx.dart';

part 'ContactsModel.g.dart';

class ContactsModel = ContactsModelBase with _$ContactsModel;

abstract class ContactsModelBase with Store {
  final DatabaseService _databaseService;
  final KeyGenService _keyGenService;

  ContactsModelBase(this._databaseService, this._keyGenService);

  @observable
  ObservableList<Contact> contacts = <Contact>[].asObservable();

  @observable
  String filter = "";

  @computed
  ObservableList<Contact> get chatContacts =>
      ObservableList.of(contacts.where((c) => c.hasChat));

  @computed
  ObservableList<Contact> get savedContacts =>
      ObservableList.of(contacts.where((c) => c.saved));

  @computed
  ObservableList<Contact> get filteredChatContacts {
    if (filter.isNotEmpty) {
      return ObservableList.of(
        chatContacts.where((c) =>
            c.displayName.toLowerCase().contains(filter.toLowerCase()) ||
            c.phoneNumber.contains(filter)),
      );
    } else {
      return chatContacts;
    }
  }

  @computed
  ObservableList<Contact> get filteredSavedContacts {
    if (filter.isNotEmpty) {
      return ObservableList.of(savedContacts.where(
        (c) =>
            c.displayName.toLowerCase().contains(filter.toLowerCase()) ||
            c.phoneNumber.contains(filter),
      ));
    } else {
      return savedContacts;
    }
  }

  @action
  Future<void> addContact(
    String phoneNumber,
    String displayName,
    bool hasChat,
    bool save,
  ) async {
    final response = await _databaseService.createContact(
      phoneNumber,
      displayName,
      "",
      "",
      hasChat,
      save,
    );

    final status = response.status;
    final contact = response.contact;

    if (status == CreateContactResponseStatus.SUCCESS) {
      if (contact == null) {
        throw StateError("Contact was null when status was success");
      } else {
        final encodedPhoneNumber = Uri.encodeQueryComponent(phoneNumber);
        final rsaResponse = await get(Uri.parse(
            "https://bjarhthz5j.execute-api.af-south-1.amazonaws.com/dev/user/$encodedPhoneNumber/rsa-public-key"));

        var key = "";

        if (rsaResponse.statusCode == 200) {
          print("${rsaResponse.statusCode} - ${rsaResponse.body}");
          key = await _keyGenService.generateSharedSecret(rsaResponse.body);
          await _databaseService.setContactSymmetricKey(phoneNumber, key);
        } else {
          print("${rsaResponse.statusCode} - ${rsaResponse.body}");
        }

        contact.symmetricKey = key;
        contacts.add(contact);
        contacts.sort((a, b) => a.displayName.compareTo(b.displayName));
      }
    } else if (status == CreateContactResponseStatus.UPDATED) {
      if (contact == null) {
        throw StateError("Contact was null when status was updated");
      } else {
        final index = contacts.indexWhere((c) => c.phoneNumber == phoneNumber);
        final listContact = contacts.removeAt(index);
        listContact.displayName = contact.displayName;
        listContact.saved = true;
        contacts.insert(index, listContact);

        contacts.sort((a, b) => a.displayName.compareTo(b.displayName));
      }
    } else if (status == CreateContactResponseStatus.DUPLICATE_NUMBER) {
      throw DuplicateContactNumberException();
    } else {
      throw Exception();
    }
  }

  @action
  void startChatWithContact(String phoneNumber) {
    final index = contacts.indexWhere((c) => c.phoneNumber == phoneNumber);
    final contact = contacts.removeAt(index);
    contact.hasChat = true;
    contacts.insert(index, contact);

    _databaseService.startChatWithContact(phoneNumber);
  }

  @action
  void setContactProfileImage(String phoneNumber, String base64Image) {
    final index = contacts.indexWhere((c) => c.phoneNumber == phoneNumber);
    final contact = contacts.removeAt(index);
    contact.profileImage = base64Image;
    contacts.insert(index, contact);

    _databaseService.updateContactProfileImage(phoneNumber, base64Image);
  }

  @action
  void setContactStatus(String phoneNumber, String status) {
    final index = contacts.indexWhere((c) => c.phoneNumber == phoneNumber);
    final contact = contacts.removeAt(index);
    contact.status = status;
    contacts.insert(index, contact);

    _databaseService.updateContactStatus(phoneNumber, status);
  }

  @action
  void setContactDisplayName(String phoneNumber, String displayName) {
    final index = contacts.indexWhere((c) => c.phoneNumber == phoneNumber);
    final contact = contacts.removeAt(index);
    contact.displayName = displayName;
    contacts.insert(index, contact);

    _databaseService.updateContactDisplayName(phoneNumber, displayName);
  }

  @action
  void deleteChatsWithContacts(List<String> phoneNumbers) {
    phoneNumbers.forEach((phoneNumber) {
      final index = contacts.indexWhere((c) => c.phoneNumber == phoneNumber);
      final contact = contacts.removeAt(index);
      contact.hasChat = false;
      contacts.insert(index, contact);
      _databaseService.setContactHasChat(phoneNumber, false);

      _databaseService.deleteMessagesWithContact(phoneNumber);
    });
  }

  @action
  void deleteContacts(List<String> phoneNumbers) {
    phoneNumbers.forEach((phoneNumber) {
      contacts.removeWhere((c) => c.phoneNumber == phoneNumber);

      _databaseService.deleteMessagesWithContact(phoneNumber);
      _databaseService.deleteContact(phoneNumber);
    });
  }

  @action
  Future<void> initialise() async {
    final contacts = await _databaseService.fetchContacts();
    this.contacts.addAll(contacts);
  }
}
