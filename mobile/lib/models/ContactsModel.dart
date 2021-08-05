import 'package:mobile/domain/Contact.dart';
import 'package:mobile/exceptions/DuplicateContactNumberException.dart';
import 'package:mobile/services/DatabaseService.dart';
import 'package:mobile/services/responses/DatabaseServiceResponses.dart';
import 'package:mobx/mobx.dart';

part 'ContactsModel.g.dart';

class ContactsModel = ContactsModelBase with _$ContactsModel;

abstract class ContactsModelBase with Store {
  final DatabaseService _databaseService;

  ContactsModelBase(this._databaseService);

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
        contacts.add(contact);
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
    // TODO Should just be one line
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
  void deleteChatsWithContacts(List<String> phoneNumbers) {
    phoneNumbers.forEach((phoneNumber) {
      final index = contacts.indexWhere((c) => c.phoneNumber == phoneNumber);
      final contact = contacts.removeAt(index);
      contact.hasChat = false;
      contacts.insert(index, contact);
      _databaseService.markContactNoChat(phoneNumber);

      _databaseService.deleteMessagesWithContact(phoneNumber);
    });
  }

  @action
  Future<void> initialise() async {
    final contacts = await _databaseService.fetchContacts();
    this.contacts.addAll(contacts);
  }
}
