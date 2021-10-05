import 'package:mobile/domain/ChildBlockedNumber.dart';
import 'package:mobile/domain/ChildContact.dart';
import 'package:mobx/mobx.dart';

part 'ChildBlockedContactsPageModel.g.dart';

class ChildBlockedContactsPageModel = _ChildBlockedContactsPageModel
    with _$ChildBlockedContactsPageModel;

abstract class _ChildBlockedContactsPageModel with Store {
  @observable
  ObservableList<ChildBlockedNumber> blockedNumbers =
      <ChildBlockedNumber>[].asObservable();

  @observable
  ObservableList<ChildContact> contacts = <ChildContact>[].asObservable();

  @observable
  String childName = "";

  @observable
  String filter = "";

  @computed
  ObservableList<ChildBlockedNumber> get filteredNumbers => blockedNumbers
      .where((element) => element.blockedNumber.contains(filter))
      .toList()
      .asObservable();
}
