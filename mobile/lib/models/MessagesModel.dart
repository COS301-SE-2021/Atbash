import 'package:get_it/get_it.dart';
import 'package:mobile/domain/Chat.dart';
import 'package:mobile/domain/Message.dart';
import 'package:mobile/services/MessageService.dart';
import 'package:mobx/mobx.dart';
import 'package:uuid/uuid.dart';

part 'MessagesModel.g.dart';

class MessagesModel = _MessagesModel with _$MessagesModel;

abstract class _MessagesModel with Store {
  final MessageService messageService = GetIt.I.get();

  @observable
  ObservableList<Message> messages = <Message>[].asObservable();

  @observable
  Chat? openChat;

  @action
  void enterChat(Chat chat) {
    openChat = chat;

    messages.clear();

    messageService
        .fetchAllBySenderOrRecipient(chat.contactPhoneNumber)
        .then((messages) {
      this.messages = messages.asObservable();
    });
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

    messageService.insert(message);

    messages.insert(0, message);
  }

  @action
  void deleteMessageLocally(String messageId) {
    messageService.deleteById(messageId);

    messages.removeWhere((m) => m.id == messageId);
  }

  @action
  void sendMessageSeen(String messageId) {
    // TODO send to remote

    final message = messages.firstWhere((m) => m.id == messageId);
    message.readReceipt = ReadReceipt.seen;

    messageService.update(message);
  }

  @action
  void sendDeleteMessageRequest(String messageId) {
    // TODO send to remote

    final message = messages.firstWhere((m) => m.id == messageId);
    message.deleted = true;
    message.contents = "";

    messageService.update(message);
  }

  @action
  void likeMessage(String messageId) {
    // TODO send to remote

    final message = messages.firstWhere((m) => m.id == messageId);
    message.liked = true;

    messageService.update(message);
  }
}
