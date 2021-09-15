import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/dialogs/ForwardDialog.dart';
import 'package:mobile/domain/Chat.dart';
import 'package:mobile/domain/Contact.dart';
import 'package:mobile/domain/Message.dart';
import 'package:mobile/models/ChatPageModel.dart';
import 'package:mobile/pages/ChatPage.dart';
import 'package:mobile/services/ChatCacheService.dart';
import 'package:mobile/services/ChatService.dart';
import 'package:mobile/services/CommunicationService.dart';
import 'package:mobile/services/ContactService.dart';
import 'package:mobile/services/MemoryStoreService.dart';
import 'package:mobile/services/MessageService.dart';
import 'package:mobile/services/SettingsService.dart';
import 'package:uuid/uuid.dart';

class ChatPageController {
  final ChatService chatService = GetIt.I.get();
  final ContactService contactService = GetIt.I.get();
  final CommunicationService communicationService = GetIt.I.get();
  final MessageService messageService = GetIt.I.get();
  final ChatCacheService chatCacheService = GetIt.I.get();
  final MemoryStoreService memoryStoreService = GetIt.I.get();
  final SettingsService settingsService = GetIt.I.get();

  final ChatPageModel model = ChatPageModel();

  final String chatId;
  late final Future<Chat> chat;
  late final String contactPhoneNumber;

