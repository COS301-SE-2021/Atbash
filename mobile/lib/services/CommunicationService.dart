import 'dart:async';
import 'dart:convert';
import 'package:crypton/crypton.dart';
import 'package:http/http.dart';
import 'package:mobile/constants.dart';
import 'package:mobile/domain/Chat.dart';
import 'package:mobile/domain/Message.dart';
import 'package:mobile/services/BlockedNumbersService.dart';
import 'package:mobile/services/ChatService.dart';
import 'package:mobile/services/ContactService.dart';
import 'package:mobile/services/EncryptionService.dart';
import 'package:mobile/services/MediaService.dart';
import 'package:mobile/services/MemoryStoreService.dart';
import 'package:mobile/services/MessageService.dart';
import 'package:mobile/services/NotificationService.dart';
import 'package:mobile/services/SettingsService.dart';
import 'package:mobile/services/UserService.dart';
import 'package:mobile/services/MessageboxService.dart';
import 'package:uuid/uuid.dart';
import 'package:web_socket_channel/io.dart';

import 'package:synchronized/synchronized.dart';


class CommunicationService {
  final BlockedNumbersService blockedNumbersService;
  final EncryptionService encryptionService;
  final UserService userService;
  final ChatService chatService;
  final ContactService contactService;
  final MessageService messageService;
  final SettingsService settingsService;
  final MediaService mediaService;
  final MemoryStoreService memoryStoreService;
  final NotificationService notificationService;
  final MessageboxService messageboxService;

  var communicationLock = new Lock();

  IOWebSocketChannel? channelNumber;
  IOWebSocketChannel? channelAnonymous;
  late StreamSubscription? streamSubscriptionAnonymous;
  StreamController<MessagePayload> _messageQueue = StreamController();

  List<void Function(Message message)> _onMessageListeners = [];
  List<void Function(String messageId)> _onDeleteListeners = [];
  List<void Function(String messageId)> _onAckListeners = [];
  List<void Function(List<String> messageIds)> _onAckSeenListeners = [];
  List<void Function(String messageID, bool liked)> _onMessageLikedListeners =
      [];
  List<void Function(String senderPhoneNumber)> _onPrivateChatListeners = [];
  List<void Function(String messageID, String messageContents)>
      _onMessageEditListeners = [];
  void Function(String senderPhoneNumber)? onStopPrivateChat;
  void Function()? onAcceptPrivateChat;
  bool Function(String incomingPhoneNumber) shouldBlockNotifications =
      (number) => false;

  void onMessage(void Function(Message message) cb) =>
      _onMessageListeners.add(cb);

  void disposeOnMessage(void Function(Message message) cb) =>
      _onMessageListeners.remove(cb);

  void onDelete(void Function(String messageId) cb) =>
      _onDeleteListeners.add(cb);

  void disposeOnDelete(void Function(String messageId) cb) =>
      _onDeleteListeners.remove(cb);

  void onAck(void Function(String messageId) cb) => _onAckListeners.add(cb);

  void disposeOnAck(void Function(String messageId) cb) =>
      _onAckListeners.remove(cb);

  void onAckSeen(void Function(List<String> messageIds) cb) =>
      _onAckSeenListeners.add(cb);

  void disposeOnAckSeen(void Function(List<String> messageIds) cb) =>
      _onAckSeenListeners.remove(cb);

  void onMessageLiked(void Function(String messageID, bool liked) cb) =>
      _onMessageLikedListeners.add(cb);

  void disposeOnMessageLiked(void Function(String messageID, bool liked) cb) =>
      _onMessageLikedListeners.remove(cb);

  void onMessageEdited(
          void Function(String messageID, String messageContents) cb) =>
      _onMessageEditListeners.add(cb);

  void disposeOnMessageEdited(
          void Function(String messageID, String messageContents) cb) =>
      _onMessageEditListeners.remove(cb);

