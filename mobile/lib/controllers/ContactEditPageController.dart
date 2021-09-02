import 'package:get_it/get_it.dart';
import 'package:mobile/domain/Contact.dart';
import 'package:mobile/models/ContactEditPageModel.dart';
import 'package:mobile/services/ContactService.dart';

class ContactEditPageController {
  final ContactService contactService = GetIt.I.get();

  final ContactEditPageModel model = ContactEditPageModel();

  final String phoneNumber;
  late final Contact contact;

  ContactEditPageController({required this.phoneNumber}) {
    contactService.fetchByPhoneNumber(phoneNumber).then((contact) {
      this.contact = contact;
      model.contactName = contact.displayName;
      model.contactBirthday = contact.birthday;
    });
  }

  void updateContact(String name, DateTime? birthday) {
    if (birthday != null) {
      contact.birthday = birthday;
      model.contactBirthday = birthday;
    }
    model.contactName = name;
    contact.displayName = name;
    contactService.update(contact);
  }
}
