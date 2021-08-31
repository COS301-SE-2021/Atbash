import 'package:get_it/get_it.dart';
import 'package:mobile/domain/Contact.dart';
import 'package:mobile/models/ContactEditPageModel.dart';
import 'package:mobile/services/ContactService.dart';

class ContactEditPageController {
  final ContactService contactService = GetIt.I.get();

  final ContactEditPageModel model = ContactEditPageModel();

  Contact contact;

  ContactEditPageController({required this.contact}) {
    model.contactName = contact.displayName;
    model.contactBirthday = contact.birthday;
  }

  void updateContact(String name, DateTime? birthday) {
    model.setContactName(name);
    if (birthday != null) model.setContactBirthday(birthday);

    contact.displayName = name;
    if (birthday != null) contact.birthday = birthday;
    contactService.update(contact);
  }
}
