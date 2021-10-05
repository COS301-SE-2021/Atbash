import 'dart:typed_data';

import 'package:mobile/domain/Chat.dart';
import 'package:mobile/domain/Contact.dart';
import 'package:mobile/domain/ProfanityWord.dart';
import 'package:mobx/mobx.dart';

part 'HomePageModel.g.dart';

class HomePageModel = _HomePageModel with _$HomePageModel;

abstract class _HomePageModel with Store {
  @observable
  String userDisplayName = "";

  @observable
  String userStatus = "";

  @observable
  Uint8List? userProfileImage;

  @observable
  bool profanityFilter = true;

  @observable
  bool blockSaveMedia = false;

  @observable
  ObservableList<Chat> chats = <Chat>[].asObservable();

  @observable
  List<ProfanityWord> profanityWords = <ProfanityWord>[].asObservable();

  @computed
  List<Chat> get orderedChats {
    final chatsCopy = List.of(chats);
    chatsCopy.sort((a, b) => _compareChats(a, b));
    return chatsCopy;
  }

  int _compareChats(Chat a, Chat b) {
    final aTimestamp = a.mostRecentMessage?.timestamp;
    final bTimestamp = b.mostRecentMessage?.timestamp;

    if (aTimestamp != null && bTimestamp != null) {
      return bTimestamp.compareTo(aTimestamp);
    } else if (aTimestamp != null && bTimestamp == null) {
      return -1;
    } else if (aTimestamp == null && bTimestamp != null) {
      return 1;
    } else {
      final aContact = a.contact;
      final bContact = b.contact;

      if (aContact != null && bContact != null) {
        return _compareContacts(aContact, bContact);
      } else if (aContact != null && bContact == null) {
        return -1;
      } else if (aContact == null && bContact != null) {
        return 1;
      } else {
        return a.contactPhoneNumber.compareTo(b.contactPhoneNumber);
      }
    }
  }

  int _compareContacts(Contact a, Contact b) {
    if (a.displayName != b.displayName) {
      return a.displayName.compareTo(b.displayName);
    } else {
      return a.phoneNumber.compareTo(b.phoneNumber);
    }
  }

  @action
  void addChat(Chat chat) {
    chats.add(chat);
  }

  @action
  void replaceChats(Iterable<Chat> chats) {
    this.chats.clear();
    this.chats.addAll(chats);
  }

  @action
  void removeChat(String chatId) {
    this.chats.removeWhere((chat) => chat.id == chatId);
  }
}
