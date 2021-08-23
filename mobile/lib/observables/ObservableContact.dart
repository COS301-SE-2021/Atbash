import 'package:mobile/domain/Contact.dart';
import 'package:mobx/mobx.dart';

part 'ObservableContact.g.dart';

class ObservableContact = _ObservableContact with _$ObservableContact;

abstract class _ObservableContact with Store {
  final String phoneNumber;

  @observable
  String displayName;

  @observable
  String status;

  @observable
  String profileImage;

  @observable
  DateTime birthday;

  _ObservableContact(Contact c)
      : phoneNumber = c.phoneNumber,
        displayName = c.displayName,
        status = c.status,
        profileImage = c.profileImage,
        birthday = c.birthday;
}