  ChatPageController({required this.chatId, Chat? privateChat}) {
    communicationService.onMessage(_onMessage);

    communicationService.onDelete(_onDelete);

    communicationService.onAck(_onAck);

    communicationService.onAckSeen(_onAckSeen);

    communicationService.onMessageLiked(_onMessageLiked);

    communicationService.shouldBlockNotifications =
        (senderPhoneNumber) => senderPhoneNumber == contactPhoneNumber;

    if (privateChat != null) {
      chat = Future.value(privateChat);
    } else {
      chat = chatService.fetchById(chatId);
    }

    chat.then((chat) {
      contactPhoneNumber = chat.contactPhoneNumber;
      model.contactTitle = chat.contact?.displayName ?? chat.contactPhoneNumber;
      model.contactStatus = chat.contact?.status ?? "";
      model.contactProfileImage = chat.contact?.profileImage ?? "";
      model.contactSaved = chat.contact != null;
      model.chatType = chat.chatType;

      if (memoryStoreService.isContactOnline(contactPhoneNumber)) {
        _onOnline(true);
      }
      memoryStoreService.onContactOnline(contactPhoneNumber, _onOnline);
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

    settingsService
        .getWallpaperImage()
        .then((value) => model.wallpaperImage = value);

    settingsService.getBlurImages().then((value) {
      model.blurImages = value;
    });
  }

  void _onOnline(bool online) {
    model.online = online;
  }

  void _onMessage(Message message) {
    if (message.chatId == chatId) {
      model.addMessage(message);
      communicationService.sendAckSeen([message.id], contactPhoneNumber);
      chat.then((chat) {
        if (chat.chatType == ChatType.general)
          messageService.setMessageReadReceipt(message.id, ReadReceipt.seen);
      });
    } else if (message.otherPartyPhoneNumber == contactPhoneNumber) {
      model.addMessage(message);
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
    communicationService.shouldBlockNotifications = (phoneNumber) => false;
    contactService.disposeOnChanged(_onContactChanged);
    memoryStoreService.disposeOnContactOnline(_onOnline);
    //communicationService.onStopPrivateChat = null;
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
    model.addMessage(message);
    chat.then((chat) {
      if (chat.chatType == ChatType.general) messageService.insert(message);
    });
  }

  void sendImage(Uint8List imageBytes) async {
    final message = Message(
      id: Uuid().v4(),
      chatId: chatId,
      isIncoming: false,
      otherPartyPhoneNumber: contactPhoneNumber,
      contents: base64Encode(imageBytes),
      timestamp: DateTime.now(),
      isMedia: true,
    );

    model.addMessage(message);
    communicationService.sendImage(
      message,
      ChatType.general,
      contactPhoneNumber,
    );
    chat.then((chat) {
      if (chat.chatType == ChatType.general) messageService.insert(message);
    });
  }

  void deleteMessagesLocally(List<String> ids) {
    chat.then((chat) {
      ids.forEach((id) {
        model.removeMessageById(id);
        if (chat.chatType == ChatType.general) messageService.deleteById(id);
      });
    });
  }

  void deleteMessagesRemotely(List<String> ids) {
    chat.then((chat) {
      ids.forEach((id) {
        communicationService.sendDelete(id, contactPhoneNumber);
        model.setDeletedById(id);
        if (chat.chatType == ChatType.general)
          messageService.setMessageDeleted(id);
      });
    });
  }

  void likeMessage(String messageId, bool liked) {
    communicationService.sendLiked(messageId, liked, contactPhoneNumber);
    model.setLikedById(messageId, liked);
    chat.then((chat) {
      if (chat.chatType == ChatType.general)
        messageService.setMessageLiked(messageId, liked);
    });
  }

  void addSenderAsContact(String displayName) {
    final contact = Contact(
      phoneNumber: contactPhoneNumber,
      displayName: displayName,
      status: "",
      profileImage: "",
    );

    communicationService.sendRequestProfileImage(contactPhoneNumber);
    communicationService.sendRequestStatus(contactPhoneNumber);

    model.contactSaved = true;
    model.contactTitle = displayName;

    chat.then((chat) {
      if (chat.chatType == ChatType.general) contactService.insert(contact);
    });
  }

  void storeTypedMessage(String message) {
    chat.then((chat) {
      if (chat.chatType == ChatType.general)
        chatCacheService.put(chatId, message);
    });
  }

  String getTypedMessage() {
    return chatCacheService.get(chatId);
  }

  void forwardMessage(
      BuildContext context, String message, String currentContactName) {
    contactService.fetchAll().then((contacts) {
      showForwardDialog(context, contacts, currentContactName)
          .then((forwardContacts) async {
        if (forwardContacts == null) return;

        final allChats = await chatService.fetchAll();

        final contactsWithNoChats = forwardContacts.where((contact) => !allChats
            .any((chat) => chat.contactPhoneNumber == contact.phoneNumber));

        await Future.wait(contactsWithNoChats.map((contact) async {
          final newChat = Chat(
              id: Uuid().v4(),
              contactPhoneNumber: contact.phoneNumber,
              chatType: ChatType.general);
          await chatService.insert(newChat);
        }));

        final allNumberChats = await chatService.fetchIdsByContactPhoneNumbers(
            forwardContacts.map((e) => e.phoneNumber).toList());

        allNumberChats.forEach((element) {
          final newMessage = Message(
            id: Uuid().v4(),
            chatId: element.second,
            isIncoming: false,
            otherPartyPhoneNumber: element.first,
            contents: message,
            timestamp: DateTime.now(),
            forwarded: true,
          );

          communicationService.sendMessage(
              newMessage, ChatType.general, element.first);
          messageService.insert(newMessage);
        });
      });
    });
  }

  void startPrivateChat(BuildContext context) async {
    communicationService.sendStartPrivateChat(contactPhoneNumber);
    Contact? contact;
    try {
      contact = await contactService.fetchByPhoneNumber(contactPhoneNumber);
    } on ContactWithPhoneNumberDoesNotExistException {
      contact = null;
    }

    final Chat chat = Chat(
      id: Uuid().v4(),
      contactPhoneNumber: contactPhoneNumber,
      chatType: ChatType.private,
      contact: contact,
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatPage.privateChat(
          privateChat: chat,
          chatId: chat.id,
        ),
      ),
    );
  }

  void stopPrivateChat() {
    communicationService.sendStopPrivateChat(contactPhoneNumber);
  }
}
