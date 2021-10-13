import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:crypton/crypton.dart';
import 'package:http/http.dart';
import 'package:mobile/constants.dart';
import 'package:mobile/domain/BlockedNumber.dart';
import 'package:mobile/domain/Chat.dart';
import 'package:mobile/domain/Child.dart';
import 'package:mobile/domain/ChildBlockedNumber.dart';
import 'package:mobile/domain/ChildChat.dart';
import 'package:mobile/domain/ChildContact.dart';
import 'package:mobile/domain/ChildMessage.dart';
import 'package:mobile/domain/Contact.dart';
import 'package:mobile/domain/Message.dart';
import 'package:mobile/domain/MessagePayload.dart';
import 'package:mobile/domain/MessageResendRequest.dart';
import 'package:mobile/domain/Parent.dart';
import 'package:mobile/domain/ProfanityWord.dart';
import 'package:mobile/domain/StoredProfanityWord.dart';
import 'package:mobile/services/BlockedNumbersService.dart';
import 'package:mobile/services/ChatService.dart';
import 'package:mobile/services/ChildBlockedNumberService.dart';
import 'package:mobile/services/ChildChatService.dart';
import 'package:mobile/services/ChildContactService.dart';
import 'package:mobile/services/ChildMessageService.dart';
import 'package:mobile/services/ChildProfanityWordService.dart';
import 'package:mobile/services/ChildService.dart';
import 'package:mobile/services/ContactService.dart';
import 'package:mobile/services/DatabaseService.dart';
import 'package:mobile/services/EncryptionService.dart';
import 'package:mobile/services/MediaService.dart';
import 'package:mobile/services/MemoryStoreService.dart';
import 'package:mobile/services/MessageService.dart';
import 'package:mobile/services/NotificationService.dart';
import 'package:mobile/services/PCConnectionService.dart';
import 'package:mobile/services/ProfanityWordService.dart';
import 'package:mobile/services/SettingsService.dart';
import 'package:mobile/services/StoredProfanityWordService.dart';
import 'package:mobile/services/UserService.dart';
import 'package:mobile/services/MessageboxService.dart';
import 'package:mobile/util/RegexGeneration.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import 'package:web_socket_channel/io.dart';

import 'package:synchronized/synchronized.dart';

import 'ParentService.dart';

class CommunicationService {
  final BlockedNumbersService blockedNumbersService;
  final ProfanityWordService profanityWordService;
  final ChildService childService;
  final ChildChatService childChatService;
  final ChildMessageService childMessageService;
  final ChildBlockedNumberService childBlockedNumberService;
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
  final PCConnectionService pcConnectionService;
  final ChildProfanityWordService childProfanityWordService;
  final ChildContactService childContactService;
  final ParentService parentService;
  final StoredProfanityWordService storedProfanityWordService;
  final DatabaseService _databaseService;

  var communicationLock = new Lock();

  IOWebSocketChannel? channelNumber;
  IOWebSocketChannel? channelAnonymous;
  StreamController<MessagePayload> _messageQueue = StreamController();

  String? anonymousConnectionId = null;
  String anonymousId = "";

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
  List<void Function(bool lockedAccount)> _onLockedAccountSetListeners = [];

  //Start of parental listeners
  void Function()? onRemoveChild;

  List<
      void Function(
          bool editableSettings,
          bool blurImages,
          bool safeMode,
          bool shareProfilePicture,
          bool shareStatus,
          bool shareReadReceipts,
          bool shareBirthday,
          bool lockedAccount,
          bool privateChatAccess,
          bool blockSaveMedia,
          bool blockEditingMessages,
          bool blockDeletingMessages)> _onAllSettingsToChildListeners = [];

  List<void Function()> _onNewProfanityWordToChildListeners = [];

  List<void Function()> _onBlockedNumberToChildListeners = [];

  void Function()? onSetUpChild;

  void Function()? onAllSettingsToParent;

  void Function()? onNewProfanityWordToParent;

  List<void Function()> _onBlockedNumberToParentListeners = [];

  void Function()? onChatToParent;

  void Function()? onChildMessageToParent;

  List<void Function()> _onContactToParentListeners = [];

  void Function(bool value)? onEditableSettingsChangeToChild;

  List<void Function(bool value)> _onLockedAccountChangeToChildListeners = [];

  void Function()? onContactImageToParent;

  void onLockedAccountChangeToChild(void Function(bool value) cb) =>
      _onLockedAccountChangeToChildListeners.add(cb);

  void disposeOnLockedAccountChangeToChild(void Function(bool value) cb) =>
      _onLockedAccountChangeToChildListeners.remove(cb);

  void onContactToParent(void Function() cb) =>
      _onContactToParentListeners.add(cb);

  void disposeOnContactToParent(void Function() cb) =>
      _onContactToParentListeners.remove(cb);

  void onBlockedNumberToParent(void Function() cb) =>
      _onBlockedNumberToParentListeners.add(cb);

  void disposeOnBlockedNumberToParent(void Function() cb) =>
      _onBlockedNumberToParentListeners.remove(cb);

  void onBlockedNumberToChild(void Function() cb) =>
      _onBlockedNumberToChildListeners.add(cb);

  void disposeOnBlockedNumberToChild(void Function() cb) =>
      _onBlockedNumberToChildListeners.remove(cb);

  void onNewProfanityWordToChild(void Function() cb) =>
      _onNewProfanityWordToChildListeners.add(cb);

  void disposeOnNewProfanityWordToChild(void Function() cb) =>
      _onNewProfanityWordToChildListeners.remove(cb);

  void onAllSettingsToChild(
          void Function(
                  bool editableSettings,
                  bool blurImages,
                  bool safeMode,
                  bool shareProfilePicture,
                  bool shareStatus,
                  bool shareReadReceipts,
                  bool shareBirthday,
                  bool lockedAccount,
                  bool privateChatAccess,
                  bool blockSaveMedia,
                  bool blockEditingMessages,
                  bool blockDeletingMessages)
              cb) =>
      _onAllSettingsToChildListeners.add(cb);

