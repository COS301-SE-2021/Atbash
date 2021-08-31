import 'package:get_it/get_it.dart';
import 'package:mobile/domain/Contact.dart';
import 'package:mobile/models/ContactEditPageModel.dart';
import 'package:mobile/services/ContactService.dart';

class ContactEditPageController {
  final ContactService contactService = GetIt.I.get();

  final ContactEditPageModel model = ContactEditPageModel();

  late final Contact contact;

  ContactEditPageController({required this.contact}) {
      this.contact = contact;
      model.contactName = contact.displayName;
      model.contactNumber = contact.phoneNumber;
      model.contactProfileImage = contact.profileImage;
      model.contactBirthday = contact.birthday;
  }

  void updateContact(String name, DateTime? birthday) {
    model.setContactName(name);
    if(birthday != null)
    model.setContactBirthday(birthday);

    contact.displayName = name;
    contact.birthday = birthday;
    contactService.update(contact);
  }
}