  CommunicationService(
    this.blockedNumbersService,
    this.encryptionService,
    this.userService,
    this.chatService,
    this.contactService,
    this.messageService,
    this.settingsService,
    this.mediaService,
    this.memoryStoreService,
    this.notificationService,
    this.messageboxService,
  ) {
    final uri = Uri.parse("${Constants.httpUrl}messages");

    _messageQueue.stream.listen(
      (payload) async {
        await communicationLock.synchronized(() async {

          var messagePayload;
          final messagebox = await messageboxService.fetchMessageboxForNumber(payload.recipientPhoneNumber);

          if(messagebox == null || messagebox.recipientId == null){
            //Get mailbox id
            //Encrypt id with contents
            String? senderMid;
            if(messagebox == null) {
              senderMid = await messageboxService
                  .createMessageBox(payload.recipientPhoneNumber);
              if (senderMid == null) {
                print("Failed to createMessagebox for sending message");
                return;
              }
            } else {
              senderMid = messagebox.id;
            }
            final encryptedContents = await encryptionService.encryptMessageContent(
                jsonEncode({
                  "senderMid": senderMid,
                  "rsaKey": (await userService.fetchRSAKeyPair()).publicKey.toString(),
                  "messageContents": payload.contents
                }),
                payload.recipientPhoneNumber);
            final senderNumberEncrypted = await encryptionService.encryptNumberFor(payload.recipientPhoneNumber);

            if(senderNumberEncrypted == null){
              print("Failed to encrypt number using rsa key");
              return;
            }

            messagePayload = {
              "id": payload.id,
              "recipientPhoneNumber": payload.recipientPhoneNumber,
              "senderNumberEncrypted": senderNumberEncrypted,
              "encryptedContents": encryptedContents
            };
          } else {
            final senderMid = messagebox.id;
            final encryptedContents = await encryptionService.encryptMessageContent(
                jsonEncode({
                  "senderMid": senderMid,
                  "messageContents": payload.contents
                }),
                payload.recipientPhoneNumber);
            final recipientMid = messagebox.recipientId!;

            messagePayload = {
              "id": payload.id,
              "recipientMid": recipientMid,
              "encryptedContents": encryptedContents
            };
          }

          await post(uri, body: jsonEncode(messagePayload));
        });
      },
      onDone: () => _messageQueue.close(),
    );
  }

  Future<void> goOnline() async {
    final phoneNumber = await userService.getPhoneNumber();

    final encodedPhoneNumber = Uri.encodeQueryComponent(phoneNumber);

    await _fetchUnreadMessages(encodedPhoneNumber);
    await encryptionService.managePreKeys();

    channelNumber?.sink.close();
    channelNumber = IOWebSocketChannel.connect(
      Uri.parse("${Constants.webSocketUrl}?phoneNumber=$encodedPhoneNumber"),
      pingInterval: Duration(minutes: 9),
    );

    channelNumber?.stream.listen((event) async {
      await _handleEvent(event);
    });

    channelAnonymous?.sink.close();
    channelAnonymous = IOWebSocketChannel.connect(
      Uri.parse("${Constants.webSocketUrl}?phoneNumber=$encodedPhoneNumber"),
      pingInterval: Duration(minutes: 9),
    );

    streamSubscriptionAnonymous = channelAnonymous?.stream.listen((event) async {

      if(streamSubscriptionAnonymous != null && streamSubscriptionAnonymous!.isPaused == false){
        streamSubscriptionAnonymous!.pause();

        final connectionId = event as String;

        final List<String> ids = await messageboxService.getAllMessageboxIds();

        ids.forEach((element) {
          final uri = Uri.parse(
              Constants.httpUrl + "messageboxes/$element/connectionId");
          put(uri, body: connectionId);
        });

        channelAnonymous?.stream.listen((event) async {
          await _handleEvent(event);
        });

        streamSubscriptionAnonymous!.cancel();
        streamSubscriptionAnonymous = null;
      }
    });

    await contactService.fetchAll().then((contacts) {
      contacts.forEach((contact) {
        final encodedContactPhoneNumber =
            Uri.encodeQueryComponent(contact.phoneNumber);
        final uri = Uri.parse(
            Constants.httpUrl + "user/$encodedContactPhoneNumber/online");
        get(uri).then((response) {
          if (response.statusCode == 200) {
            final online = response.body == "true";
            if (online) {
              memoryStoreService.addOnlineContact(contact.phoneNumber);
            }
          }
        });
      });
    });
  }

