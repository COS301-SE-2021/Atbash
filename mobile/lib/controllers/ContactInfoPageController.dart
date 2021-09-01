import 'package:get_it/get_it.dart';
import 'package:mobile/models/ContactInfoPageModel.dart';
import 'package:mobile/services/ContactService.dart';

class ContactInfoPageController {
  final ContactService contactService = GetIt.I.get();

  final ContactInfoPageModel model = ContactInfoPageModel();

  final String phoneNumber;

  ContactInfoPageController({required this.phoneNumber}) {
    reload();
  }

  void reload() {
    contactService.fetchByPhoneNumber(phoneNumber).then((contact) {
      model.contactName = contact.displayName;
      model.phoneNumber = contact.phoneNumber;
      model.status = contact.status;
      model.profilePicture = contact.profileImage;
      model.birthday = contact.birthday;
    });
  }
}
