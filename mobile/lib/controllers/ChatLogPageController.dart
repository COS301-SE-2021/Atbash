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

  late final childNumber;

  ChatLogPageController(String childPhoneNumber) {
    childNumber = childPhoneNumber;

    communicationService.onBlockedNumberToParent(_onBlockedNumberToParent);

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

  void dispose() {
    communicationService
        .disposeOnBlockedNumberToParent(_onBlockedNumberToParent);
  }

  void _onBlockedNumberToParent() {
    childBlockedNumberService.fetchAllByNumber(childNumber).then((numbers) {
      model.blockedNumbrs.clear();
      model.blockedNumbrs.addAll(numbers);
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