  Future<void> _fetchUnreadMessages(String encodedPhoneNumber) async {
    final uri = Uri.parse(
        Constants.httpUrl + "message?phoneNumber=$encodedPhoneNumber");
    final response = await get(uri);

    if (response.statusCode == 200) {
      final messages = jsonDecode(response.body) as List;
      messages.forEach((message) async => await _handleEvent(message));
    } else {
      print("${response.statusCode} - ${response.body}");
    }
  }

  Future<void> _handleEvent(dynamic event) async {
    final Map<String, Object?> parsedEvent =
        event is Map ? event : jsonDecode(event);

    // final id = parsedEvent["id"] as String?;
    // final senderPhoneNumber = parsedEvent["senderPhoneNumber"] as String?;
    // final timestamp = parsedEvent["timestamp"] as int?;
    // final encryptedContents = parsedEvent["contents"] as String?;

    final eventPayload = await getParsedEventPayload(parsedEvent);

    if (eventPayload != null) {
      // /// Providing soft-fail for decryption
      // String decryptedContentsEncoded = "";
      // try {
      //   decryptedContentsEncoded = await encryptionService
      //       .decryptMessageContents(encryptedContents, senderPhoneNumber);
      // } on Exception catch (exception) {
      //   print("Failed to decrypt message");
      //   print(exception.toString());
      //   return;
      // }

      final senderPhoneNumber = eventPayload.senderPhoneNumber;
      final id = eventPayload.id;
      // final timestamp = eventPayload.timestamp;

      final blockedNumbers = await blockedNumbersService.fetchAll();

      if (blockedNumbers
          .any((element) => element.phoneNumber == senderPhoneNumber)) return;

      print("Decrypted message: " +
          jsonDecode(eventPayload.contents).toString());
      final Map<String, Object?> decryptedContents =
          jsonDecode(eventPayload.contents);
      final type = decryptedContents["type"] as String?;

      switch (type) {
        case "message":
          final chatTypeStr = decryptedContents["chatType"] as String;
          final chatType =
              ChatType.values.firstWhere((e) => e.toString() == chatTypeStr);
          final forwarded = decryptedContents["forwarded"] as bool? ?? false;
          final text = decryptedContents["text"] as String;
          final repliedMessageId =
              decryptedContents["repliedMessageId"] as String?;

          await _handleMessage(
            senderPhoneNumber: senderPhoneNumber,
            chatType: chatType,
            id: id,
            contents: text,
            timestamp: DateTime.now(),
            forwarded: forwarded,
            repliedMessageId: repliedMessageId,
          );
          break;

        case "imageMessage":
          final chatTypeStr = decryptedContents["chatType"] as String;
          final chatType =
              ChatType.values.firstWhere((e) => e.toString() == chatTypeStr);
          final forwarded = decryptedContents["forwarded"] as bool? ?? false;

          final imageId = decryptedContents["imageId"] as String;
          final secretKeyBase64 = decryptedContents["key"] as String;

          final image = await mediaService.fetchMedia(imageId, secretKeyBase64);

          if (image != null) {
            _handleMessage(
              senderPhoneNumber: senderPhoneNumber,
              chatType: chatType,
              id: id,
              contents: image,
              timestamp: DateTime.now(),
              isMedia: true,
              forwarded: forwarded,
            );
          }
          break;

        case "delete":
          final messageId = decryptedContents["messageId"] as String;
          messageService.setMessageDeleted(messageId);
          _onDeleteListeners.forEach((listener) => listener(messageId));
          break;

        case "like":
          final messageId = decryptedContents["messageId"] as String;
          final liked = decryptedContents["liked"] as bool;

          messageService.setMessageLiked(messageId, liked).catchError((err) {
            if (err.runtimeType != MessageNotFoundException) {
              print(err);
            }
          });
          _onMessageLikedListeners
              .forEach((listener) => listener(messageId, liked));
          break;

        case "edit":
          final messageId = decryptedContents["messageId"] as String;
          final newMessage = decryptedContents["newMessage"] as String;

          messageService
              .updateMessageContents(messageId, newMessage)
              .catchError((err) {
            if (err.runtimeType != MessageNotFoundException) throw (err);
          });
          _onMessageEditListeners
              .forEach((listener) => listener(messageId, newMessage));

          break;

        case "online":
          final online = decryptedContents["online"] as bool;
          if (online) {
            memoryStoreService.addOnlineContact(senderPhoneNumber);
          } else {
            memoryStoreService.removeOnlineContact(senderPhoneNumber);
          }
          break;

        case "profileImage":
          final imageId = decryptedContents["imageId"] as String;
          final secretKeyBase64 = decryptedContents["key"] as String;

          final image = await mediaService.fetchMedia(imageId, secretKeyBase64);

          if (image != null) {
            contactService.setContactProfileImage(senderPhoneNumber, image);
          }
          break;

        case "status":
          final status = decryptedContents["status"] as String;
          contactService.setContactStatus(senderPhoneNumber, status);
          break;

        case "birthday":
          final birthday = decryptedContents["birthday"] as int;
          contactService.setContactBirthday(senderPhoneNumber, DateTime.fromMillisecondsSinceEpoch(birthday));
          break;

        case "ack":
          final messageId = decryptedContents["messageId"] as String;
          messageService
              .setMessageReadReceipt(messageId, ReadReceipt.delivered)
              .catchError((err) {
            if (err.runtimeType != MessageNotFoundException) {
              print(err);
            }
          });
          _onAckListeners.forEach((listener) => listener(messageId));
          break;

        case "ackSeen":
          bool shareReceipts = await settingsService.getShareReadReceipts();
          if (!shareReceipts) {
            final messageIds = (decryptedContents["messageIds"] as List)
                .map((e) => e as String)
                .toList();

            messageIds.forEach((id) {
              messageService
                  .setMessageReadReceipt(id, ReadReceipt.seen)
                  .catchError((err) {
                if (err.runtimeType != MessageNotFoundException) {
                  print(err);
                }
              });
            });

            _onAckSeenListeners.forEach((listener) => listener(messageIds));
          }

          break;

        case "requestStatus":
          final status = await userService.getStatus();
          sendStatus(status, senderPhoneNumber);
          break;

        case "requestBirthday":
          final birthday = await userService.getBirthday();
          if(birthday != null){
            sendBirthday(birthday.millisecondsSinceEpoch, senderPhoneNumber);
          }
          break;

        case "requestProfileImage":
          final profileImage = await userService.getProfileImage();

          if (profileImage != null) {
            sendProfileImage(base64Encode(profileImage), senderPhoneNumber);
          }
          break;
        case "startPrivateChat":
          String body = "";
          try {
            final contact =
                await contactService.fetchByPhoneNumber(senderPhoneNumber);
            body = "${contact.displayName} wants to chat privately.";
          } on ContactWithPhoneNumberDoesNotExistException {
            body = "$senderPhoneNumber wants to chat privately.";
          }

          final payload = {
            "type": "privateChat",
            "senderPhoneNumber": senderPhoneNumber,
          };

          notificationService.showNotification(
            title: "Incoming private chat",
            body: body,
            payload: payload,
          );
          _onPrivateChatListeners
              .forEach((listener) => listener(senderPhoneNumber));
          break;
        case "stopPrivateChat":
          onStopPrivateChat?.call(senderPhoneNumber);
          break;
        case "acceptPrivateChat":
          onAcceptPrivateChat?.call();
          break;
      }

      await _deleteMessageFromServer(id);
    }
  }

