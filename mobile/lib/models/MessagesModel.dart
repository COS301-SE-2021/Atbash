import 'package:mobile/domain/Message.dart';
import 'package:mobile/observables/ObservableChat.dart';
import 'package:mobile/observables/ObservableMessage.dart';
import 'package:mobx/mobx.dart';
import 'package:uuid/uuid.dart';

part 'MessagesModel.g.dart';

class MessagesModel = _MessagesModel with _$MessagesModel;

abstract class _MessagesModel with Store {
  @observable
  ObservableList<ObservableMessage> messages =
      <ObservableMessage>[].asObservable();

  @observable
  ObservableChat? openChat;

  @action
  void enterChat(ObservableChat chat) {
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

    messages.add(message.asObservable());
  }

  @action
  void deleteMessageLocally(String messageId) {
    // TODO delete from db

    messages.removeWhere((m) => m.id == messageId);
  }

  @action
  void sendMessageSeen(String messageId) {}

  @action
  void sendDeleteMessageRequest(String messageId) {}

  @action
  void likeMessage(String messageId) {}
}
