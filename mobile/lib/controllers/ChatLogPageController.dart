import 'package:get_it/get_it.dart';
import 'package:mobile/domain/BlockedNumber.dart';
import 'package:mobile/domain/ChildBlockedNumber.dart';
import 'package:mobile/models/ChatLogPageModel.dart';
import 'package:mobile/services/ChildBlockedNumberService.dart';
import 'package:mobile/services/ChildChatService.dart';
import 'package:mobile/services/ChildContactService.dart';
import 'package:mobile/services/ChildService.dart';
import 'package:mobile/services/CommunicationService.dart';
import 'package:uuid/uuid.dart';

class ChatLogPageController {
  final ChildService childService = GetIt.I.get();
  final ChildChatService childChatService = GetIt.I.get();
  final CommunicationService communicationService = GetIt.I.get();
  final ChildBlockedNumberService childBlockedNumberService = GetIt.I.get();
  final ChildContactService childContactService = GetIt.I.get();

  final ChatLogPageModel model = ChatLogPageModel();

  ChatLogPageController(String childPhoneNumber) {
    communicationService.onBlockedNumberToParent = () {
      childBlockedNumberService
          .fetchAllByNumber(childPhoneNumber)
          .then((numbers) {
        model.blockedNumbrs.clear();
        model.blockedNumbrs.addAll(numbers);
      });
    };

    communicationService.onChatToParent = () {
      childChatService
          .fetchAllChatsByChildNumber(childPhoneNumber)
          .then((chats) {
        model.chats.clear();
        model.chats.addAll(chats);
      });
    };

    communicationService.onContactToParent = () {
      childContactService
          .fetchAllContactsByChildNumber(childPhoneNumber)
          .then((contacts) {
        model.contacts.clear();
        model.contacts.addAll(contacts);
      });
    };
    reload(childPhoneNumber);
  }

  void reload(String childPhoneNumber) {
    childService.fetchByPhoneNumber(childPhoneNumber).then((child) {
      model.childName = child.name;
    });

    childChatService.fetchAllChatsByChildNumber(childPhoneNumber).then((chats) {
      model.chats.clear();
      model.chats.addAll(chats);
    });

    childBlockedNumberService
        .fetchAllByNumber(childPhoneNumber)
        .then((numbers) {
      model.blockedNumbrs.clear();
      model.blockedNumbrs.addAll(numbers);
    });

    childContactService
        .fetchAllContactsByChildNumber(childPhoneNumber)
        .then((contacts) {
      model.contacts.clear();
      model.contacts.addAll(contacts);
    });
  }

  void blockNumber(String childPhoneNumber, String numberToBlock) {
    communicationService.sendBlockedNumberToChild(
        childPhoneNumber, BlockedNumber(phoneNumber: numberToBlock), "insert");
    childBlockedNumberService.insert(ChildBlockedNumber(
        id: Uuid().v4(),
        childNumber: childPhoneNumber,
        blockedNumber: numberToBlock));
  }
}