  Future<void> _handleMessage({
    required String senderPhoneNumber,
    required ChatType chatType,
    required String id,
    required String contents,
    required DateTime timestamp,
    String? repliedMessageId,
    bool isMedia = false,
    bool forwarded = false,
  }) async {
    final exists = await chatService.existsByPhoneNumberAndChatType(
        senderPhoneNumber, chatType);

    if (!exists) {
      final chat = Chat(
        id: Uuid().v4(),
        contactPhoneNumber: senderPhoneNumber,
        chatType: chatType,
      );

      await chatService.insert(chat);
    }

    String chatId = await chatService.findIdByPhoneNumberAndChatType(
      senderPhoneNumber,
      chatType,
    );

    final message = Message(
      id: id,
      chatId: chatId,
      isIncoming: true,
      otherPartyPhoneNumber: senderPhoneNumber,
      contents: contents,
      timestamp: timestamp,
      isMedia: isMedia,
      forwarded: forwarded,
      readReceipt: ReadReceipt.delivered,
      repliedMessageId: repliedMessageId,
      deleted: false,
      liked: false,
      tags: [],
    );

    if (chatType == ChatType.general) {
      await messageService.insert(message);
    }
    await sendAck(id, senderPhoneNumber);
    _onMessageListeners.forEach((listener) => listener(message));

    _notifyUser(
      senderPhoneNumber: senderPhoneNumber,
      messageContents: contents,
      isMedia: isMedia,
      chatId: chatId,
    );
  }

