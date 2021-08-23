import 'package:mobile/domain/Message.dart';
import 'package:mobile/observables/ObservableChat.dart';
import 'package:mobile/observables/ObservableMessage.dart';
import 'package:mobx/mobx.dart';

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
  void sendMessage(String contents) {}

  @action
  void deleteMessagesLocally(String messageId) {}

  @action
  void sendReadReceipt(String messageId, ReadReceipt readReceipt) {}

  @action
  void sendDeleteMessageRequest(String messageId) {}

  @action
  void likeMessage(String messageId) {}
}
