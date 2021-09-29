import 'package:get_it/get_it.dart';
import 'package:mobile/domain/Child.dart';
import 'package:mobile/models/ParentalSettingsPageModel.dart';
import 'package:mobile/services/ChildChatService.dart';
import 'package:mobile/services/ChildMessageService.dart';
import 'package:mobile/services/ChildService.dart';
import 'package:mobile/services/CommunicationService.dart';

class ParentalSettingsPageController {
  final CommunicationService communicationService = GetIt.I.get();
  final ChildService childService = GetIt.I.get();
  final ChildChatService childChatService = GetIt.I.get();
  final ChildMessageService childMessageService = GetIt.I.get();

  final ParentalSettingsPageModel model = ParentalSettingsPageModel();

  ParentalSettingsPageController() {
    //TODO remove already added contacts as children from list (Cross reference lists)
    childService.fetchAll().then((elements) {
      model.children.clear();
      model.children.addAll(elements);
      if (model.children.isNotEmpty) reload(0);
    });
  }

  void reload(int index) {
    model.currentlySelected = index;
    childService
        .fetchByPhoneNumber(model.children[index].phoneNumber)
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
    //TODO free up settings of child associated
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
    model.children[model.currentlySelected].name = name;
    childService.update(model.children[model.currentlySelected].phoneNumber,
        name: name);
  }

  void setPin(String pin) {
    model.children[model.currentlySelected].pin = pin;
    childService.update(model.children[model.currentlySelected].phoneNumber,
        pin: pin);
  }

  void setEditableSettings(bool value) {
    model.editableSettings = value;
    childService.update(model.children[model.currentlySelected].phoneNumber,
        editableSettings: value);
  }

  void setBlurImages(bool value) {
    model.blurImages = value;
    childService.update(model.children[model.currentlySelected].phoneNumber,
        blurImages: value);
  }

  void setSafeMode(bool value) {
    model.safeMode = value;
    childService.update(model.children[model.currentlySelected].phoneNumber,
        safeMode: value);
  }

  void setShareProfilePicture(bool value) {
    model.shareProfilePicture = value;
    childService.update(model.children[model.currentlySelected].phoneNumber,
        shareProfilePicture: value);
  }

  void setShareStatus(bool value) {
    model.shareStatus = value;
    childService.update(model.children[model.currentlySelected].phoneNumber,
        shareStatus: value);
  }

  void setShareReadReceipts(bool value) {
    model.shareReadReceipts = value;
    childService.update(model.children[model.currentlySelected].phoneNumber,
        shareReadReceipts: value);
  }

  void setShareBirthday(bool value) {
    model.shareBirthday = value;
    childService.update(model.children[model.currentlySelected].phoneNumber,
        shareBirthday: value);
  }

  void setLockedAccount(bool value) {
    model.lockedAccount = value;
    childService.update(model.children[model.currentlySelected].phoneNumber,
        lockedAccount: value);
  }

  void setPrivateChatAccess(bool value) {
    model.privateChatAccess = value;
    childService.update(model.children[model.currentlySelected].phoneNumber,
        privateChatAccess: value);
  }

  void setBlockSaveMedia(bool value) {
    model.blockSaveMedia = value;
    childService.update(model.children[model.currentlySelected].phoneNumber,
        blockSaveMedia: value);
  }

  void setBlockEditingMessages(bool value) {
    model.blockEditingMessages = value;
    childService.update(model.children[model.currentlySelected].phoneNumber,
        blockEditingMessages: value);
  }

  void setBlockDeletingMessages(bool value) {
    model.blockDeletingMessages = value;
    childService.update(model.children[model.currentlySelected].phoneNumber,
        blockDeletingMessages: value);
  }
}
