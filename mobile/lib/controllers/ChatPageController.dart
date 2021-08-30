import 'package:get_it/get_it.dart';
import 'package:mobile/domain/Message.dart';
import 'package:mobile/models/ChatPageModel.dart';
import 'package:mobile/services/ChatService.dart';
import 'package:mobile/services/CommunicationService.dart';
import 'package:mobile/services/ContactService.dart';
import 'package:mobile/services/MessageService.dart';
import 'package:uuid/uuid.dart';

class ChatPageController {
  final ChatService chatService = GetIt.I.get();
  final ContactService contactService = GetIt.I.get();
  final CommunicationService communicationService = GetIt.I.get();
  final MessageService messageService = GetIt.I.get();

  final ChatPageModel model = ChatPageModel();

  final String chatId;
  late final String contactPhoneNumber;

  ChatPageController({required this.chatId}) {
    communicationService.onMessage = (message) {
      model.addMessage(message);
    };

    communicationService.onAck = (messageId) {
      model.setReadReceiptById(messageId, ReadReceipt.delivered);
    };

    communicationService.onAckSeen = (messageIds) {
      messageIds.forEach((id) {
        model.setReadReceiptById(id, ReadReceipt.seen);
      });
    };

    chatService.fetchById(chatId).then((chat) {
      contactPhoneNumber = chat.contactPhoneNumber;
      model.contactTitle = chat.contact?.displayName ?? chat.contactPhoneNumber;
      model.contactStatus = chat.contact?.status ?? "";
      model.contactProfileImage = chat.contact?.profileImage ?? "";
    });

    messageService
        .fetchAllByChatId(chatId)
        .then((messages) => model.replaceMessages(messages));
  }

  void sendMessage(String contents) {
    final message = Message(
      id: Uuid().v4(),
      chatId: chatId,
      isIncoming: false,
      otherPartyPhoneNumber: contactPhoneNumber,
      contents: contents,
      timestamp: DateTime.now(),
    );

    communicationService.sendMessage(message, contactPhoneNumber);
    messageService.insert(message);
    model.addMessage(message);
  }

  void deleteMessagesLocally(List<String> ids) {
    ids.forEach((id) {
      messageService.deleteById(id);
      model.removeMessageById(id);
    });
  }

  void deleteMessagesRemotely(List<String> ids) {
    ids.forEach((id) {
      communicationService.sendDelete(id, contactPhoneNumber);
      messageService.setMessageDeleted(id);
      model.setDeletedById(id);
    });
  }
}