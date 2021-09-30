import 'package:get_it/get_it.dart';
import 'package:mobile/models/ChatLogPageModel.dart';
import 'package:mobile/services/ChildChatService.dart';
import 'package:mobile/services/ChildService.dart';

class ChatLogPageController {
  final ChildService childService = GetIt.I.get();
  final ChildChatService childChatService = GetIt.I.get();

  final ChatLogPageModel model = ChatLogPageModel();

  ChatLogPageController(String phoneNumber) {
    reload(phoneNumber);
  }

  void reload(String phoneNumber) {
    childService
        .fetchByPhoneNumber(phoneNumber)
        .then((child) => model.childName = child.name);
    //TODO organize by name/ timestamp if we include mostRecentMessage
    childChatService.fetchAllChatsByChildNumber(phoneNumber).then((chats) {
      model.chats = chats;
    });
  }
}
