import 'package:get_it/get_it.dart';
import 'package:mobile/domain/Child.dart';
import 'package:mobile/models/ParentalSettingsPageModel.dart';
import 'package:mobile/services/ChildChatService.dart';
import 'package:mobile/services/ChildMessageService.dart';
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

  final ParentalSettingsPageModel model = ParentalSettingsPageModel();

  ParentalSettingsPageController() {
    childService.fetchAll().then((children) {
      List<Tuple<Child, bool>> tuples = [];
      children.forEach((child) {
        tuples.add(Tuple(child, false));
      });
      model.children.clear();
      model.children.addAll(tuples);
      reload(0);
    });
  }

  void reload(int index) {
    if (model.children.isEmpty) {
      return;
    }
    model.currentlySelected = index;
    parentService
        .fetchByEnabled()
        .then((parent) => model.parentName = parent.name);
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
    childService.update(
        model.children[model.currentlySelected].first.phoneNumber,
        name: name);
  }

  void setChildChanged(bool value) {
    model.children[model.currentlySelected].second = value;
  }

  void setEditableSettings(bool value) {
    model.editableSettings = value;
    childService.update(
        model.children[model.currentlySelected].first.phoneNumber,
        editableSettings: value);
  }

  void setBlurImages(bool value) {
    model.blurImages = value;
    childService.update(
        model.children[model.currentlySelected].first.phoneNumber,
        blurImages: value);
  }

  void setSafeMode(bool value) {
    model.safeMode = value;
    childService.update(
        model.children[model.currentlySelected].first.phoneNumber,
        safeMode: value);
  }

  void setShareProfilePicture(bool value) {
    model.shareProfilePicture = value;
    childService.update(
        model.children[model.currentlySelected].first.phoneNumber,
        shareProfilePicture: value);
  }

  void setShareStatus(bool value) {
    model.shareStatus = value;
    childService.update(
        model.children[model.currentlySelected].first.phoneNumber,
        shareStatus: value);
  }

  void setShareReadReceipts(bool value) {
    model.shareReadReceipts = value;
    childService.update(
        model.children[model.currentlySelected].first.phoneNumber,
        shareReadReceipts: value);
  }

  void setShareBirthday(bool value) {
    model.shareBirthday = value;
    childService.update(
        model.children[model.currentlySelected].first.phoneNumber,
        shareBirthday: value);
  }

  void setLockedAccount(bool value) {
    model.lockedAccount = value;
    childService.update(
        model.children[model.currentlySelected].first.phoneNumber,
        lockedAccount: value);
  }

  void setPrivateChatAccess(bool value) {
    model.privateChatAccess = value;
    childService.update(
        model.children[model.currentlySelected].first.phoneNumber,
        privateChatAccess: value);
  }

  void setBlockSaveMedia(bool value) {
    model.blockSaveMedia = value;
    childService.update(
        model.children[model.currentlySelected].first.phoneNumber,
        blockSaveMedia: value);
  }

  void setBlockEditingMessages(bool value) {
    model.blockEditingMessages = value;
    childService.update(
        model.children[model.currentlySelected].first.phoneNumber,
        blockEditingMessages: value);
  }

  void setBlockDeletingMessages(bool value) {
    model.blockDeletingMessages = value;
    childService.update(
        model.children[model.currentlySelected].first.phoneNumber,
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
        model.editableSettings,
        model.blurImages,
        model.safeMode,
        model.shareProfilePicture,
        model.shareStatus,
        model.shareReadReceipts,
        model.shareBirthday,
        model.lockedAccount,
        model.privateChatAccess,
        model.blockSaveMedia,
        model.blockEditingMessages,
        model.blockDeletingMessages);
  }
}
