import 'package:get_it/get_it.dart';
import 'package:mobile/domain/Chat.dart';
import 'package:mobile/domain/Message.dart';
import 'package:mobile/services/CommunicationService.dart';
import 'package:mobile/services/MessageService.dart';
import 'package:mobx/mobx.dart';
import 'package:uuid/uuid.dart';

part 'MessagesModel.g.dart';

class MessagesModel = _MessagesModel with _$MessagesModel;

abstract class _MessagesModel with Store {
  final MessageService messageService = GetIt.I.get();
  final CommunicationService communicationService = GetIt.I.get();

  @observable
  ObservableList<Message> messages = <Message>[].asObservable();

  @observable
  Chat? openChat;

  _MessagesModel() {
    communicationService.onMessage = (message) {
      messageService.insert(message);
      communicationService.sendAck(message.id, message.otherPartyPhoneNumber);

      if (message.chatId == openChat?.id) {
        messages.insert(0, message);
        communicationService
            .sendAckSeen([message.id], message.otherPartyPhoneNumber);
      }
    };

    communicationService.onDelete = (messageId) {
      final message = messages.firstWhere((m) => m.id == messageId);
      message.deleted = true;
      message.contents = "";

      messageService.update(message);
    };

    communicationService.onAck = (messageId) async {
      messageService.fetchById(messageId).then((message) {
        message.readReceipt = ReadReceipt.delivered;
        messageService.update(message);
      });

      messages
          .where((m) => m.id == messageId)
          .forEach((m) => m.readReceipt = ReadReceipt.delivered);
    };

    communicationService.onAckSeen = (messageIds) async {
      messageService.fetchAllById(messageIds).then((messageList) {
        messageList.forEach((message) {
          message.readReceipt = ReadReceipt.seen;
          messageService.update(message);
        });
      });

      messages.where((m) => messageIds.any((e) => e == m.id)).forEach((m) {
        m.readReceipt = ReadReceipt.seen;
      });
    };
  }

  @action
  void enterChat(Chat chat) {
    openChat = chat;

    messages.clear();

    messageService.fetchAllByChatId(chat.id).then((messages) {
      this.messages = messages.asObservable();

      final unseenMessages = messages
          .where((m) => m.readReceipt != ReadReceipt.seen && m.isIncoming);

      final unseenMessagesIds = unseenMessages.map((e) => e.id).toList();

      if (unseenMessagesIds.length > 0) {
        unseenMessages.forEach((message) {
          message.readReceipt = ReadReceipt.seen;
          messageService.update(message);
        });

        communicationService.sendAckSeen(
            unseenMessagesIds, chat.contactPhoneNumber);
      }
    });
  }

  @action
  void sendMessage(Chat chat, String contents) {
    final chat = openChat;

    if (chat == null) {
      throw StateError("Attempting to sendMessage when openChat was null");
    }

    final message = Message(
      id: Uuid().v4(),
      chatId: chat.id,
      isIncoming: false,
      otherPartyPhoneNumber: chat.contactPhoneNumber,
      contents: contents,
      timestamp: DateTime.now(),
      readReceipt: ReadReceipt.undelivered,
      deleted: false,
      liked: false,
      tags: [],
    );

    communicationService.sendMessage(message, chat.contactPhoneNumber);

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
  void sendDeleteMessageRequest(String messageId, String recipientPhoneNumber) {
    communicationService.sendDelete(messageId, recipientPhoneNumber);

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