  void _notifyUser({
    required String senderPhoneNumber,
    required String messageContents,
    required bool isMedia,
    required String chatId,
  }) async {
    if (shouldBlockNotifications(senderPhoneNumber)) {
      return;
    }
    if (await settingsService.getDisableNotifications()) {
      return;
    }

    String title = senderPhoneNumber;

    try {
      final contact =
          await contactService.fetchByPhoneNumber(senderPhoneNumber);
      title = contact.displayName;
    } on ContactWithPhoneNumberDoesNotExistException {}

    String body = "New message";
    if (!(await settingsService.getDisableMessagePreview())) {
      if (isMedia) {
        body = "\u{1f4f7} Photo";
      } else {
        body = messageContents;
      }
    }

    final payload = {
      "senderPhoneNumber": senderPhoneNumber,
      "type": "message",
      "chatId": chatId,
    };
    notificationService.showNotification(
      title: title,
      body: body,
      payload: payload,
    );
  }

  Future<void> _deleteMessageFromServer(String id) async {
    final uri = Uri.parse(Constants.httpUrl + "message/$id");
    await delete(uri);
  }

  Future<void> sendMessage(Message message, ChatType chatType,
      String recipientPhoneNumber, String? repliedMessageId) async {
    final contents = jsonEncode({
      "type": "message",
      "chatType": chatType.toString(),
      "forwarded": message.forwarded,
      "text": message.contents,
      "repliedMessageId": repliedMessageId,
    });

    _queueForSending(contents, recipientPhoneNumber, id: message.id);
  }

  Future<void> sendImage(
      Message message, ChatType chatType, String recipientPhoneNumber) async {
    final mediaUpload = await mediaService.uploadMedia(message.contents);

    if (mediaUpload != null) {
      final contents = jsonEncode({
        "type": "imageMessage",
        "chatType": chatType.toString(),
        "forwarded": message.forwarded,
        "imageId": mediaUpload.mediaId,
        "key": mediaUpload.secretKeyBase64,
      });

      _queueForSending(contents, recipientPhoneNumber, id: message.id);
    }
  }

  Future<void> sendDelete(String messageId, String recipientPhoneNumber) async {
    final contents = jsonEncode({
      "type": "delete",
      "messageId": messageId,
    });

    _queueForSending(contents, recipientPhoneNumber);
  }

  Future<void> sendLiked(
      String messageId, bool liked, String recipientPhoneNumber) async {
    final contents = jsonEncode({
      "type": "like",
      "messageId": messageId,
      "liked": liked,
    });

    _queueForSending(contents, recipientPhoneNumber);
  }

  Future<void> sendEditedMessage(
      String messageID, String newMessage, String recipientPhoneNumber) async {
    final contents = jsonEncode({
      "type": "edit",
      "messageId": messageID,
      "newMessage": newMessage,
    });

    _queueForSending(contents, recipientPhoneNumber);
  }

  Future<void> sendOnlineStatus(
      bool online, String recipientPhoneNumber) async {
    final contents = jsonEncode({
      "type": "online",
      "online": online,
    });

    _queueForSending(contents, recipientPhoneNumber);
  }

