import 'package:get_it/get_it.dart';
import 'package:mobile/domain/BlockedNumber.dart';
import 'package:mobile/domain/ChildBlockedNumber.dart';
import 'package:mobile/models/ChildBlockedContactsPageModel.dart';
import 'package:mobile/services/ChildBlockedNumberService.dart';
import 'package:mobile/services/ChildContactService.dart';
import 'package:mobile/services/ChildService.dart';
import 'package:mobile/services/CommunicationService.dart';
import 'package:uuid/uuid.dart';

class ChildBlockedContactsPageController {
  final ChildBlockedNumberService childBlockedNumberService = GetIt.I.get();
  final ChildContactService childContactService = GetIt.I.get();
  final CommunicationService communicationService = GetIt.I.get();
  final ChildService childService = GetIt.I.get();

  final ChildBlockedContactsPageModel model = ChildBlockedContactsPageModel();

  ChildBlockedContactsPageController(String childNumber) {
    communicationService.onBlockedNumberToParent = () {
      childBlockedNumberService.fetchAllByNumber(childNumber).then((numbers) {
        model.blockedNumbers.clear();
        model.blockedNumbers.addAll(numbers);
      });
    };
    reload(childNumber);
  }

  void reload(String childNumber) {
    childContactService
        .fetchAllContactsByChildNumber(childNumber)
        .then((contacts) {
      model.contacts.clear();
      model.contacts.addAll(contacts);
    });
    childBlockedNumberService.fetchAllByNumber(childNumber).then((numbers) {
      model.blockedNumbers.clear();
      model.blockedNumbers.addAll(numbers);
    });
    childService.fetchByPhoneNumber(childNumber).then((child) {
      model.childName = child.name;
    });
  }

  Future<void> addNumber(String childNumber, String numberToAdd) async {
    final blockedNumber = new ChildBlockedNumber(
        id: Uuid().v4(), childNumber: childNumber, blockedNumber: numberToAdd);
    await childBlockedNumberService.insert(blockedNumber);
    model.blockedNumbers.add(blockedNumber);
    communicationService.sendBlockedNumberToChild(
        childNumber, BlockedNumber(phoneNumber: numberToAdd), "insert");
  }

  Future<void> deleteNumber(String childNumber, String numberToDelete) async {
    await childBlockedNumberService.delete(childNumber, numberToDelete);
    model.blockedNumbers
        .removeWhere((element) => element.blockedNumber == numberToDelete);
    communicationService.sendBlockedNumberToChild(
        childNumber, BlockedNumber(phoneNumber: numberToDelete), "delete");
  }

  void updateQuery(String query) {
    model.filter = query;
  }
}
