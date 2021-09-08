import 'package:get_it/get_it.dart';
import 'package:mobile/domain/BlockedNumber.dart';
import 'package:mobile/models/BlockedContactsPageModel.dart';
import 'package:mobile/services/BlockedNumbersService.dart';

class BlockedContactsPageController {
  final BlockedNumbersService blockedNumbersService = GetIt.I.get();

  final BlockedContactsPageModel model = BlockedContactsPageModel();

  BlockedContactsPageController() {
    reload();
  }

  void reload() {
    blockedNumbersService.fetchAll().then((numbers) {
      model.blockedNumbers = numbers;
    });
  }

  void addNumber(String number) {
    final blockedNumber = new BlockedNumber(phoneNumber: number);
    try {
      blockedNumbersService.insert(blockedNumber);
      model.blockedNumbers.add(blockedNumber);
    } on duplicateBlockedNumberException {
      //:TODO display error message
    }
  }

  void deleteNumber(String number) {
    final blockedNumber = new BlockedNumber(phoneNumber: number);
    try {
      blockedNumbersService.delete(blockedNumber.phoneNumber);
      model.blockedNumbers.remove(blockedNumber);
    } on blockedNumberDoesNotExistException {}
    //TODO: Display error message
  }
}
