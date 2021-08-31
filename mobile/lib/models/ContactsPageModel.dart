import 'package:mobile/domain/Contact.dart';
import 'package:mobx/mobx.dart';

part 'ContactsPageModel.g.dart';

class ContactsPageModel = _ContactsPageModel with _$ContactsPageModel;

abstract class _ContactsPageModel with Store {
  @observable
  ObservableList<Contact> contacts = <Contact>[].asObservable();

  @action
  void addContact(Contact contact) {
    contacts.add(contact);
    contacts.sort((a, b) => a.displayName.compareTo(b.displayName));
  }

  @action
  void removeContact(String phoneNumber) {
    contacts.removeWhere((element) => element.phoneNumber == phoneNumber);
  }
}
