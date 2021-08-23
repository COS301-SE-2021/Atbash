import 'package:mobile/observables/ObservableContact.dart';
import 'package:mobx/mobx.dart';

part 'ContactListModel.g.dart';

class ContactListModel = _ContactListModel with _$ContactListModel;

abstract class _ContactListModel with Store {
  @observable
  ObservableList<ObservableContact> contacts =
      <ObservableContact>[].asObservable();

  @action
  void addContact(String phoneNumber, String displayName) {}

  @action
  void deleteContact(String phoneNumber) {
    contacts.removeWhere((element) => element.phoneNumber == phoneNumber);
  }

  @action
  void setContactBirthday(String phoneNumber, DateTime birthday) {
    contacts
        .firstWhere((element) => element.phoneNumber == phoneNumber)
        .birthday = birthday;
  }

  @action
  void setContactDisplayName(String phoneNumber, String displayName) {
    contacts
        .firstWhere((element) => element.phoneNumber == phoneNumber)
        .displayName = displayName;
  }

  @action
  void setContactStatus(String phoneNumber, String status) {
    contacts
        .firstWhere((element) => element.phoneNumber == phoneNumber)
        .status = status;
  }

  @action
  void setContactProfilePicture(
      String phoneNumber, String profilePictureBase64) {
    contacts
        .firstWhere((element) => element.phoneNumber == phoneNumber)
        .profileImage = profilePictureBase64;
  }
}
