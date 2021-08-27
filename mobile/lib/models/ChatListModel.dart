import 'package:get_it/get_it.dart';
import 'package:mobile/domain/Chat.dart';
import 'package:mobile/domain/Contact.dart';
import 'package:mobile/domain/Message.dart';
import 'package:mobile/services/ChatService.dart';
import 'package:mobile/services/CommunicationService.dart';
import 'package:mobile/services/ContactService.dart';
import 'package:mobx/mobx.dart';
import 'package:uuid/uuid.dart';

part 'ChatListModel.g.dart';

class ChatListModel = _ChatListModel with _$ChatListModel;

abstract class _ChatListModel with Store {
  final ChatService chatService = GetIt.I.get();
  final ContactService contactService = GetIt.I.get();
  final CommunicationService communicationService = GetIt.I.get();

  @observable
  ObservableList<Chat> chats = <Chat>[].asObservable();

  _ChatListModel() {
    communicationService.onMessage = (message) async {
      final senderPhoneNumber = message.otherPartyPhoneNumber;

      final contacts = await contactService.fetchAll();

      final index = contacts
          .indexWhere((contact) => contact.phoneNumber == senderPhoneNumber);
      final contact = index != -1 ? contacts[index] : null;

      if (contact != null) {
        startChatWithContact(contact, ChatType.general,
            id: message.chatId, mostRecentMessage: message);
      } else {
        startChatWithPhoneNumber(senderPhoneNumber, ChatType.general,
            id: message.chatId, mostRecentMessage: message);
      }
    };
  }

  @action
  void init() {
    chatService.fetchAll().then((chatList) {
      chats = chatList.asObservable();
    });
  }

  @action
  Chat startChatWithContact(Contact contact, ChatType chatType,
      {String? id, Message? mostRecentMessage}) {
    // If specific type of chat already exists with contact, do nothing and return
    final index = chats.indexWhere((element) =>
        element.contactPhoneNumber == contact.phoneNumber &&
        element.chatType == chatType);

    if (index != -1) {
      return chats[index];
    }

    final chat = Chat(
      id: id ?? Uuid().v4(),
      contactPhoneNumber: contact.phoneNumber,
      contact: contact,
      mostRecentMessage: mostRecentMessage,
      chatType: chatType,
    );

    chatService.insert(chat);

    chats.add(chat);
    return chat;
  }

  @action
  Chat startChatWithPhoneNumber(String phoneNumber, ChatType chatType,
      {String? id, Message? mostRecentMessage}) {
    // If specific type of chat already exists with contact, do nothing and return
    final index = chats.indexWhere((element) =>
        element.contactPhoneNumber == phoneNumber &&
        element.chatType == chatType);

    if (index != -1) {
      return chats[index];
    }

    final chat = Chat(
      id: id ?? Uuid().v4(),
      contactPhoneNumber: phoneNumber,
      mostRecentMessage: mostRecentMessage,
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
