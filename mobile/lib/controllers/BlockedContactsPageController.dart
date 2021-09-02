import 'package:get_it/get_it.dart';
import 'package:mobile/models/BlockedContactsPageModel.dart';
import 'package:mobile/services/ContactService.dart';

class BlockedContactsPageController {
  final ContactService contactService = GetIt.I.get();

  final BlockedContactsPageModel model = BlockedContactsPageModel();

  BlockedContactsPageController() {
    contactService.fetchAll().then((contacts) => model.contacts = contacts);
  }
}
