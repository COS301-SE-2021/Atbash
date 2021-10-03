import 'package:mobile/domain/BlockedNumber.dart';
import 'package:mobile/domain/Contact.dart';
import 'package:mobx/mobx.dart';

part 'BlockedContactsPageModel.g.dart';

class BlockedContactsPageModel = _BlockedContactsPageModel
    with _$BlockedContactsPageModel;

abstract class _BlockedContactsPageModel with Store {
  @observable
  ObservableList<BlockedNumber> blockedNumbers =
      <BlockedNumber>[].asObservable();

  @observable
  ObservableList<Contact> contacts = <Contact>[].asObservable();

  @observable
  String filter = "";

  @observable
  String? parentNumber;

  @computed
  ObservableList<BlockedNumber> get filteredNumbers => blockedNumbers
      .where((element) => element.phoneNumber.contains(filter))
      .toList()
      .asObservable();
}
