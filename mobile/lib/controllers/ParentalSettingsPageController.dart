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

  List<Child> children = [];

  final ParentalSettingsPageModel model = ParentalSettingsPageModel();

  ParentalSettingsPageController() {
    childService.fetchAll().then((elements) {
      children = elements;
      if (children.isNotEmpty) {
        final names = <String>[];
        children.forEach((child) {
          names.add(child.name);
        });
        model.childrenNames.clear();
        model.childrenNames.addAll(names);
        reload(children[0]);
      }
    });
  }

  void reload(Child child) {
    childService.fetchByPhoneNumber(child.phoneNumber).then((value) {
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

  void addChild(String phoneNumber, String pin, String name) {
    //TODO send pin to see if matches on both phones
    final child = Child(phoneNumber: phoneNumber, name: name, pin: pin);
    model.childrenNames.add(name);
    childService.insert(child);
  }

  void removeChild(String phoneNumber, name) async {
    //TODO free up settings of child associated
    //Does this work
    model.childrenNames.remove(name);
    final chats = await childChatService.fetchAllChatsByChildNumber(
        phoneNumber);
    chats.forEach((chat) {
      childMessageService.deleteAllByChatId(chat.id);
    });
    childChatService.deleteAllByNumber(phoneNumber);
    childService.deleteByNumber(phoneNumber);
  }

  void setName(String oldName, String newName, String phoneNumber) {
    int index = model.childrenNames.indexOf(oldName);
    model.childrenNames[index] = newName;
    childService.update(phoneNumber, name: newName);
  }

  void setEditableSettings(bool value, String phoneNumber) {
    model.editableSettings = value;
    childService.update(phoneNumber, editableSettings: value);
  }

  void setBlurImages(bool value, String phoneNumber) {
    model.blurImages = value;
    childService.update(phoneNumber, blurImages: value);
  }

  void setSafeMode(bool value, String phoneNumber) {
    model.safeMode = value;
    childService.update(phoneNumber, safeMode: value);
  }

  void setShareProfilePicture(bool value, String phoneNumber) {
    model.shareProfilePicture = value;
    childService.update(phoneNumber, shareProfilePicture: value);
  }

  void setShareStatus(bool value, String phoneNumber) {
    model.shareStatus = value;
    childService.update(phoneNumber, shareStatus: value);
  }

  void setShareReadReceipts(bool value, String phoneNumber) {
    model.shareReadReceipts = value;
    childService.update(phoneNumber, shareReadReceipts: value);
  }

  void setShareBirthday(bool value, String phoneNumber) {
    model.shareBirthday = value;
    childService.update(phoneNumber, shareBirthday: value);
  }

  void setLockedAccount(bool value, String phoneNumber) {
    model.lockedAccount = value;
    childService.update(phoneNumber, lockedAccount: value);
  }

  void setPrivateChatAccess(bool value, String phoneNumber) {
    model.privateChatAccess = value;
    childService.update(phoneNumber, privateChatAccess: value);
  }

  void setBlockSaveMedia(bool value, String phoneNumber) {
    model.blockSaveMedia = value;
    childService.update(phoneNumber, blockSaveMedia: value);
  }

  void setBlockEditingMessages(bool value, String phoneNumber) {
    model.blockEditingMessages = value;
    childService.update(phoneNumber, blockEditingMessages: value);
  }

  void setBlockDeletingMessages(bool value, String phoneNumber) {
    model.blockDeletingMessages = value;
    childService.update(phoneNumber, blockDeletingMessages: value);
  }
}
