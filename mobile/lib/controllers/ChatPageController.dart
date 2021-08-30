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
    communicationService.onMessage = _onMessage;

    communicationService.onDelete = _onDelete;

    communicationService.onAck = _onAck;

    communicationService.onAckSeen = _onAckSeen;

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

  void _onMessage(Message message) {
    model.addMessage(message);
  }

  void _onDelete(String messageId) {
    model.setDeletedById(messageId);
  }

  void _onAck(String messageId) {
    model.setReadReceiptById(messageId, ReadReceipt.delivered);
  }

  void _onAckSeen(List<String> messageIds) {
    messageIds.forEach((id) {
      model.setReadReceiptById(id, ReadReceipt.seen);
    });
  }

  void dispose() {
    communicationService.disposeOnMessage(_onMessage);
    communicationService.disposeOnDelete(_onDelete);
    communicationService.disposeOnAck(_onAck);
    communicationService.disposeOnAckSeen(_onAckSeen);
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
