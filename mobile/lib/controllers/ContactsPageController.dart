import 'package:get_it/get_it.dart';
import 'package:mobile/domain/Contact.dart';
import 'package:mobile/models/ContactsPageModel.dart';
import 'package:mobile/services/ContactService.dart';

class ContactsPageController {
  final ContactService contactService = GetIt.I.get();

  final ContactsPageModel model = ContactsPageModel();

  ContactsPageController() {
    contactService.fetchAll().then((contactList) {
      model.replaceContacts(contactList);
    });
  }

  void deleteContact(String phoneNumber) {
    model.removeContact(phoneNumber);
    contactService.deleteByPhoneNumber(phoneNumber);
  }

  void addContact(Contact contact) {
    model.addContact(contact);
    contactService.insert(contact);
  }
}
