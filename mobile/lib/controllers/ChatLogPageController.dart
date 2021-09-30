import 'package:get_it/get_it.dart';
import 'package:mobile/domain/BlockedNumber.dart';
import 'package:mobile/models/ChatLogPageModel.dart';
import 'package:mobile/services/ChildChatService.dart';
import 'package:mobile/services/ChildService.dart';
import 'package:mobile/services/CommunicationService.dart';

class ChatLogPageController {
  final ChildService childService = GetIt.I.get();
  final ChildChatService childChatService = GetIt.I.get();
  final CommunicationService communicationService = GetIt.I.get();

  final ChatLogPageModel model = ChatLogPageModel();

  ChatLogPageController(String phoneNumber) {
    reload(phoneNumber);
  }

  void reload(String phoneNumber) {
    childService.fetchByPhoneNumber(phoneNumber).then((child) {
      model.childPhoneNumber = child.phoneNumber;
      model.childName = child.name;
    });
    //TODO organize by name/ timestamp if we include mostRecentMessage
    childChatService.fetchAllChatsByChildNumber(phoneNumber).then((chats) {
      model.chats = chats;
    });
  }

  void blockNumber(String phoneNumber) {
    communicationService.sendBlockedNumberToChild(model.childPhoneNumber,
        BlockedNumber(phoneNumber: phoneNumber), "insert");
  }
}