  void disposeOnAllSettingsToChild(
          void Function(
                  bool editableSettings,
                  bool blurImages,
                  bool safeMode,
                  bool shareProfilePicture,
                  bool shareStatus,
                  bool shareReadReceipts,
                  bool shareBirthday,
                  bool lockedAccount,
                  bool privateChatAccess,
                  bool blockSaveMedia,
                  bool blockEditingMessages,
                  bool blockDeletingMessages)
              cb) =>
      _onAllSettingsToChildListeners.remove(cb);

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

  void onLockedAccountSet(void Function(bool lockedAccount) cb) =>
      _onLockedAccountSetListeners.add(cb);

  void disposeOnLockedAccountSet(void Function(bool lockedAccount) cb) =>
      _onLockedAccountSetListeners.remove(cb);

  CommunicationService(
      this.blockedNumbersService,
      this.profanityWordService,
      this.childService,
      this.childChatService,
      this.childMessageService,
      this.childBlockedNumberService,
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
      this.childProfanityWordService,
      this.childContactService,
      this.parentService,
      this.pcConnectionService,
      this.storedProfanityWordService,
      this._databaseService) {
    final uri = Uri.parse("${Constants.httpUrl}messages");

    _messageQueue.stream.listen(
      (payload) async {
        await communicationLock.synchronized(() async {
          print("Acquired communication lock for message to " +
              payload.recipientPhoneNumber +
              ": " +
              payload.contents);
          var messagePayload;
          final messagebox = await messageboxService
              .fetchMessageboxForNumber(payload.recipientPhoneNumber);

          if (messagebox == null || messagebox.recipientId == null) {
            print(
                "Messagebox for " + payload.recipientPhoneNumber + " is null");
            String? senderMid;
            if (messagebox == null) {
              senderMid = await messageboxService
                  .createMessageBox(payload.recipientPhoneNumber);
              if (senderMid == null) {
                print("Failed to createMessagebox for sending message");
                return;
              }
              await registerConnectionForMessageboxes([senderMid]);
            } else {
              senderMid = messagebox.id;
            }
            final encryptedContents =
                await encryptionService.encryptMessageContent(
                    jsonEncode({
                      "senderMid": senderMid,
                      "rsaKey": (await userService.fetchRSAKeyPair())
                          .publicKey
                          .toString(),
                      "messageContents": payload.contents
                    }),
                    payload.recipientPhoneNumber);
            final senderNumberEncrypted = await encryptionService
                .encryptNumberFor(payload.recipientPhoneNumber);

            if (senderNumberEncrypted == null) {
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
            print("Messagebox for " +
                payload.recipientPhoneNumber +
                " is " +
                messagebox.recipientId!);
            final senderMid = messagebox.id;
            final encryptedContents =
                await encryptionService.encryptMessageContent(
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

          print("Posting encrypted payload");
          await post(uri, body: jsonEncode(messagePayload));
        });
      },
      onDone: () => _messageQueue.close(),
    );
  }

  Future<void> connectToPc(String relayId) async {
    final userDisplayNameFuture = userService.getDisplayName();
    final userProfilePhotoFuture = userService.getProfileImage();
    final contactsFuture = contactService.fetchAll();
    final chatsFuture = chatService.fetchByChatType(ChatType.general);
    final messagesFuture = messageService.fetchAll();

    await Future.wait([
      userDisplayNameFuture,
      userProfilePhotoFuture,
      contactsFuture,
      chatsFuture,
      messagesFuture
    ]);

    final userDisplayName = await userDisplayNameFuture;
    final userProfilePhoto = await userProfilePhotoFuture;
    final contacts = await contactsFuture;
    final chats = await chatsFuture;
    final messages = await messagesFuture;

    pcConnectionService.connectToPc(
      relayId,
      userDisplayName: userDisplayName,
      userProfilePhoto: base64Encode(userProfilePhoto ?? []),
      contacts: contacts,
      chats: chats,
      messages: messages,
    );

    pcConnectionService.onNewChatEvent = (contactPhoneNumber) async {
      if (await chatService.existsByPhoneNumberAndChatType(
              contactPhoneNumber, ChatType.general) ==
          false) {
        final contact =
            await contactService.fetchByPhoneNumber(contactPhoneNumber);
        final chat = Chat(
          id: Uuid().v4(),
          contactPhoneNumber: contactPhoneNumber,
          chatType: ChatType.general,
          contact: contact,
        );
        chatService.insert(chat);
      } else {}
    };

    pcConnectionService.onMessageEvent = (message) async {
      _onMessageListeners.forEach((listener) {
        listener(message);
      });
      messageService.insert(message);
      sendMessage(
        message,
        ChatType.general,
        message.otherPartyPhoneNumber,
        null,
      );
    };

    pcConnectionService.onSeenEvent = (messageIds) async {
      try {
        final otherNumber = (await messageService.fetchById(messageIds[0]))
            .otherPartyPhoneNumber;

        messageIds.forEach((element) {
          messageService.setMessageReadReceiptFromPc(element, ReadReceipt.seen);
        });
        this.sendAckSeen(messageIds, otherNumber);
      } catch (e) {
        print(e);
      }
    };
  }

  Future<void> goOnline() async {
    print("Going online");
    final phoneNumber = await userService.getPhoneNumber();

    final encodedPhoneNumber = Uri.encodeQueryComponent(phoneNumber);

    print("Fetching unread messages for number " + phoneNumber);
    await _fetchUnreadMessages(encodedPhoneNumber);
    await _fetchUnreadMessageboxMessages();
    await encryptionService.managePreKeys();

    channelNumber?.sink.close();
    channelNumber = IOWebSocketChannel.connect(
      Uri.parse("${Constants.webSocketUrl}?phoneNumber=$encodedPhoneNumber"),
      pingInterval: Duration(minutes: 9),
    );

    channelNumber?.stream.listen((event) async {
      print("Handling number event");
      await _handleEvent(event);
    });

    await _setupAnonymousConnection();

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

  Future<void> _setupAnonymousConnection() async {
    print("_setupAnonymousConnection");
    if(channelAnonymous?.innerWebSocket?.readyState == 1){
      channelAnonymous?.sink.close();
      return;
    }
    channelAnonymous?.sink.close();
    channelAnonymous = IOWebSocketChannel.connect(
      Uri.parse("${Constants.webSocketUrl}?anonymousId=$anonymousId"),
      pingInterval: Duration(minutes: 1),
    );

    channelAnonymous?.stream.listen((event) async {
      print("Handling anonymous event");
      await _handleEvent(event);
    });

    Timer.periodic(Duration(seconds: 1), (timer) async {
      final List<String> ids = await messageboxService.getAllMessageboxIds();
      var registrationComplete = false;

      if(ids.isNotEmpty){
        print("Registering Connection For Messageboxes");
        registrationComplete = await registerConnectionForMessageboxes(ids);
        print("Registering complete: " + registrationComplete.toString());
        if(registrationComplete){
          timer.cancel();
        }
      } else if(channelAnonymous != null && channelAnonymous!.innerWebSocket != null && channelAnonymous!.innerWebSocket!.readyState == 1){
        timer.cancel();
        registrationComplete = true;
      }

      //If this connection closes, start another
      if(registrationComplete) {
        // print("Adding onDone function");
        await channelAnonymous?.innerWebSocket?.done
            .then((val) => (channelAnonymous != null ? print("Anonymous channel closed. Setting up another."): null ))
            .then((val) => _setupAnonymousConnection());
      }
    });
  }



  Future<bool> registerConnectionForMessageboxes(List<String> ids) async {
    if(channelAnonymous != null && channelAnonymous!.innerWebSocket != null && channelAnonymous!.innerWebSocket!.readyState == 1){
      channelAnonymous?.sink.add(jsonEncode(
          {
            // "message": "registermidsconnection",
            "action": "registermidsconnection",
            // "data": {
            //   "myarray" : ["asfdsfsdfsaff", "asfsdfsfsdf"]
            // }
            "data": ids
          }
      ));
      print("Registered connection for mids: " + ids.toString());

      return true;
    } else if (channelAnonymous == null) {
      print("channelAnonymous == null");
    } else if(channelAnonymous?.innerWebSocket == null){
      print("channelAnonymous?.innerWebSocket == null");
    } else {
      print("ReadyState: " + channelAnonymous!.innerWebSocket!.readyState.toString());
    }
    return false;
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

  Future<void> _fetchUnreadMessageboxMessages() async {
    print("Fetching Messagebox messages");
    final List<String> ids = await messageboxService.getAllMessageboxIds();
    print("MessageboxIds: " + ids.toString());

    ids.forEach((mid) async {
      await _fetchUnreadMessageboxMessage(mid);
    });
  }

  Future<void> _fetchUnreadMessageboxMessage(String mId) async {
    final uri = Uri.parse(Constants.httpUrl + "message?messageboxId=$mId");
    final response = await get(uri);

    print("Fetching messages for mId: " + mId);
    if (response.statusCode == 200) {
      final messages = jsonDecode(response.body) as List;
      print("Fetched " + messages.length.toString() + " messages");
      messages.forEach((message) async => await _handleEvent(message));
    } else {
      print("${response.statusCode} - ${response.body}");
    }
  }

  Future<void> _handleEvent(dynamic event) async {
    await communicationLock.synchronized(() async {
      print("Acquired communication lock for handling event.");
      final Map<String, Object?> parsedEvent =
          event is Map ? event : jsonDecode(event);

      print("Parsing event payload");
      final eventPayload = await getParsedEventPayload(parsedEvent);

      if (eventPayload == null) {
        print("Event payload is null");
        print("Event: " + event.toString());

        final id = parsedEvent["id"] as String?;
        if(id != null){
          await _deleteMessageFromServer(id);
        }
      }
      if (eventPayload != null) {
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

            final image =
                await mediaService.fetchMedia(imageId, secretKeyBase64);

            final time = DateTime.now();

            parentService.fetchByEnabled().then((parent) {
              print("Im sending my received image to parent");
              final parentContents = jsonEncode({
                "type": "sendMessageImageToParent",
                "isIncoming": true,
                "id": id,
                "otherPartyNumber": senderPhoneNumber,
                "timeStamp": time.millisecondsSinceEpoch,
                "imageId": imageId,
                "key": secretKeyBase64
              });

              _queueForSending(parentContents, parent.phoneNumber);
            }).catchError((error) {
              print(error);
            });

            if (image != null) {
              _handleMessage(
                senderPhoneNumber: senderPhoneNumber,
                chatType: chatType,
                id: id,
                contents: image,
                timestamp: time,
                isMedia: true,
                forwarded: forwarded,
              );
            }
            break;

          case "profanityWords":
            final chatTypeStr = decryptedContents["chatType"] as String;
            final chatType = ChatType.values
                .firstWhere((element) => element.toString() == chatTypeStr);
            final forwarded = decryptedContents["forwarded"] as bool? ?? false;
            final profanityWords = decryptedContents["words"] as List;
            final contents = decryptedContents["packageName"] as String;

            profanityWords.forEach((word) {
              final map = word as Map<String, dynamic>;
              storedProfanityWordService.addWord(
                  map["word"], map["packageName"], true,
                  downloaded: false);
            });

            await _handleMessage(
                senderPhoneNumber: senderPhoneNumber,
                chatType: chatType,
                id: id,
                contents: contents,
                timestamp: DateTime.now(),
                forwarded: forwarded,
                isProfanityPack: true);
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
            print("updatedPhoto");
            final imageId = decryptedContents["imageId"] as String;
            final secretKeyBase64 = decryptedContents["key"] as String;

            final image =
                await mediaService.fetchMedia(imageId, secretKeyBase64);

            if (image != null) {
              contactService.setContactProfileImage(senderPhoneNumber, image);
              parentService.fetchByEnabled().then((parent) {
                _sendContactImageToParent(parent.phoneNumber, senderPhoneNumber,
                    imageId, secretKeyBase64);
              }).catchError((_) {});
            }
            break;

          case "status":
            final status = decryptedContents["status"] as String;
            contactService.setContactStatus(senderPhoneNumber, status);
            break;

          case "birthday":
            final birthday = decryptedContents["birthday"] as int;
            contactService.setContactBirthday(senderPhoneNumber,
                DateTime.fromMillisecondsSinceEpoch(birthday));
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
            if (birthday != null) {
              sendBirthday(birthday.millisecondsSinceEpoch, senderPhoneNumber);
            }
            break;

          case "requestProfileImage":
            final profileImage = await userService.getProfileImage();

            if (profileImage != null) {
              sendProfileImage(base64Encode(profileImage), senderPhoneNumber);
            }
            break;
          case "requestMessageResend":
            final requestedMessageId = decryptedContents["messageId"] as String?;

            if(requestedMessageId != null){
              sendMessageAgain(requestedMessageId);
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

          //Parental cases below this

          case "addChild":
            //create parent object (This is on child Phone)
            parentService.insert(Parent(
                phoneNumber: senderPhoneNumber,
                name: decryptedContents["name"] as String,
                code: decryptedContents["code"] as String));
            break;

          case "removeChild":
            //set parent enabled value to false and all parent only settings to default in flutter_secure_storage (This is on child Phone)
            final blockedNumbersFromParent =
                await blockedNumbersService.fetchAll();
            final profanityWordsFromParent =
                await profanityWordService.fetchAll();
            blockedNumbersFromParent
                .where((number) => number.addedByParent == true)
                .toList()
                .forEach((element) async =>
                    await blockedNumbersService.delete(element.phoneNumber));

            profanityWordsFromParent
                .where((word) => word.addedByParent == true)
                .toList()
                .forEach((element) async =>
                    await profanityWordService.deleteByID(element.id));

            await parentService.deleteByNumber(senderPhoneNumber);
            await settingsService.setEditableSettings(true);
            await settingsService.setLockedAccount(false);
            await settingsService.setPrivateChatAccess(false);
            await settingsService.setBlockSaveMedia(false);
            await settingsService.setBlockEditingMessages(false);
            await settingsService.setBlockDeletingMessages(false);
            onRemoveChild?.call();
            break;

          case "allSettingsToChild":
            //update all settings in flutter_secure_storage (This is on child phone)
            final editableSettings =
                decryptedContents["editableSettings"] as bool;
            final blurImages = decryptedContents["blurImages"] as bool;
            final safeMode = decryptedContents["safeMode"] as bool;
            final shareProfilePicture =
                decryptedContents["shareProfilePicture"] as bool;
            final shareStatus = decryptedContents["shareStatus"] as bool;
            final shareReadReceipts =
                decryptedContents["shareReadReceipts"] as bool;
            final shareBirthday = decryptedContents["shareBirthday"] as bool;
            final lockedAccount = decryptedContents["lockedAccount"] as bool;
            final privateChatAccess =
                decryptedContents["privateChatAccess"] as bool;
            final blockSaveMedia = decryptedContents["blockSaveMedia"] as bool;
            final blockEditingMessages =
                decryptedContents["blockEditingMessages"] as bool;
            final blockDeletingMessages =
                decryptedContents["blockDeletingMessages"] as bool;

            await settingsService.setEditableSettings(editableSettings);
            await settingsService.setBlurImages(blurImages);
            await settingsService.setSafeMode(safeMode);
            await settingsService.setShareProfilePicture(shareProfilePicture);
            await settingsService.setShareStatus(shareStatus);
            await settingsService.setShareReadReceipts(shareReadReceipts);
            await settingsService.setShareBirthday(shareBirthday);
            await settingsService.setLockedAccount(lockedAccount);
            await settingsService.setPrivateChatAccess(privateChatAccess);
            await settingsService.setBlockSaveMedia(blockSaveMedia);
            await settingsService.setBlockEditingMessages(blockEditingMessages);
            await settingsService
                .setBlockDeletingMessages(blockDeletingMessages);

            _onAllSettingsToChildListeners.forEach((listener) => listener(
                editableSettings,
                blurImages,
                safeMode,
                shareProfilePicture,
                shareStatus,
                shareReadReceipts,
                shareBirthday,
                lockedAccount,
                privateChatAccess,
                blockSaveMedia,
                blockEditingMessages,
                blockDeletingMessages));
            break;

          case "blockedNumberToChild":
            //add given blocked number to my blockedNumbers table (This is on child phone)
            final map =
                decryptedContents["blockedNumber"] as Map<String, dynamic>;

            final operation = decryptedContents["operation"] as String;
            if (operation == "insert") {
              await blockedNumbersService.insert(BlockedNumber(
                  phoneNumber: map["phoneNumber"], addedByParent: true));
            } else {
              await blockedNumbersService.delete(map["phoneNumber"]);
            }
            _onBlockedNumberToChildListeners.forEach((listener) => listener());
            break;

          case "setupChild":
            //create a child entity and populate ALL associated tables eg childMessages, childChat etc... (This is on parent phone)
            final child =
                await contactService.fetchByPhoneNumber(senderPhoneNumber);

            await childService.insert(Child(
                phoneNumber: senderPhoneNumber,
                name: child.displayName,
                blurImages: decryptedContents["blurImages"] as bool,
                safeMode: decryptedContents["safeMode"] as bool,
                shareProfilePicture:
                    decryptedContents["shareProfilePicture"] as bool,
                shareStatus: decryptedContents["shareStatus"] as bool,
                shareReadReceipts:
                    decryptedContents["shareReadReceipts"] as bool,
                shareBirthday: decryptedContents["shareBirthday"] as bool));

            final contactList = decryptedContents["contacts"] as List;
            contactList.forEach((contact) {
              final map = contact as Map<String, dynamic>;
              childContactService.insert(ChildContact(
                  childPhoneNumber: senderPhoneNumber,
                  contactPhoneNumber: map["phoneNumber"],
                  name: map["displayName"],
                  status: map["status"],
                  profileImage: map["profileImage"]));
            });

            final wordList = decryptedContents["words"] as List;
            wordList.forEach((word) {
              final map = word as Map<String, dynamic>;
              childProfanityWordService.insert(senderPhoneNumber, map["word"],
                  map["packageName"], Uuid().v4());
            });

            final blockedNumbersList =
                decryptedContents["blockedNumbers"] as List;
            blockedNumbersList.forEach((number) {
              final map = number as Map<String, dynamic>;
              childBlockedNumberService.insert(ChildBlockedNumber(
                  id: Uuid().v4(),
                  childNumber: senderPhoneNumber,
                  blockedNumber: map["phoneNumber"]));
            });

            final chatList = decryptedContents["chats"] as List;
            chatList.forEach((chat) {
              final map = chat as Map<String, dynamic>;
              childChatService.insert(ChildChat(
                  childPhoneNumber: senderPhoneNumber,
                  otherPartyNumber: map["contactPhoneNumber"]));
            });

            final messageList = decryptedContents["messages"] as List;
            messageList.forEach((message) async {
              final map = message as Map<String, dynamic>;

              String contents = map["contents"];
              if (map["isMedia"]) {
                final imageId = decryptedContents["mediaId"] as String;
                final secretKeyBase64 = decryptedContents["key"] as String;

                final image =
                    await mediaService.fetchMedia(imageId, secretKeyBase64);

                if (image != null) contents = image;
              }

              childMessageService.insert(ChildMessage(
                  id: Uuid().v4(),
                  childPhoneNumber: senderPhoneNumber,
                  isIncoming: map["isIncoming"],
                  otherPartyNumber: map["otherPartyPhoneNumber"],
                  contents: contents,
                  timestamp:
                      DateTime.fromMillisecondsSinceEpoch(map["timestamp"]),
                  isMedia: map["isMedia"]));
            });

            onSetUpChild?.call();

            _sendSetupChildConfirmation(senderPhoneNumber);
            break;

          case "setupChildConfirmation":
            final List<Contact> contacts = await contactService.fetchAll();

            contacts.forEach((contact) async {
              if (contact.profileImage != "") {
                final mediaUpload =
                    await mediaService.uploadMedia(contact.profileImage);

                if (mediaUpload != null) {
                  _sendContactImageToParent(
                      senderPhoneNumber,
                      contact.phoneNumber,
                      mediaUpload.mediaId,
                      mediaUpload.secretKeyBase64);
                }
              }
            });
            break;

          case "newProfanityWordsToChild":
            final words = decryptedContents["words"] as List;
            final operation = decryptedContents["operation"] as String;

            if (operation == "insert") {
              words.forEach((word) async {
                final map = word as Map<String, dynamic>;
                await profanityWordService.addWord(
                    map["word"], map["packageName"],
                    addedByParent: true);
              });
            } else {
              words.forEach((word) async {
                final map = word as Map<String, dynamic>;
                await profanityWordService.deleteByWordAndPackage(
                    map["word"], map["packageName"]);
              });
            }

            _onNewProfanityWordToChildListeners.forEach((listener) => listener);
            break;

          case "allSettingsToParent":
            //update all parents settings for relative child (This is on parent phone)
            final blurImages = decryptedContents["blurImages"] as bool;
            final safeMode = decryptedContents["safeMode"] as bool;
            final shareProfilePicture =
                decryptedContents["shareProfilePicture"] as bool;
            final shareStatus = decryptedContents["shareStatus"] as bool;
            final shareReadReceipts =
                decryptedContents["shareReadReceipts"] as bool;
            final shareBirthday = decryptedContents["shareBirthday"] as bool;

            await childService.update(
              senderPhoneNumber,
              blurImages: blurImages,
              safeMode: safeMode,
              shareProfilePicture: shareProfilePicture,
              shareStatus: shareStatus,
              shareReadReceipts: shareReadReceipts,
              shareBirthday: shareBirthday,
            );
            onAllSettingsToParent?.call();
            break;

          case "editableSettingsChangeToChild":
            final editableSettings = decryptedContents["value"] as bool;

            await settingsService.setEditableSettings(editableSettings);

            onEditableSettingsChangeToChild?.call(editableSettings);
            break;

          case "lockedAccountChangeToChild":
            final lockedAccount = decryptedContents["value"] as bool;

            await settingsService.setLockedAccount(lockedAccount);

            _onLockedAccountChangeToChildListeners
                .forEach((listener) => listener(lockedAccount));
            break;

          case "blockedNumberToParent":
            // update associated child BlockedNumber table with new number (This is on parent phone)
            final map =
                decryptedContents["blockedNumber"] as Map<String, dynamic>;

            final operation = decryptedContents["operation"] as String;

            if (operation == "insert") {
              final childBlockedNumber = ChildBlockedNumber(
                  id: Uuid().v4(),
                  childNumber: senderPhoneNumber,
                  blockedNumber: map["phoneNumber"]);
              await childBlockedNumberService.insert(childBlockedNumber);
            } else {
              await childBlockedNumberService.delete(
                  senderPhoneNumber, map["phoneNumber"]);
            }

            _onBlockedNumberToParentListeners.forEach((listener) => listener());
            break;

          case "chatToParent":
            //update associated child Chat table with new chat (This is on parent phone)
            final map = decryptedContents["chat"] as Map<String, dynamic>;

            final operation = decryptedContents["operation"] as String;
            if (operation == "insert") {
              await childChatService.insert(ChildChat(
                  childPhoneNumber: senderPhoneNumber,
                  otherPartyNumber: map["contactPhoneNumber"]));
            } else {
              await childChatService.deleteByNumbers(
                  senderPhoneNumber, map["contactPhoneNumber"]);
            }

            onChatToParent?.call();
            break;

          case "messageToParent":
            //update associated child Message table with new message (This is on parent phone)
            final map = decryptedContents["message"] as Map<String, dynamic>;

            await childMessageService.insert(ChildMessage(
                id: Uuid().v4(),
                childPhoneNumber: senderPhoneNumber,
                isIncoming: map["isIncoming"],
                otherPartyNumber: map["otherPartyPhoneNumber"],
                contents: map["contents"],
                timestamp:
                    DateTime.fromMillisecondsSinceEpoch(map["timestamp"]),
                isMedia: map["isMedia"]));

            onChildMessageToParent?.call();
            break;

          case "sendMessageImageToParent":
            print("imageFromChildRECIEVED");
            final imageId = decryptedContents["imageId"] as String;
            final key = decryptedContents["key"] as String;

            final image = await mediaService.fetchMedia(imageId, key);

            if (image != null) {
              await childMessageService.insert(ChildMessage(
                  id: Uuid().v4(),
                  childPhoneNumber: senderPhoneNumber,
                  isIncoming: decryptedContents["isIncoming"] as bool,
                  otherPartyNumber:
                      decryptedContents["otherPartyNumber"] as String,
                  contents: image,
                  timestamp: DateTime.fromMillisecondsSinceEpoch(
                      decryptedContents["timeStamp"] as int),
                  isMedia: true));
              onChildMessageToParent?.call();
            }
            break;

          case "contactToParent":
            //update associated child Contact table with new contact (This is on parent phone)
            final map = decryptedContents["contact"] as Map<String, dynamic>;

            await childContactService.insert(ChildContact(
                childPhoneNumber: senderPhoneNumber,
                contactPhoneNumber: map["phoneNumber"],
                name: map["displayName"],
                status: map["status"],
                profileImage: map["profileImage"]));

            _onContactToParentListeners.forEach((listener) => listener());
            break;

          case "contactImageToParent":
            print(
                "IVE RECIEVD CHILDS CONTACTS PROFILE PHOTOS FOR ${decryptedContents["contactPhoneNumber"] as String}");
            final imageId = decryptedContents["mediaId"] as String;
            final secretKeyBase64 = decryptedContents["key"] as String;

            final image =
                await mediaService.fetchMedia(imageId, secretKeyBase64);

            if (image != null) {
              await childContactService.updateProfileImage(senderPhoneNumber,
                  decryptedContents["contactPhoneNumber"] as String, image);

              onContactImageToParent?.call();
            }
            break;
        }

        await _deleteMessageFromServer(id);
      }
    });
  }

  Future<void> _handleMessage(
      {required String senderPhoneNumber,
      required ChatType chatType,
      required String id,
      required String contents,
      required DateTime timestamp,
      String? repliedMessageId,
      bool isMedia = false,
      bool forwarded = false,
      bool isProfanityPack = false}) async {
    final exists = await chatService.existsByPhoneNumberAndChatType(
        senderPhoneNumber, chatType);

    if (!exists) {
      final chat = Chat(
        id: Uuid().v4(),
        contactPhoneNumber: senderPhoneNumber,
        chatType: chatType,
      );

      await chatService.insert(chat);
      parentService.fetchByEnabled().then((parent) async {
        await sendChatToParent(parent.phoneNumber, chat, "insert");
      }).catchError((_) {});
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
      isProfanityPack: isProfanityPack,
      readReceipt: ReadReceipt.delivered,
      repliedMessageId: repliedMessageId,
      deleted: false,
      liked: false,
      tags: [],
    );

    if (chatType == ChatType.general) {
      await messageService.insert(message);
      if (!message.isMedia && !message.isProfanityPack)
        parentService.fetchByEnabled().then((parent) async {
          await sendChildMessageToParent(parent.phoneNumber, message);
        }).catchError((_) {});
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
        body = filterString(
            messageContents, await profanityWordService.fetchAll());
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

      print("sendImageToContact");
      _queueForSending(contents, recipientPhoneNumber, id: message.id);

      parentService.fetchByEnabled().then((parent) {
        final parentContents = jsonEncode({
          "type": "sendMessageImageToParent",
          "isIncoming": message.isIncoming,
          "id": message.id,
          "otherPartyNumber": message.otherPartyPhoneNumber,
          "timeStamp": message.timestamp.millisecondsSinceEpoch,
          "imageId": mediaUpload.mediaId,
          "key": mediaUpload.secretKeyBase64
        });

        _queueForSending(parentContents, parent.phoneNumber);
      }).catchError((error) {});
    }
  }

  Future<void> sendProfanityWords(List<StoredProfanityWord> words,
      ChatType chatType, Message message, String recipientPhoneNumber) async {
    final contents = jsonEncode({
      "type": "profanityWords",
      "chatType": chatType.toString(),
      "forwarded": message.forwarded,
      "words": words,
      "packageName": words[0].packageName
    });

    _queueForSending(contents, recipientPhoneNumber, id: message.id);
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

  Future<void> sendBirthday(int birthday, String recipientPhoneNumber) async {
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

  Future<void> sendMessageResendRequest(MessageResendRequest messageResendRequest) async {
    storeMessageResendRequest(messageResendRequest);
    final contents = jsonEncode({
      "type": "requestMessageResend",
      "messageId": messageResendRequest.id
    });
    _queueForSending(contents, messageResendRequest.senderPhoneNumber);
  }

  Future<void> sendMessageAgain(String id) async {
    MessagePayload? messagePayload = await fetchMessagePayload(id);

    if(messagePayload != null){
      _messageQueue.sink.add(messagePayload);
    }
  }

  //START OF NEW METHODS

  Future<void> sendAddChild(
      String childNumber, String name, String code) async {
    final contents =
        jsonEncode({"type": "addChild", "name": name, "code": code});
    _queueForSending(contents, childNumber);
  }

  Future<void> sendRemoveChild(String childNumber) async {
    final contents = jsonEncode({"type": "removeChild"});
    _queueForSending(contents, childNumber);
  }

  Future<void> sendAllSettingsToChild(
      String childNumber,
      bool editableSettings,
      bool blurImages,
      bool safeMode,
      bool shareProfilePicture,
      bool shareStatus,
      bool shareReadReceipts,
      bool shareBirthday,
      bool lockedAccount,
      bool privateChatAccess,
      bool blockSaveMedia,
      bool blockEditingMessages,
      bool blockDeletingMessages) async {
    final contents = jsonEncode({
      "type": "allSettingsToChild",
      "editableSettings": editableSettings,
      "blurImages": blurImages,
      "safeMode": safeMode,
      "shareProfilePicture": shareProfilePicture,
      "shareStatus": shareStatus,
      "shareReadReceipts": shareReadReceipts,
      "shareBirthday": shareBirthday,
      "lockedAccount": lockedAccount,
      "privateChatAccess": privateChatAccess,
      "blockSaveMedia": blockSaveMedia,
      "blockEditingMessages": blockEditingMessages,
      "blockDeletingMessages": blockDeletingMessages
    });
    _queueForSending(contents, childNumber);
  }

  Future<void> sendNewProfanityWordToChild(
      String childNumber, List<ProfanityWord> words, String operation) async {
    final contents = jsonEncode({
      "type": "newProfanityWordsToChild",
      "words": words,
      "operation": operation
    });
    _queueForSending(contents, childNumber);
  }

  Future<void> sendBlockedNumberToChild(
      String childNumber, BlockedNumber blockedNumber, String operation) async {
    final contents = jsonEncode({
      "type": "blockedNumberToChild",
      "blockedNumber": blockedNumber,
      "operation": operation
    });
    _queueForSending(contents, childNumber);
  }

  Future<void> sendSetupChild(String parentNumber) async {
    final List<Contact> contacts = await contactService.fetchAll();
    contacts.forEach((contact) {
      contact.profileImage = "";
    });

    final List<ProfanityWord> words = await profanityWordService.fetchAll();

    final List<BlockedNumber> blockedNumbers =
        await blockedNumbersService.fetchAll();

    final List<Chat> chats = await chatService.fetchAll();

    chats.forEach((chat) {
      chat.contact?.profileImage = "";
    });

    final List<Message> messages = await messageService.fetchAll();

    messages.forEach((message) {
      if (message.isMedia) {
        message.isMedia = false;
        message.contents = "This was an image";
      }
    });

    final blurImages = await settingsService.getBlurImages();
    final safeMode = await settingsService.getSafeMode();
    final shareProfilePicture = await settingsService.getShareProfilePicture();
    final shareStatus = await settingsService.getShareStatus();
    final shareReadReceipts = await settingsService.getShareReadReceipts();
    final shareBirthday = await settingsService.getShareBirthday();
    final contents = jsonEncode({
      "type": "setupChild",
      "blurImages": blurImages,
      "safeMode": safeMode,
      "shareProfilePicture": shareProfilePicture,
      "shareStatus": shareStatus,
      "shareReadReceipts": shareReadReceipts,
      "shareBirthday": shareBirthday,
      "contacts": contacts,
      "words": words,
      "blockedNumbers": blockedNumbers,
      "chats": chats,
      "messages": messages
    });
    _queueForSending(contents, parentNumber);
  }

  Future<void> sendAllSettingsToParent(
      String parentNumber,
      bool blurImages,
      bool safeMode,
      bool shareProfilePicture,
      bool shareStatus,
      bool shareReadReceipts,
      bool shareBirthday) async {
    final contents = jsonEncode({
      "type": "allSettingsToParent",
      "blurImages": blurImages,
      "safeMode": safeMode,
      "shareProfilePicture": shareProfilePicture,
      "shareStatus": shareStatus,
      "shareReadReceipts": shareReadReceipts,
      "shareBirthday": shareBirthday
    });
    _queueForSending(contents, parentNumber);
  }

  Future<void> _sendSetupChildConfirmation(String recipientPhoneNumber) async {
    final contents = jsonEncode({"type": "setupChildConfirmation"});

    _queueForSending(contents, recipientPhoneNumber);
  }

  Future<void> sendEditableSettingsChangeToChild(
      String childNumber, bool value) async {
    final contents =
        jsonEncode({"type": "editableSettingsChangeToChild", "value": value});
    _queueForSending(contents, childNumber);
  }

  Future<void> sendLockedAccountChangeToChild(
      String childNumber, bool value) async {
    final contents =
        jsonEncode({"type": "lockedAccountChangeToChild", "value": value});
    _queueForSending(contents, childNumber);
  }

  Future<void> sendBlockedNumberToParent(
      String parentNumber, BlockedNumber number, String operation) async {
    final contents = jsonEncode({
      "type": "blockedNumberToParent",
      "blockedNumber": number,
      "operation": operation
    });
    _queueForSending(contents, parentNumber);
  }

  Future<void> sendChatToParent(
      String parentNumber, Chat chat, String operation) async {
    chat.contact?.profileImage = "";
    final contents = jsonEncode(
        {"type": "chatToParent", "chat": chat, "operation": operation});
    _queueForSending(contents, parentNumber);
  }

  Future<void> sendChildMessageToParent(
      String parentNumber, Message message) async {
    final contents =
        jsonEncode({"type": "messageToParent", "message": message});
    _queueForSending(contents, parentNumber);
  }

  Future<void> sendContactToParent(
      String parentNumber, Contact contact, String operation) async {
    contact.profileImage = "";
    final contents = jsonEncode({
      "type": "contactToParent",
      "contact": contact,
      "operation": operation
    });
    _queueForSending(contents, parentNumber);
  }

  Future<void> _sendContactImageToParent(String parentNumber,
      String contactNumber, String mediaId, String secretKeyBase64) async {
    final contents = jsonEncode({
      "type": "contactImageToParent",
      "contactPhoneNumber": contactNumber,
      "mediaId": mediaId,
      "key": secretKeyBase64
    });

    _queueForSending(contents, parentNumber);
  }

  //END OF NEW METHODS

  void _queueForSending(String unencryptedContents, String recipientPhoneNumber,
      {String? id}) async {
    final userPhoneNumber = await userService.getPhoneNumber();

    final payload = MessagePayload(
      id: id ?? Uuid().v4(),
      senderPhoneNumber: userPhoneNumber,
      recipientPhoneNumber: recipientPhoneNumber,
      contents: unencryptedContents,
    );

    storeMessagePayload(payload);
    _messageQueue.sink.add(payload);
  }

  Future<EventPayload?> getParsedEventPayload(
      Map<String, Object?> event) async {
    final id = event["id"] as String?;
    final senderNumberEncrypted = event["senderNumberEncrypted"] as String?;
    final recipientMid = event["recipientMid"] as String?;
    final encryptedContents = event["encryptedContents"] as String?;
    var timestamp = event["timestamp"] as int?;

    if (id == null || encryptedContents == null || timestamp == null) {
      print(
          "Error: Invalid event (id, encryptedContents or timestamp is null)");
      return null;
    }

    //If you have a message resent to you, you want its original timestamp
    MessageResendRequest? messageResendRequest = await fetchMessageResendRequest(id);
    if(messageResendRequest != null){
      timestamp = messageResendRequest.originalTimestamp;
      // removeMessageResendRequest(id); //Keep it incase multiple requests are sent
    }

    if (recipientMid == null) {
      if (senderNumberEncrypted == null) {
        print(
            "Error: Invalid event (recipientMid and senderNumberEncrypted is null)");
        return null;
      }
      final senderPhoneNumber =
          await encryptionService.decryptSenderNumber(senderNumberEncrypted);
      var decryptedContentsEncoded;

      try {
        decryptedContentsEncoded = await encryptionService
            .decryptMessageContents(encryptedContents, senderPhoneNumber);
      } on Exception catch (exception) {
        print("Failed to decrypt message. Requesting message to be resent.");
        print(exception.toString());
        await sendMessageResendRequest(
            new MessageResendRequest(id: id, senderPhoneNumber: senderPhoneNumber, originalTimestamp: timestamp)
        );
        return null;
      }

      final decryptedContents =
          jsonDecode(decryptedContentsEncoded) as Map<String, Object?>;
      final senderMid = decryptedContents["senderMid"] as String?;
      final rsaKey = decryptedContents["rsaKey"] as String?;
      final messageContents = decryptedContents["messageContents"] as String?;

      if (messageContents == null) {
        print("Failed to extract message contents after decryption");
        return null;
      }

      if (senderMid != null) {
        final messagebox =
            await messageboxService.fetchMessageboxForNumber(senderPhoneNumber);
        if (messagebox == null) {
          final newMid =
              await messageboxService.createMessageBox(senderPhoneNumber);
          if (newMid == null) {
            print("Failed to create message box on reception of message");
          } else {
            await messageboxService.updateMessageboxRecipientId(
                newMid, senderMid);
            if (rsaKey != null) {
              await messageboxService.updateMessageboxRSAKey(
                  newMid, RSAPublicKey.fromString(rsaKey));
            }
            await registerConnectionForMessageboxes([newMid]);
          }
        } else {
          if (messagebox.recipientId != senderMid) {
            await messageboxService.updateMessageboxRecipientId(
                messagebox.id, senderMid);
            if (rsaKey != null) {
              await messageboxService.updateMessageboxRSAKey(
                  messagebox.id, RSAPublicKey.fromString(rsaKey));
            }
          }
        }
      } else {
        print("Failed to extract senders Messagebox ID after decryption");
      }

      return new EventPayload(
          id: id,
          senderPhoneNumber: senderPhoneNumber,
          timestamp: timestamp,
          contents: messageContents);
    } else {
      final messagebox =
          await messageboxService.fetchMessageboxWithID(recipientMid);
      if (messagebox == null || messagebox.number == null) {
        //This shouldn't be possible
        print("Failed to fetch messagebox with id: " + recipientMid.toString());
        return null;
      }

      final senderPhoneNumber = messagebox.number!;
      var decryptedContentsEncoded;

      try {
        decryptedContentsEncoded = await encryptionService
            .decryptMessageContents(encryptedContents, senderPhoneNumber);
      } on Exception catch (exception) {
        print("Failed to decrypt message. Requesting message to be resent.");
        print(exception.toString());
        await sendMessageResendRequest(
            new MessageResendRequest(id: id, senderPhoneNumber: senderPhoneNumber, originalTimestamp: timestamp)
        );
        return null;
      }

      final decryptedContents =
          jsonDecode(decryptedContentsEncoded) as Map<String, Object?>;
      final senderMid = decryptedContents["senderMid"] as String?;
      final messageContents = decryptedContents["messageContents"] as String?;

      if (messageContents == null) {
        print("Failed to extract message contents after decryption");
        return null;
      }

      if (senderMid != null && senderMid != messagebox.recipientId) {
        await messageboxService.updateMessageboxRecipientId(
            messagebox.id, senderMid);
      }

      return new EventPayload(
          id: id,
          senderPhoneNumber: senderPhoneNumber,
          timestamp: timestamp,
          contents: messageContents);
    }
  }

  Future<void> storeMessagePayload(MessagePayload messagePayload) async {
    final db = await _databaseService.database;

    await db.insert(MessagePayload.TABLE_NAME, messagePayload.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<MessagePayload?> fetchMessagePayload(String id) async {
    final db = await _databaseService.database;

    final response = await db.query(
      MessagePayload.TABLE_NAME,
      where: "${MessagePayload.COLUMN_ID} = ?",
      whereArgs: [id],
    );

    if (response.isNotEmpty) {
      return MessagePayload.fromMap(response.first);
    }
  }

  Future<void> storeMessageResendRequest(MessageResendRequest messageResendRequest) async {
    final db = await _databaseService.database;

    await db.insert(MessageResendRequest.TABLE_NAME, messageResendRequest.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<MessageResendRequest?> fetchMessageResendRequest(String id) async {
    final db = await _databaseService.database;

    final response = await db.query(
      MessageResendRequest.TABLE_NAME,
      where: "${MessageResendRequest.COLUMN_ID} = ?",
      whereArgs: [id],
    );

    if (response.isNotEmpty) {
      return MessageResendRequest.fromMap(response.first);
    }
  }

  Future<void> removeMessageResendRequest(String id) async {
    final db = await _databaseService.database;

    await db.delete(
      MessageResendRequest.TABLE_NAME,
      where: "${MessageResendRequest.COLUMN_ID} = ?",
      whereArgs: [id],
    );
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
