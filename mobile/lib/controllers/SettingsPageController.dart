import 'package:get_it/get_it.dart';
import 'package:mobile/domain/Contact.dart';
import 'package:mobile/models/SettingsPageModel.dart';
import 'package:mobile/services/CommunicationService.dart';
import 'package:mobile/services/ContactService.dart';
import 'package:mobile/services/SettingsService.dart';
import 'package:mobile/services/UserService.dart';
import 'package:mobile/util/Utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart' as ImportContact;

class SettingsPageController {
  final SettingsService settingsService = GetIt.I.get();
  final UserService userService = GetIt.I.get();
  final ContactService contactService = GetIt.I.get();
  final CommunicationService communicationService = GetIt.I.get();

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
        .getShareReadReceipts()
        .then((value) => model.shareReadReceipts = value);
    settingsService
        .getDisableNotifications()
        .then((value) => model.showNotifications = value);
    settingsService
        .getPlayNotificationSound()
        .then((value) => model.playNotificationSound = value);
    settingsService
        .getShowMessagePreview()
        .then((value) => model.showMessagePreview = value);
    settingsService
        .getAutoDownloadMedia()
        .then((value) => model.autoDownloadMedia = value);
    //TODO Set model pin
  }

  void reload() {
    userService.getDisplayName().then((value) => model.userName = value);
    userService.getStatus().then((value) => model.userStatus = value);
    userService
        .getProfileImage()
        .then((value) => model.userProfilePicture = value);
  }

  //TODO create function to change pin

  void setBlurImages(bool value) {
    model.blurImages = value;
    settingsService.setBlurImages(value);
  }

  void setSafeMode(bool value, String pin) {
    //TODO Check if pin is correct
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

  void setDisableNotifications(bool value) {
    model.showNotifications = value;
    settingsService.setDisableNotifications(value);
  }

  void setPlayNotificationSound(bool value) {
    model.playNotificationSound = value;
    settingsService.setPlayNotificationSound(value);
  }

  void setShowMessagePreview(bool value) {
    model.showMessagePreview = value;
    settingsService.setShowMessagePreview(value);
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
