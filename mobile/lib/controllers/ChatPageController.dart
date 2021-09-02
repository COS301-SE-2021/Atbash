import 'package:get_it/get_it.dart';
import 'package:mobile/domain/Chat.dart';
import 'package:mobile/domain/Contact.dart';
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
  late final Future<Chat> chat;
  late final String contactPhoneNumber;

  ChatPageController({required this.chatId}) {
    communicationService.onMessage(_onMessage);

    communicationService.onDelete(_onDelete);

    communicationService.onAck(_onAck);

    communicationService.onAckSeen(_onAckSeen);

    communicationService.onMessageLiked(_onMessageLiked);

    chat = chatService.fetchById(chatId);
    chat.then((chat) {
      contactPhoneNumber = chat.contactPhoneNumber;
      model.contactTitle = chat.contact?.displayName ?? chat.contactPhoneNumber;
      model.contactStatus = chat.contact?.status ?? "";
      model.contactProfileImage = chat.contact?.profileImage ?? "";
      model.contactSaved = chat.contact != null;
    });

    contactService.onChanged(_onContactChanged);

    messageService.fetchAllByChatId(chatId).then((messages) {
      final unseenMessagesIds = messages
          .where((message) =>
              message.readReceipt != ReadReceipt.seen && message.isIncoming)
          .map((m) => m.id);

      unseenMessagesIds.forEach((id) {
        messageService.setMessageReadReceipt(id, ReadReceipt.seen);
      });

      communicationService.sendAckSeen(
          unseenMessagesIds.toList(), contactPhoneNumber);

      model.replaceMessages(messages);
    });
  }

  void _onMessage(Message message) {
    if (message.chatId == chatId) {
      model.addMessage(message);
      messageService.setMessageReadReceipt(message.id, ReadReceipt.seen);
      communicationService.sendAckSeen([message.id], contactPhoneNumber);
    }
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

  void _onContactChanged() {
    try {
      contactService.fetchByPhoneNumber(contactPhoneNumber).then((contact) {
        model.contactTitle = contact.displayName;
        model.contactStatus = contact.status;
        model.contactProfileImage = contact.profileImage;
      });
    } on ContactWithPhoneNumberDoesNotExistException {}
  }

  void _onMessageLiked(String messageID, bool liked) {
    model.setLikedById(messageID, liked);
  }

  void dispose() {
    communicationService.disposeOnMessage(_onMessage);
    communicationService.disposeOnDelete(_onDelete);
    communicationService.disposeOnAck(_onAck);
    communicationService.disposeOnAckSeen(_onAckSeen);
    contactService.disposeOnChanged(_onContactChanged);
  }

  void sendMessage(String contents) async {
    final message = Message(
      id: Uuid().v4(),
      chatId: chatId,
      isIncoming: false,
      otherPartyPhoneNumber: contactPhoneNumber,
      contents: contents.trim(),
      timestamp: DateTime.now(),
    );

    final chatType = (await chat).chatType;

    communicationService.sendMessage(message, chatType, contactPhoneNumber);
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

  void likeMessage(String messageId, bool liked) {
    communicationService.sendLiked(messageId, liked, contactPhoneNumber);
    messageService.setMessageLiked(messageId, liked);
    model.setLikedById(messageId, liked);
  }

  void addSenderAsContact(String displayName) {
    final contact = Contact(
      phoneNumber: contactPhoneNumber,
      displayName: displayName,
      status: "",
      profileImage: "",
    );

    contactService.insert(contact);

    communicationService.sendRequestProfileImage(contactPhoneNumber);
    communicationService.sendRequestStatus(contactPhoneNumber);

    model.contactSaved = true;
    model.contactTitle = displayName;
  }
}
