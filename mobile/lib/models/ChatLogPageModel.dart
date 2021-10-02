import 'package:mobile/domain/ChildBlockedNumber.dart';
import 'package:mobile/domain/ChildChat.dart';
import 'package:mobile/domain/ChildContact.dart';
import 'package:mobx/mobx.dart';

part 'ChatLogPageModel.g.dart';

class ChatLogPageModel = _ChatLogPageModel with _$ChatLogPageModel;

abstract class _ChatLogPageModel with Store {
  @observable
  String childName = "";

  @observable
  List<ChildChat> chats = <ChildChat>[].asObservable();

  @observable
  List<ChildBlockedNumber> blockedNumbrs = <ChildBlockedNumber>[].asObservable();

  @observable
  List<ChildContact> contacts = <ChildContact>[].asObservable();

  @computed
  List<ChildChat> get sortedChats {
    List<ChildChat> chatCopy = List.of(chats);
    chatCopy.sort((a, b) => _compareChats(a, b));
    return chatCopy;
  }

  int _compareChats(ChildChat a, ChildChat b) {
    ChildContact? aContact;
    ChildContact? bContact;

    contacts.forEach((contact) {
      if (contact.contactPhoneNumber == a.otherPartyNumber) aContact = contact;
      if (contact.contactPhoneNumber == b.otherPartyNumber) bContact = contact;
    });

    if (aContact != null && bContact != null) {
      return _compareContacts(aContact, bContact);
    } else if (aContact != null && bContact == null) {
      return -1;
    } else if (aContact == null && bContact != null) {
      return 1;
    } else {
      return a.otherPartyNumber.compareTo(b.otherPartyNumber);
    }
  }

  int _compareContacts(ChildContact? a, ChildContact? b) {
    if (a != null && b != null) {
      if (a.name != b.name) {
        return a.name.compareTo(b.name);
      } else {
        return a.contactPhoneNumber.compareTo(b.contactPhoneNumber);
      }
    }
    return -1;
  }
}
