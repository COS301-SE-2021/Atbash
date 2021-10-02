import 'package:get_it/get_it.dart';
import 'package:mobile/models/MonitoredChatPageModel.dart';
import 'package:mobile/services/ChildChatService.dart';
import 'package:mobile/services/ChildContactService.dart';
import 'package:mobile/services/ChildMessageService.dart';
import 'package:mobile/services/ChildService.dart';
import 'package:mobile/services/CommunicationService.dart';

class MonitoredChatPageController {
  final ChildService childService = GetIt.I.get();
  final ChildChatService childChatService = GetIt.I.get();
  final ChildMessageService childMessageService = GetIt.I.get();
  final ChildContactService childContactService = GetIt.I.get();
  final CommunicationService communicationService = GetIt.I.get();

  final MonitoredChatPageModel model = MonitoredChatPageModel();

  MonitoredChatPageController(String childNumber, String otherNumber) {
    communicationService.onChildMessageToParent = () {
      childMessageService
          .fetchAllByPhoneNumbers(childNumber, otherNumber)
          .then((messages) {
        model.messages = messages;
      });
    };

    communicationService.onContactToParent = () {
      reload(childNumber, otherNumber);
    };

    reload(childNumber, otherNumber);
  }

  void reload(String childNumber, String otherNumber) {
    childService.fetchByPhoneNumber(childNumber).then((child) {
      model.childName = child.name;
    });

    childChatService
        .fetchByNumbers(childNumber, otherNumber)
        .then((chat) async {
      String otherMemberName = chat.otherPartyNumber;

      final contacts =
          await childContactService.fetchAllContactsByChildNumber(childNumber);
      contacts.forEach((contact) {
        if (contact.contactPhoneNumber == chat.otherPartyNumber)
          otherMemberName = contact.name;
      });

      model.otherMemberName = otherMemberName;

      childMessageService
          .fetchAllByPhoneNumbers(chat.childPhoneNumber, chat.otherPartyNumber)
          .then((messages) {
        model.messages = messages;
      });
    });
  }
}
