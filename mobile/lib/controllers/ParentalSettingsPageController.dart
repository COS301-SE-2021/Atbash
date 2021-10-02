import 'package:get_it/get_it.dart';
import 'package:mobile/domain/Child.dart';
import 'package:mobile/models/ParentalSettingsPageModel.dart';
import 'package:mobile/services/ChildBlockedNumberService.dart';
import 'package:mobile/services/ChildChatService.dart';
import 'package:mobile/services/ChildMessageService.dart';
import 'package:mobile/services/ChildProfanityWordService.dart';
import 'package:mobile/services/ChildService.dart';
import 'package:mobile/services/CommunicationService.dart';
import 'package:mobile/services/ParentService.dart';
import 'package:mobile/util/Tuple.dart';

class ParentalSettingsPageController {
  final CommunicationService communicationService = GetIt.I.get();
  final ChildService childService = GetIt.I.get();
  final ChildChatService childChatService = GetIt.I.get();
  final ChildMessageService childMessageService = GetIt.I.get();
  final ParentService parentService = GetIt.I.get();
  final ChildBlockedNumberService childBlockedNumberService = GetIt.I.get();
  final ChildProfanityWordService childProfanityWordService = GetIt.I.get();

  final ParentalSettingsPageModel model = ParentalSettingsPageModel();

  ParentalSettingsPageController() {
    reload();
  }

  void reload() {
    childService.fetchAll().then((children) {
      List<Tuple<Child, bool>> tuples = [];
      children.forEach((child) {
        tuples.add(Tuple(child, false));
      });
      model.children.clear();
      model.children.addAll(tuples);
      parentService
          .fetchByEnabled()
          .then((parent) => model.parentName = parent.name)
          .catchError((_) {});
    });
  }

  void setIndex(int index) {
    model.index = index;
  }

  void removeChild(Child child) async {
    communicationService.sendRemoveChild(child.phoneNumber);
    final chats =
        await childChatService.fetchAllChatsByChildNumber(child.phoneNumber);
    chats.forEach((chat) async {
      await childMessageService.deleteAllByPhoneNumbers(chat.childPhoneNumber, chat.otherPartyNumber);
    });
    await childChatService.deleteAllByChildNumber(child.phoneNumber);
    await childService.deleteByNumber(child.phoneNumber);
    await childBlockedNumberService.deleteAllForChild(child.phoneNumber);
    await childProfanityWordService.deleteAllByNumber(child.phoneNumber);
    model.children.removeWhere(
        (element) => element.first.phoneNumber == child.phoneNumber);
    if (model.children.isNotEmpty) model.index = 0;
  }

  void setChildChanged(bool value) {
    model.children[model.index].second = value;
  }

  void setEditableSettings(bool value) {
    model.children[model.index].first.editableSettings = value;
    childService.update(
        model.children[model.index].first.phoneNumber,
        editableSettings: value);
  }

  void setBlurImages(bool value) {
    model.children[model.index].first.blurImages = value;
    childService.update(
        model.children[model.index].first.phoneNumber,
        blurImages: value);
  }

  void setSafeMode(bool value) {
    model.children[model.index].first.safeMode = value;
    childService.update(
        model.children[model.index].first.phoneNumber,
        safeMode: value);
  }

  void setShareProfilePicture(bool value) {
    model.children[model.index].first.shareProfilePicture = value;
    childService.update(
        model.children[model.index].first.phoneNumber,
        shareProfilePicture: value);
  }

  void setShareStatus(bool value) {
    model.children[model.index].first.shareStatus = value;
    childService.update(
        model.children[model.index].first.phoneNumber,
        shareStatus: value);
  }

  void setShareReadReceipts(bool value) {
    model.children[model.index].first.shareReadReceipts = value;
    childService.update(
        model.children[model.index].first.phoneNumber,
        shareReadReceipts: value);
  }

  void setShareBirthday(bool value) {
    model.children[model.index].first.shareBirthday = value;
    childService.update(
        model.children[model.index].first.phoneNumber,
        shareBirthday: value);
  }

  void setLockedAccount(bool value) {
    model.children[model.index].first.lockedAccount = value;
    childService.update(
        model.children[model.index].first.phoneNumber,
        lockedAccount: value);
  }

  void setPrivateChatAccess(bool value) {
    model.children[model.index].first.privateChatAccess = value;
    childService.update(
        model.children[model.index].first.phoneNumber,
        privateChatAccess: value);
  }

  void setBlockSaveMedia(bool value) {
    model.children[model.index].first.blockSaveMedia = value;
    childService.update(
        model.children[model.index].first.phoneNumber,
        blockSaveMedia: value);
  }

  void setBlockEditingMessages(bool value) {
    model.children[model.index].first.blockEditingMessages = value;
    childService.update(
        model.children[model.index].first.phoneNumber,
        blockEditingMessages: value);
  }

  void setBlockDeletingMessages(bool value) {
    model.children[model.index].first.blockDeletingMessages = value;
    childService.update(
        model.children[model.index].first.phoneNumber,
        blockDeletingMessages: value);
  }

  void addParent(String code) async {
    final parent = await parentService.fetchByCode(code).catchError((_) {
      //TODO show no parent with that code exists
    });
    parentService.updateEnabledByCode(code, true);
    communicationService.sendSetupChild(parent.phoneNumber);
  }

  void sendUpdatedSettingsToChild(Child child) {
    communicationService.sendAllSettingsToChild(
        child.phoneNumber,
        child.editableSettings,
        child.blurImages,
        child.safeMode,
        child.shareProfilePicture,
        child.shareStatus,
        child.shareReadReceipts,
        child.shareBirthday,
        child.lockedAccount,
        child.privateChatAccess,
        child.blockSaveMedia,
        child.blockEditingMessages,
        child.blockDeletingMessages);
  }
}
