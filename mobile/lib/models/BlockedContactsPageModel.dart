import 'package:mobile/domain/Contact.dart';
import 'package:mobx/mobx.dart';

part 'BlockedContactsPageModel.g.dart';

class BlockedContactsPageModel = _BlockedContactsPageModel
    with _$BlockedContactsPageModel;

abstract class _BlockedContactsPageModel with Store {
  @observable
  List<Contact> contacts = [];
}
