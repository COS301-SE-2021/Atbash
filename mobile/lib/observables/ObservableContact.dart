import 'package:mobile/domain/Contact.dart';
import 'package:mobx/mobx.dart';

part 'ObservableContact.g.dart';

class ObservableContact = _ObservableContact with _$ObservableContact;

abstract class _ObservableContact with Store {
  final Contact contact;

  final String phoneNumber;

  @observable
  String displayName;

  @observable
  String status;

  @observable
  String profileImage;

  @observable
  DateTime? birthday;

  _ObservableContact(this.contact)
      : phoneNumber = contact.phoneNumber,
        displayName = contact.displayName,
        status = contact.status,
        profileImage = contact.profileImage,
        birthday = contact.birthday;
}

extension ContactExtension on Contact {
  ObservableContact asObservable() {
    return ObservableContact(this);
  }
}
