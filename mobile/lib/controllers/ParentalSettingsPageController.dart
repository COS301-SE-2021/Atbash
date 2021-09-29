import 'package:get_it/get_it.dart';
import 'package:mobile/domain/Child.dart';
import 'package:mobile/models/ParentalSettingsPageModel.dart';
import 'package:mobile/services/ChildChatService.dart';
import 'package:mobile/services/ChildMessageService.dart';
import 'package:mobile/services/ChildService.dart';
import 'package:mobile/services/CommunicationService.dart';
import 'package:mobile/util/Tuple.dart';

class ParentalSettingsPageController {
  final CommunicationService communicationService = GetIt.I.get();
  final ChildService childService = GetIt.I.get();
  final ChildChatService childChatService = GetIt.I.get();
  final ChildMessageService childMessageService = GetIt.I.get();

  final ParentalSettingsPageModel model = ParentalSettingsPageModel();

  ParentalSettingsPageController() {
    childService.fetchAll().then((children) {
      List<Tuple<Child,bool>> tuples = [];
      children.forEach((child) {
        tuples.add(Tuple(child, false));
      });
      model.children.clear();
      model.children.addAll(tuples);
      if (model.children.isNotEmpty) reload(0);
    });
  }

  void reload(int index) {
    model.currentlySelected = index;
    childService
        .fetchByPhoneNumber(model.children[index].first.phoneNumber)
        .then((child) {
      model.editableSettings = child.editableSettings;
      model.blurImages = child.blurImages;
      model.safeMode = child.safeMode;
      model.shareProfilePicture = child.shareProfilePicture;
      model.shareStatus = child.shareStatus;
      model.shareReadReceipts = child.shareReadReceipts;
      model.shareBirthday = child.shareBirthday;
      model.lockedAccount = child.lockedAccount;
      model.privateChatAccess = child.privateChatAccess;
      model.blockSaveMedia = child.blockSaveMedia;
      model.blockEditingMessages = child.blockEditingMessages;
      model.blockDeletingMessages = child.blockDeletingMessages;
    });
  }

  void removeChild(Child child) async {
    communicationService.sendAllSettings(child.phoneNumber, false, false, false, false, false, false, false, false, false, false, false, false);
    communicationService.sendRemoveChild(child.phoneNumber);
    model.children.remove(child);
    final chats =
        await childChatService.fetchAllChatsByChildNumber(child.phoneNumber);
    chats.forEach((chat) {
      childMessageService.deleteAllByChatId(chat.id);
    });
    childChatService.deleteAllByNumber(child.phoneNumber);
    childService.deleteByNumber(child.phoneNumber);
  }

  void setName(String name) {
    model.children[model.currentlySelected].first.name = name;
    childService.update(model.children[model.currentlySelected].first.phoneNumber,
        name: name);
  }

  void setPin(String pin, String childPhoneNumber) {
    communicationService.sendPinToChild(childPhoneNumber);
    model.children[model.currentlySelected].first.pin = pin;
    childService.update(model.children[model.currentlySelected].first.phoneNumber,
        pin: pin);
  }

  void setChildChanged(bool value){
    model.children[model.currentlySelected].second = value;
  }

  void setEditableSettings(bool value) {
    model.editableSettings = value;
    childService.update(model.children[model.currentlySelected].first.phoneNumber,
        editableSettings: value);
  }

  void setBlurImages(bool value) {
    model.blurImages = value;
    childService.update(model.children[model.currentlySelected].first.phoneNumber,
        blurImages: value);
  }

  void setSafeMode(bool value) {
    model.safeMode = value;
    childService.update(model.children[model.currentlySelected].first.phoneNumber,
        safeMode: value);
  }

  void setShareProfilePicture(bool value) {
    model.shareProfilePicture = value;
    childService.update(model.children[model.currentlySelected].first.phoneNumber,
        shareProfilePicture: value);
  }

  void setShareStatus(bool value) {
    model.shareStatus = value;
    childService.update(model.children[model.currentlySelected].first.phoneNumber,
        shareStatus: value);
  }

  void setShareReadReceipts(bool value) {
    model.shareReadReceipts = value;
    childService.update(model.children[model.currentlySelected].first.phoneNumber,
        shareReadReceipts: value);
  }

  void setShareBirthday(bool value) {
    model.shareBirthday = value;
    childService.update(model.children[model.currentlySelected].first.phoneNumber,
        shareBirthday: value);
  }

  void setLockedAccount(bool value) {
    model.lockedAccount = value;
    childService.update(model.children[model.currentlySelected].first.phoneNumber,
        lockedAccount: value);
  }

  void setPrivateChatAccess(bool value) {
    model.privateChatAccess = value;
    childService.update(model.children[model.currentlySelected].first.phoneNumber,
        privateChatAccess: value);
  }

  void setBlockSaveMedia(bool value) {
    model.blockSaveMedia = value;
    childService.update(model.children[model.currentlySelected].first.phoneNumber,
        blockSaveMedia: value);
  }

  void setBlockEditingMessages(bool value) {
    model.blockEditingMessages = value;
    childService.update(model.children[model.currentlySelected].first.phoneNumber,
        blockEditingMessages: value);
  }

  void setBlockDeletingMessages(bool value) {
    model.blockDeletingMessages = value;
    childService.update(model.children[model.currentlySelected].first.phoneNumber,
        blockDeletingMessages: value);
  }

  void sendUpdatedSettingsToChild(
      Child child) {
    communicationService.sendAllSettings(
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
