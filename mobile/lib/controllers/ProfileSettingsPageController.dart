import 'dart:convert';
import 'dart:typed_data';

import 'package:get_it/get_it.dart';
import 'package:mobile/domain/Contact.dart';
import 'package:mobile/models/ProfileSettingsPageModel.dart';
import 'package:mobile/services/CommunicationService.dart';
import 'package:mobile/services/ContactService.dart';
import 'package:mobile/services/UserService.dart';
import 'package:mobile/util/Utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart' as ImportContact;

class ProfileSettingsPageController {
  final UserService userService = GetIt.I.get();
  final ContactService contactService = GetIt.I.get();
  final CommunicationService communicationService = GetIt.I.get();

  final ProfileSettingsPageModel model = ProfileSettingsPageModel();

  ProfileSettingsPageController() {
    userService.getPhoneNumber().then((value) => model.phoneNumber = value);
    userService.getDisplayName().then((value) => model.displayName = value);
    userService.getStatus().then((value) => model.status = value);
    userService.getBirthday().then((value) => model.birthday = value);
    userService.getProfileImage().then((value) => model.profilePicture = value);
  }

  void setDisplayName(String name) {
    model.displayName = name;
    userService.setDisplayName(name);
  }

  void setStatus(String status) {
    model.status = status;
    userService.setStatus(status);
    contactService.fetchAll().then((contacts) {
      contacts.forEach((contact) {
        communicationService.sendStatus(status, contact.phoneNumber);
      });
    });
  }

  void setBirthday(DateTime birthday) {
    model.birthday = birthday;
    userService.setBirthday(birthday);
  }

  void setProfilePicture(Uint8List picture) {
    model.profilePicture = picture;
    userService.setProfileImage(picture);
    contactService.fetchAll().then((contacts) {
      contacts.forEach((contact) {
        communicationService.sendProfileImage(
            base64Encode(picture), contact.phoneNumber);
      });
    });
  }

  Future<void> _addContact(String number, String name) async {
    Contact contact = new Contact(
        phoneNumber: number, displayName: name, status: "", profileImage: "");
    await contactService.insert(contact);
    communicationService.sendRequestStatus(number);
    communicationService.sendRequestProfileImage(number);
  }

  Future<void> importContacts() async {
    PermissionStatus contactPermission = await Permission.contacts.request();
    if (contactPermission.isGranted) {
      Iterable<ImportContact.Contact> contacts =
          await ImportContact.ContactsService.getContacts();

      contacts.forEach((contact) async {
        final Iterable<ImportContact.Item>? contactPhones = contact.phones;
        if (contactPhones != null) {
          String? mobileNumber = contactPhones.first.value;
          String? name = contact.displayName;
          if (mobileNumber != null && name != null) {
            String phoneNumber = "+" + cullToE164(mobileNumber);
            _addContact(phoneNumber, name).catchError((_) {});
          }
        }
      });
    }
  }
}
