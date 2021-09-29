import 'package:get_it/get_it.dart';
import 'package:mobile/domain/ChildBlockedNumber.dart';
import 'package:mobile/models/MonitoredChatPageModel.dart';
import 'package:mobile/services/ChildBlockedNumberService.dart';
import 'package:mobile/services/ChildChatService.dart';
import 'package:mobile/services/ChildMessageService.dart';
import 'package:mobile/services/ChildService.dart';
import 'package:mobile/services/CommunicationService.dart';
import 'package:uuid/uuid.dart';

class MonitoredChatPageController {
  final ChildService childService = GetIt.I.get();
  final ChildChatService childChatService = GetIt.I.get();
  final ChildMessageService childMessageService = GetIt.I.get();
  final ChildBlockedNumberService childBlockedNumberService = GetIt.I.get();
  final CommunicationService communicationService = GetIt.I.get();

  final MonitoredChatPageModel model = MonitoredChatPageModel();

  MonitoredChatPageController(String phoneNumber, String otherNumber) {
    reload(phoneNumber, otherNumber);
  }

  void reload(String phoneNumber, String otherNumber) {
    childService.fetchByPhoneNumber(phoneNumber).then((child) {
      model.childName = child.name;
    });

    childBlockedNumberService.fetchAllByNumber(phoneNumber).then((numbers) {
      model.blockedNumbers.clear();
      model.blockedNumbers.addAll(numbers);
    });

    childChatService.fetchByNumbers(phoneNumber, otherNumber).then((chat) {
      final otherName = chat.otherPartyName;
      if (otherName != null) {
        model.otherMemberName = otherName;
      } else {
        model.otherMemberName = chat.otherPartyNumber;
      }

      model.otherMemberNumber = chat.otherPartyNumber;

      childMessageService.fetchAllByChatId(chat.id).then((messages) {
        model.messages = messages;
      });
    });
  }

  void blockContact(String childNumber, String blockedNumber) {
    final number = ChildBlockedNumber(
        id: Uuid().v4(),
        childNumber: childNumber,
        blockedNumber: blockedNumber);
    model.blockedNumbers.add(number);
    childBlockedNumberService.insert(number);
    communicationService.sendBlockedContact(blockedNumber);
  }
}
