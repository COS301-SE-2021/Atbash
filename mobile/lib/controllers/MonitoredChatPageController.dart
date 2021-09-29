import 'package:get_it/get_it.dart';
import 'package:mobile/models/MonitoredChatPageModel.dart';
import 'package:mobile/services/ChildChatService.dart';
import 'package:mobile/services/ChildMessageService.dart';
import 'package:mobile/services/ChildService.dart';

class MonitoredChatPageController {
  final ChildService childService = GetIt.I.get();
  final ChildChatService childChatService = GetIt.I.get();
  final ChildMessageService childMessageService = GetIt.I.get();

  final MonitoredChatPageModel model = MonitoredChatPageModel();

  MonitoredChatPageController(String phoneNumber, String otherNumber) {
    reload(phoneNumber, otherNumber);
  }

  void reload(String phoneNumber, String otherNumber) {
    childService.fetchByPhoneNumber(phoneNumber).then((child) {
      model.childName = child.name;
    });

    childChatService.fetchByNumbers(phoneNumber, otherNumber).then((chat) {
      final otherName = chat.otherPartyName;
      if (otherName != null) {
        model.otherMemberName = otherName;
      }

      model.otherMemberNumber = chat.otherPartyNumber;

      childMessageService.fetchAllByChatId(chat.id).then((messages) {
        model.messages = messages;
      });
    });
  }

  void blockContact(String childNumber, String blockedNumber){
    //TODO send request to block number to child phone
  }
}