  Future<void> sendStatus(String status, String recipientPhoneNumber) async {
    final contents = jsonEncode({
      "type": "status",
      "status": status,
    });
    bool shareStatus = await settingsService.getShareStatus();
    if (!shareStatus) _queueForSending(contents, recipientPhoneNumber);
  }

  Future<void> sendBirthday(
      int birthday,
      String recipientPhoneNumber) async {
    final contents = jsonEncode({"type": "birthday", "birthday": birthday});
    bool shareBirthday = await settingsService.getShareBirthday();
    if (!shareBirthday) _queueForSending(contents, recipientPhoneNumber);
  }

  Future<void> sendProfileImage(
      String profileImageBase64, String recipientPhoneNumber) async {
    bool shareImage = await settingsService.getShareProfilePicture();
    if (shareImage) return;

    final mediaUpload = await mediaService.uploadMedia(profileImageBase64);

    if (mediaUpload != null) {
      final contents = jsonEncode({
        "type": "profileImage",
        "key": mediaUpload.secretKeyBase64,
        "imageId": mediaUpload.mediaId,
      });

      _queueForSending(contents, recipientPhoneNumber);
    }
  }

  Future<void> sendAck(String messageId, String recipientPhoneNumber) async {
    final contents = jsonEncode({
      "type": "ack",
      "messageId": messageId,
    });

    _queueForSending(contents, recipientPhoneNumber);
  }

  Future<void> sendAckSeen(
      List<String> messageIds, String recipientPhoneNumber) async {
    final contents = jsonEncode({
      "type": "ackSeen",
      "messageIds": messageIds,
    });

    bool shareReceipts = await settingsService.getShareReadReceipts();
    if (!shareReceipts) _queueForSending(contents, recipientPhoneNumber);
  }

  Future<void> sendRequestStatus(String contactPhoneNumber) async {
    final contents = jsonEncode({"type": "requestStatus"});
    _queueForSending(contents, contactPhoneNumber);
  }

  Future<void> sendRequestBirthday(String contactPhoneNumber) async {
    final contents = jsonEncode({"type": "requestBirthday"});
    _queueForSending(contents, contactPhoneNumber);
  }

  Future<void> sendRequestProfileImage(String contactPhoneNumber) async {
    final contents = jsonEncode({"type": "requestProfileImage"});
    _queueForSending(contents, contactPhoneNumber);
  }

  Future<void> sendStartPrivateChat(String recipientPhoneNumber) async {
    final contents = jsonEncode({"type": "startPrivateChat"});
    _queueForSending(contents, recipientPhoneNumber);
  }

  Future<void> sendStopPrivateChat(String recipientPhoneNumber) async {
    final contents = jsonEncode({"type": "stopPrivateChat"});
    _queueForSending(contents, recipientPhoneNumber);
  }

  Future<void> sendAcceptPrivateChat(String recipientPhoneNumber) async {
    final contents = jsonEncode({"type": "acceptPrivateChat"});
    _queueForSending(contents, recipientPhoneNumber);
  }

  void _queueForSending(String unencryptedContents, String recipientPhoneNumber,
      {String? id}) async {
    final userPhoneNumber = await userService.getPhoneNumber();

    final payload = MessagePayload(
      id: id ?? Uuid().v4(),
      senderPhoneNumber: userPhoneNumber,
      recipientPhoneNumber: recipientPhoneNumber,
      contents: unencryptedContents,
    );

    _messageQueue.sink.add(payload);
  }

