import 'package:mobile/domain/Child.dart';
import 'package:mobile/domain/Contact.dart';
import 'package:mobx/mobx.dart';

part 'NewChildPageModel.g.dart';

class NewChildPageModel = _NewChildPageModel with _$NewChildPageModel;

abstract class _NewChildPageModel with Store {
  @observable
  List<Contact> contacts = <Contact>[].asObservable();

  @observable
  List<Child> children = <Child>[].asObservable();

  @observable
  String filter = "";

  @computed
  ObservableList<Contact> get filteredContacts => contacts
      .where((contact) =>
          contact.displayName.toLowerCase().contains(filter.toLowerCase()) &&
          !children.any((child) => child.phoneNumber == contact.phoneNumber))
      .toList()
      .asObservable();
}
