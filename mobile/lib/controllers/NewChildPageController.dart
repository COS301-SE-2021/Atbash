import 'package:get_it/get_it.dart';
import 'package:mobile/models/NewChildPageModel.dart';
import 'package:mobile/services/ChildService.dart';
import 'package:mobile/services/CommunicationService.dart';
import 'package:mobile/services/ContactService.dart';
import 'package:mobile/services/UserService.dart';

class NewChildPageController {
  final ContactService contactService = GetIt.I.get();
  final ChildService childService = GetIt.I.get();
  final CommunicationService communicationService = GetIt.I.get();
  final UserService userService = GetIt.I.get();

  final NewChildPageModel model = NewChildPageModel();

  NewChildPageController() {
    contactService.fetchAll().then((contacts) async {
      model.contacts.clear();
      model.contacts.addAll(contacts);
    });
    childService.fetchAll().then((children) async {
      model.children.clear();
      model.children.addAll(children);
    });
  }

  void updateQuery(String query) {
    model.filter = query;
  }

  void addChild(String childNumber, String code) async {
    final name = await userService.getDisplayName();
    communicationService.sendAddChild(childNumber, name, code);
  }
}
