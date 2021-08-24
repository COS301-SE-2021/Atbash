import 'package:get_it/get_it.dart';
import 'package:mobile/domain/Chat.dart';
import 'package:mobile/domain/Contact.dart';
import 'package:mobile/domain/Message.dart';
import 'package:mobile/services/ChatService.dart';
import 'package:mobx/mobx.dart';
import 'package:uuid/uuid.dart';

part 'ChatListModel.g.dart';

class ChatListModel = _ChatListModel with _$ChatListModel;

abstract class _ChatListModel with Store {
  final ChatService chatService = GetIt.I.get();

  @observable
  ObservableList<Chat> chats = <Chat>[].asObservable();

  @action
  void init() {
    chatService.fetchAll().then((chatList) {
      chats = chatList.asObservable();
    });
  }

  @action
  Chat startChatWithContact(Contact contact, ChatType chatType) {
    // If specific type of chat already exists with contact, do nothing and return
    final index = chats.indexWhere((element) =>
        element.contactPhoneNumber == contact.phoneNumber &&
        element.chatType == chatType);

    if (index != -1) {
      return chats[index];
    }

    final chat = Chat(
      id: Uuid().v4(),
      contactPhoneNumber: contact.phoneNumber,
      contact: contact,
      chatType: chatType,
    );

    chatService.insert(chat);

    chats.add(chat);
    return chat;
  }

  @action
  Chat startChatWithPhoneNumber(String phoneNumber, ChatType chatType) {
    // If specific type of chat already exists with contact, do nothing and return
    final index = chats.indexWhere((element) =>
        element.contactPhoneNumber == phoneNumber &&
        element.chatType == chatType);

    if (index != -1) {
      return chats[index];
    }

    final chat = Chat(
      id: Uuid().v4(),
      contactPhoneNumber: phoneNumber,
      chatType: chatType,
    );

    chatService.insert(chat);

    chats.add(chat);
    return chat;
  }

  @action
  void deleteChat(String id) {
    chatService.deleteById(id);

    chats.removeWhere((element) => element.id == id);
  }

  @action
  void setChatContact(String chatId, Contact contact) {
    chats.firstWhere((e) => e.id == chatId).contact = contact;
  }

  @action
  void setChatMostRecentMessage(String chatId, Message message) {
    final chat = chats.firstWhere((e) => e.id == chatId);

    chat.mostRecentMessage = message;

    chatService.update(chat);
  }
}
