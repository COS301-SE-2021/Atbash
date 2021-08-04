import 'package:mobile/domain/Contact.dart';
import 'package:mobile/services/DatabaseService.dart';
import 'package:mobx/mobx.dart';

part 'ContactsModel.g.dart';

class ContactsModel = ContactsModelBase with _$ContactsModel;

abstract class ContactsModelBase with Store {
  final DatabaseService _databaseService;

  ContactsModelBase(this._databaseService);

  @observable
  ObservableList<Contact> contacts = <Contact>[].asObservable();

  @computed
  ObservableList<Contact> get savedContacts =>
      ObservableList.of(contacts.where((c) => c.saved));

  @action
  void addContact(Contact c) => this.contacts.add(c);

  @action
  Future<void> initialise() async {
    final contacts = await _databaseService.fetchContacts();
    this.contacts.addAll(contacts);
  }
}
