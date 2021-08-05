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
  Future<void> initialise() async {
    final contacts = await _databaseService.fetchContacts();
    this.contacts.addAll(contacts);
  }
}
