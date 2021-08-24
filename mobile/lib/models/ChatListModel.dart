import 'package:mobile/domain/Chat.dart';
import 'package:mobile/observables/ObservableChat.dart';
import 'package:mobile/observables/ObservableContact.dart';
import 'package:mobile/observables/ObservableMessage.dart';
import 'package:mobx/mobx.dart';
import 'package:uuid/uuid.dart';

part 'ChatListModel.g.dart';

class ChatListModel = _ChatListModel with _$ChatListModel;

abstract class _ChatListModel with Store {
  @observable
  ObservableList<ObservableChat> chats = <ObservableChat>[].asObservable();

  @action
  void startChatWithContact(ObservableContact contact, ChatType chatType) {
    // If specific type of chat already exists with contact, do nothing and return
    if (chats.any((element) =>
        element.contactPhoneNumber == contact.phoneNumber &&
        element.chatType == chatType)) {
      return;
    }

    final chat = Chat(
      id: Uuid().v4(),
      contactPhoneNumber: contact.phoneNumber,
      contact: contact.contact,
      chatType: chatType,
    );

    // TODO persist chat

    chats.add(chat.asObservable());
  }

  @action
  void startChatWithPhoneNumber(String phoneNumber, ChatType chatType) {
    // If specific type of chat already exists with contact, do nothing and return
    if (chats.any((element) =>
        element.contactPhoneNumber == phoneNumber &&
        element.chatType == chatType)) {
      return;
    }

    final chat = Chat(
      id: Uuid().v4(),
      contactPhoneNumber: phoneNumber,
      chatType: chatType,
    );

    // TODO persist chat

    chats.add(chat.asObservable());
  }

  @action
  void deleteChat(String id) {
    // TODO remove from db

    chats.removeWhere((element) => element.id == id);
  }

  @action
  void setChatContact(String chatId, ObservableContact contact) {
    // TODO update in db

    chats.firstWhere((e) => e.id == chatId).contact = contact;
  }

  @action
  void setChatMostRecentMessage(String chatId, ObservableMessage message) {
    // TODO update in db

    chats.firstWhere((e) => e.id == chatId).mostRecentMessage = message;
  }
}
