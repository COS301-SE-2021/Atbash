import 'package:get_it/get_it.dart';
import 'package:mobile/domain/Contact.dart';
import 'package:mobile/services/ContactService.dart';
import 'package:mobx/mobx.dart';

part 'ContactListModel.g.dart';

class ContactListModel = _ContactListModel with _$ContactListModel;

abstract class _ContactListModel with Store {
  @observable
  ObservableList<Contact> contacts = <Contact>[].asObservable();

  final ContactService _contactService = GetIt.I.get();

  @action
  void init() {
    _contactService.fetchAll().then((contactList) {
      contacts = contactList.asObservable();
    });
  }

  @action
  Future<void> addContact(String phoneNumber, String displayName) async {
    final contact = Contact(
      phoneNumber: phoneNumber,
      displayName: displayName,
      status: "",
      profileImage: "",
    );

    try {
      await _contactService.insert(contact);
    } on DuplicateContactPhoneNumberException {
      rethrow;
    }

    contacts.add(contact);
  }

  @action
  void deleteContact(String phoneNumber) {
    _contactService.deleteByPhoneNumber(phoneNumber);

    contacts.removeWhere((element) => element.phoneNumber == phoneNumber);
  }

  @action
  void setContactBirthday(String phoneNumber, DateTime birthday) {
    final contact =
        contacts.firstWhere((element) => element.phoneNumber == phoneNumber);

    contact.birthday = birthday;

    _contactService.update(contact);
  }

  @action
  void setContactDisplayName(String phoneNumber, String displayName) {
    final contact =
        contacts.firstWhere((element) => element.phoneNumber == phoneNumber);

    contact.displayName = displayName;

    _contactService.update(contact);
  }

  @action
  void setContactStatus(String phoneNumber, String status) {
    final contact =
        contacts.firstWhere((element) => element.phoneNumber == phoneNumber);

    contact.status = status;

    _contactService.update(contact);
  }

  @action
  void setContactProfilePicture(
      String phoneNumber, String profilePictureBase64) {
    final contact =
        contacts.firstWhere((element) => element.phoneNumber == phoneNumber);

    contact.profileImage = profilePictureBase64;

    _contactService.update(contact);
  }
}
