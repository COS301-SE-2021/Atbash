import 'package:mobile/domain/Chat.dart';
import 'package:mobile/domain/Contact.dart';
import 'package:mobile/domain/Message.dart';
import 'package:mobile/observables/ObservableChat.dart';
import 'package:mobx/mobx.dart';
import 'package:uuid/uuid.dart';

part 'ChatListModel.g.dart';

class ChatListModel = _ChatListModel with _$ChatListModel;

abstract class _ChatListModel with Store {
  @observable
  ObservableList<ObservableChat> chats = <ObservableChat>[].asObservable();

  @action
  void startChatWithContact(Contact contact, ChatType chatType) {
    // If specific type of chat already exists with contact, do nothing and return
    if (chats.any((element) =>
        element.contactPhoneNumber == contact.phoneNumber &&
        element.chatType == chatType)) {
      return;
    }

    final chat = Chat(
      id: Uuid().v4(),
      contactPhoneNumber: contact.phoneNumber,
      contact: contact,
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
  void setChatContact(String chatId, Contact contact) {}

  @action
  void setChatMostRecentMessage(String chatId, Message message) {}
}
