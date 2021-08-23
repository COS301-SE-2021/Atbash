import 'package:mobile/domain/Contact.dart';
import 'package:mobile/observables/ObservableContact.dart';
import 'package:mobx/mobx.dart';

part 'ContactListModel.g.dart';

class ContactListModel = _ContactListModel with _$ContactListModel;

abstract class _ContactListModel with Store {
  @observable
  ObservableList<ObservableContact> contacts =
      <ObservableContact>[].asObservable();

  @action
  void addContact(String phoneNumber, String displayName) {
    final contact = Contact(
      phoneNumber: phoneNumber,
      displayName: displayName,
      status: "",
      profileImage: "",
    );

    // TODO persist to db

    contacts.add(contact.asObservable());
  }

  @action
  void deleteContact(String phoneNumber) {
    // TODO remove from db

    contacts.removeWhere((element) => element.phoneNumber == phoneNumber);
  }

  @action
  void setContactBirthday(String phoneNumber, DateTime birthday) {
    // TODO update in db

    contacts
        .firstWhere((element) => element.phoneNumber == phoneNumber)
        .birthday = birthday;
  }

  @action
  void setContactDisplayName(String phoneNumber, String displayName) {
    // TODO update in db

    contacts
        .firstWhere((element) => element.phoneNumber == phoneNumber)
        .displayName = displayName;
  }

  @action
  void setContactStatus(String phoneNumber, String status) {
    // TODO update in db

    contacts
        .firstWhere((element) => element.phoneNumber == phoneNumber)
        .status = status;
  }

  @action
  void setContactProfilePicture(
      // TODO update in db

      String phoneNumber,
      String profilePictureBase64) {
    contacts
        .firstWhere((element) => element.phoneNumber == phoneNumber)
        .profileImage = profilePictureBase64;
  }
}
