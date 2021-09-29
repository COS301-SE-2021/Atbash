import 'package:get_it/get_it.dart';
import 'package:mobile/domain/ChildBlockedNumber.dart';
import 'package:mobile/models/ChildBlockedContactsPageModel.dart';
import 'package:mobile/services/ChildBlockedNumberService.dart';
import 'package:mobile/services/ChildChatService.dart';
import 'package:uuid/uuid.dart';

class ChildBlockedContactsPageController {
  final ChildBlockedNumberService childBlockedNumberService = GetIt.I.get();
  final ChildChatService childChatService = GetIt.I.get();

  final ChildBlockedContactsPageModel model = ChildBlockedContactsPageModel();

  ChildBlockedContactsPageController(String phoneNumber) {
    reload(phoneNumber);
  }

  void reload(String phoneNumber) {
    childChatService.fetchAllChatsByChildNumber(phoneNumber).then((chats) {
      model.chats.clear();
      model.chats.addAll(chats);
    });
    childBlockedNumberService.fetchAllByNumber(phoneNumber).then((numbers) {
      model.blockedNumbers.clear();
      model.blockedNumbers.addAll(numbers);
    });
  }

  Future<void> addNumber(String childNumber, String numberToAdd) async {
    final blockedNumber = new ChildBlockedNumber(
        id: Uuid().v4(), childNumber: childNumber, blockedNumber: numberToAdd);
    await childBlockedNumberService.insert(blockedNumber);
    model.blockedNumbers.add(blockedNumber);
    //TODO send blocked number to child
  }

  Future<void> deleteNumber(String childNumber, String numberToDelete) async {
    await childBlockedNumberService.delete(childNumber, numberToDelete);
    model.blockedNumbers
        .removeWhere((element) => element.blockedNumber == numberToDelete);
  }

  void updateQuery(String query) {
    model.filter = query;
  }
}
