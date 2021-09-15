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
      model.blockedNumbers.clear();
      model.blockedNumbers.addAll(numbers);
    });
  }

  Future<void> addNumber(String number) async {
    final blockedNumber = new BlockedNumber(phoneNumber: number);
    await blockedNumbersService.insert(blockedNumber);
    model.blockedNumbers.add(blockedNumber);
  }

  Future<void> deleteNumber(String number) async {
    final blockedNumber = new BlockedNumber(phoneNumber: number);
    await blockedNumbersService.delete(blockedNumber.phoneNumber);
    model.blockedNumbers
        .removeWhere((element) => element.phoneNumber == number);
  }

  void updateQuery(String query) {
    model.filter = query;
  }
}
