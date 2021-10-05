import 'package:get_it/get_it.dart';
import 'package:mobile/domain/BlockedNumber.dart';
import 'package:mobile/models/ContactInfoPageModel.dart';
import 'package:mobile/services/BlockedNumbersService.dart';
import 'package:mobile/services/CommunicationService.dart';
import 'package:mobile/services/ContactService.dart';
import 'package:mobile/services/ParentService.dart';

class ContactInfoPageController {
  final ContactService contactService = GetIt.I.get();
  final BlockedNumbersService blockedNumbersService = GetIt.I.get();
  final CommunicationService communicationService = GetIt.I.get();
  final ParentService parentService = GetIt.I.get();

  final ContactInfoPageModel model = ContactInfoPageModel();

  final String phoneNumber;

  ContactInfoPageController({required this.phoneNumber}) {
    reload();
    communicationService.onBlockedNumberToChild(_onBlockedNumberToChild);
  }

  void reload() {
    contactService.fetchByPhoneNumber(phoneNumber).then((contact) {
      model.contactName = contact.displayName;
      model.phoneNumber = contact.phoneNumber;
      model.status = contact.status;
      model.profilePicture = contact.profileImage;
      model.birthday = contact.birthday;
    });
    blockedNumbersService.checkIfBlocked(phoneNumber).then((value) {
      model.isBlocked = value;
    });
    blockedNumbersService
        .checkIfBlockedByParent(phoneNumber)
        .then((value) => model.isBlockedByParent = value);
    parentService.fetchByEnabled().then((parent) {
      model.parentNumber = parent.phoneNumber;
    }).catchError((_) {});
  }

  void dispose() {
    communicationService.disposeOnBlockedNumberToChild(_onBlockedNumberToChild);
  }

  void _onBlockedNumberToChild() {
    blockedNumbersService.checkIfBlocked(phoneNumber).then((value) {
      model.isBlocked = value;
      model.isBlockedByParent = true;
    });
  }

  void blockContact() {
    model.isBlocked = true;
    final blockedNumber = BlockedNumber(phoneNumber: phoneNumber);
    blockedNumbersService.insert(blockedNumber);
  }

  void unblockContact() {
    model.isBlocked = false;
    blockedNumbersService.delete(phoneNumber);
  }
}
