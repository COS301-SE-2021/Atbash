import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:mobile/domain/Contact.dart';
import 'package:mobile/models/SettingsPageModel.dart';
import 'package:mobile/services/CommunicationService.dart';
import 'package:mobile/services/ContactService.dart';
import 'package:mobile/services/ParentService.dart';
import 'package:mobile/services/SettingsService.dart';
import 'package:mobile/services/UserService.dart';
import 'package:mobile/util/Utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart' as ImportContact;

import '../constants.dart';

class SettingsPageController {
  final SettingsService settingsService = GetIt.I.get();
  final UserService userService = GetIt.I.get();
  final ContactService contactService = GetIt.I.get();
  final CommunicationService communicationService = GetIt.I.get();
  final ParentService parentService = GetIt.I.get();

  final SettingsPageModel model = SettingsPageModel();

  SettingsPageController() {
    reload();
    settingsService.getBlurImages().then((value) => model.blurImages = value);
    settingsService.getSafeMode().then((value) => model.safeMode = value);
    settingsService
        .getShareProfilePicture()
        .then((value) => model.sharedProfilePicture = value);
    settingsService.getShareStatus().then((value) => model.shareStatus = value);
    settingsService
        .getShareBirthday()
        .then((value) => model.shareBirthday = value);
    settingsService
        .getShareReadReceipts()
        .then((value) => model.shareReadReceipts = value);
    settingsService
        .getDisableNotifications()
        .then((value) => model.disableNotifications = value);
    settingsService
        .getDisableMessagePreview()
        .then((value) => model.disableMessagePreview = value);
    settingsService
        .getAutoDownloadMedia()
        .then((value) => model.autoDownloadMedia = value);
  }

  void reload() {
    userService.getDisplayName().then((value) => model.userName = value);
    userService.getStatus().then((value) => model.userStatus = value);
    userService
        .getProfileImage()
        .then((value) => model.userProfilePicture = value);
  }

  void setBlurImages(bool value) {
    model.blurImages = value;
    settingsService.setBlurImages(value);
  }

  void setSafeMode(bool value) {
    model.safeMode = value;
    settingsService.setSafeMode(value);
  }

  void setSharedProfilePicture(bool value) {
    model.sharedProfilePicture = value;
    settingsService.setShareProfilePicture(value);
  }

  void setShareStatus(bool value) {
    model.shareStatus = value;
    settingsService.setShareStatus(value);
  }

  void setShareReadReceipts(bool value) {
    model.shareReadReceipts = value;
    settingsService.setShareReadReceipts(value);
  }

  void setShareBirthday(bool value) {
    model.shareBirthday = value;
    settingsService.setShareBirthday(value);
  }

  void setDisableNotifications(bool value) {
    model.disableNotifications = value;
    settingsService.setDisableNotifications(value);
  }

  void setDisableMessagePreview(bool value) {
    model.disableMessagePreview = value;
    settingsService.setDisableMessagePreview(value);
  }

  void setAutoDownloadMedia(bool value) {
    model.autoDownloadMedia = value;
    settingsService.setAutoDownloadMedia(value);
  }

  Future<void> _addContact(String number, String name) async {
    Contact contact = new Contact(
        phoneNumber: number, displayName: name, status: "", profileImage: "");
    await contactService.insert(contact);
    communicationService.sendRequestStatus(number);
    communicationService.sendRequestProfileImage(number);
  }

  void sentUpdatedSettingsToParent() async{
    final parent = await parentService.fetchByEnabled(true).catchError((_) {

    });
    communicationService.sendAllSettingsToParent(parent.phoneNumber, model.blurImages, model.safeMode, model.sharedProfilePicture, model.shareStatus, model.shareReadReceipts, model.shareBirthday);
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
            get(Uri.parse(Constants.httpUrl + "user/$phoneNumber/exists"))
                .then((response) {
              if (response.statusCode == 204) {
                _addContact(phoneNumber, name).catchError((_) {});
              }
            });
          }
        }
      });
    }
  }
}