  Future<EventPayload?> getParsedEventPayload(Map<String, Object?> event) async {
    final id = event["id"] as String?;
    final senderNumberEncrypted = event["senderNumberEncrypted"] as String?;
    final recipientMid = event["recipientMid"] as String?;
    final encryptedContents = event["encryptedContents"] as String?;
    final timestamp = event["timestamp"] as int?;

    EventPayload payload;

    if(id == null || encryptedContents == null || timestamp == null){
      print("Error: Invalid event");
      return null;
    }
    if(recipientMid == null){
      if(senderNumberEncrypted == null){
        print("Error: Invalid event");
        return null;
      }
      final senderPhoneNumber = await encryptionService.decryptSenderNumber(senderNumberEncrypted);
      var decryptedContentsEncoded;

      try {
        decryptedContentsEncoded = await encryptionService.decryptMessageContents(encryptedContents, senderPhoneNumber);
      } on Exception catch (exception) {
        print("Failed to decrypt message");
        print(exception.toString());
        return null;
      }

      final decryptedContents = jsonDecode(decryptedContentsEncoded) as Map<String, Object?>;
      final senderMid = decryptedContents["senderMid"] as String?;
      final rsaKey = decryptedContents["rsaKey"] as String?;
      final messageContents = decryptedContents["messageContents"] as String?;

      if(messageContents == null){
        print("Failed to extract message contents after decryption");
        return null;
      }

      if(senderMid != null){
        final messagebox = await messageboxService.fetchMessageboxForNumber(senderPhoneNumber);
        if(messagebox == null){
          final newMid = await messageboxService.createMessageBox(senderPhoneNumber);
          if(newMid == null){
            print("Failed to create message box on reception of message");
          } else {
            await messageboxService.updateMessageboxRecipientId(newMid, senderMid);
            if(rsaKey != null){
              await messageboxService.updateMessageboxRSAKey(newMid, RSAPublicKey.fromString(rsaKey));
            }
          }
        } else {
          if(messagebox.recipientId != senderMid){
            await messageboxService.updateMessageboxRecipientId(messagebox.id, senderMid);
            if(rsaKey != null){
              await messageboxService.updateMessageboxRSAKey(messagebox.id, RSAPublicKey.fromString(rsaKey));
            }
          }
        }
      } else {
        print("Failed to extract senders Messagebox ID after decryption");
      }

      return new EventPayload(id: id, senderPhoneNumber: senderPhoneNumber, timestamp: timestamp, contents: messageContents);

    } else {
      final messagebox = await messageboxService.fetchMessageboxWithID(recipientMid);
      if (messagebox == null || messagebox.number == null){
        //This shouldn't be possible
        return null;
      }

      final senderPhoneNumber = messagebox.number!;
      var decryptedContentsEncoded;

      try {
        decryptedContentsEncoded = await encryptionService.decryptMessageContents(encryptedContents, senderPhoneNumber);
      } on Exception catch (exception) {
        print("Failed to decrypt message");
        print(exception.toString());
        return null;
      }

      final decryptedContents = jsonDecode(decryptedContentsEncoded) as Map<String, Object?>;
      final senderMid = decryptedContents["senderMid"] as String?;
      final messageContents = decryptedContents["messageContents"] as String?;

      if(messageContents == null){
        print("Failed to extract message contents after decryption");
        return null;
      }

      if(senderMid != null && senderMid != messagebox.recipientId){
        await messageboxService.updateMessageboxRecipientId(messagebox.id, senderMid);
      }

      return new EventPayload(id: id, senderPhoneNumber: senderPhoneNumber, timestamp: timestamp, contents: messageContents);
    }
  }
}

/*
  Message Structure (First Message)
  {
    id,
    recipientPhoneNumber,
    senderNumberEncrypted,
    encryptedContents(
      senderMid,
      rsaKey,
      messageContents
    )
  }

  Message Structure (Second Message)
  {
    id,
    recipientMid,
    encryptedContents(
      senderMid,
      messageContents
    )
  }
  */

class MessagePayload {
  final String id;
  final String senderPhoneNumber;
  final String recipientPhoneNumber;
  String contents;

  MessagePayload({
    required this.id,
    required this.senderPhoneNumber,
    required this.recipientPhoneNumber,
    required this.contents,
  });

  Map<String, Object> get asMap => {
        "id": id,
        "senderPhoneNumber": senderPhoneNumber,
        "recipientPhoneNumber": recipientPhoneNumber,
        "contents": contents
      };
}

class EventPayload {
  final String id;
  final String senderPhoneNumber;
  final int timestamp;
  String contents;

  EventPayload({
    required this.id,
    required this.senderPhoneNumber,
    required this.timestamp,
    required this.contents,
  });

  Map<String, Object> get asMap => {
    "id": id,
    "senderPhoneNumber": senderPhoneNumber,
    "timestamp": timestamp,
    "contents": contents
  };
}
