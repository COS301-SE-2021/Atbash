import 'package:mobile/domain/Chat.dart';
import 'package:mobile/domain/Message.dart';
import 'package:mobx/mobx.dart';
import 'package:uuid/uuid.dart';

part 'MessagesModel.g.dart';

class MessagesModel = _MessagesModel with _$MessagesModel;

abstract class _MessagesModel with Store {
  @observable
  ObservableList<Message> messages = <Message>[].asObservable();

  @observable
  Chat? openChat;

  @action
  void enterChat(Chat chat) {
    openChat = chat;

    // TODO fetch messages
  }

  @action
  void sendMessage(String userPhoneNumber, String contents) {
    // TODO send to remote

    final chat = openChat;

    if (chat == null) {
      throw StateError("Attempting to sendMessage when openChat was null");
    }

    final message = Message(
      id: Uuid().v4(),
      senderPhoneNumber: userPhoneNumber,
      recipientPhoneNumber: chat.contactPhoneNumber,
      contents: contents,
      timestamp: DateTime.now(),
      readReceipt: ReadReceipt.undelivered,
      deleted: false,
      liked: false,
      tags: [],
    );

    // TODO persist message

    messages.insert(0, message);
  }

  @action
  void deleteMessageLocally(String messageId) {
    // TODO delete from db

    messages.removeWhere((m) => m.id == messageId);
  }

  @action
  void sendMessageSeen(String messageId) {
    // TODO send to remote

    final message = messages.firstWhere((m) => m.id == messageId);
    message.readReceipt = ReadReceipt.seen;

    // TODO persist changes
  }

  @action
  void sendDeleteMessageRequest(String messageId) {
    // TODO send to remote

    final message = messages.firstWhere((m) => m.id == messageId);
    message.deleted = true;
    message.contents = "";

    // TODO persist changes
  }

  @action
  void likeMessage(String messageId) {
    // TODO send to remote

    final message = messages.firstWhere((m) => m.id == messageId);
    message.liked = true;

    // TODO persist changes
  }
}
