import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile/domain/Chat.dart';
import 'package:mobile/domain/Contact.dart';
import 'package:mobile/domain/Message.dart';

class PCConnectionService {
  void Function(Message message)? onMessageEvent;
  void Function(String contactPhoneNumber)? onNewChatEvent;

  String? pcRelayId;

  Future<void> connectToPc(
    String relayId, {
    required String userDisplayName,
    required String userProfilePhoto,
    required List<Contact> contacts,
    required List<Chat> chats,
    required List<Message> messages,
  }) async {
    this.pcRelayId = relayId;
    _collection(relayId).add({
      "origin": "phone",
      "type": "connected",
    });

    _collection(relayId).add({
      "origin": "phone",
      "type": "setup",
      "userDisplayName": userDisplayName,
      "userProfilePhoto": userProfilePhoto,
      "contacts": jsonEncode(contacts),
      "chats": jsonEncode(chats),
      "messages": jsonEncode(messages),
    });

    _collection(relayId).snapshots().listen((snapshot) {
      snapshot.docs.forEach((doc) {
        final handled = handleEvent(doc.data());
        if (handled) {
          doc.reference.delete();
        }
      });
    });
  }

  bool handleEvent(Map<String, dynamic> event) {
    final origin = event["origin"] as String?;
    final type = event["type"] as String?;

    if (origin != null && type != null && origin == "web") {
      switch (type) {
        case "message":
          handleMessage(event);
          return true;
        case "newChat":
          handleNewChat(event);
          return true;
        default:
          return false;
      }
    } else {
      return false;
    }
  }

  void handleMessage(Map<String, dynamic> event) {
    final messageEvent = jsonDecode(event["message"]) as Map<String, dynamic>;

    final id = messageEvent["id"] as String;
    final chatId = messageEvent["chatId"] as String;
    final recipientPhoneNumber = messageEvent["recipientPhoneNumber"] as String;
    final contents = messageEvent["contents"] as String;
    final timestamp = messageEvent["timestamp"] as int;

    final message = Message(
      id: id,
      chatId: chatId,
      isIncoming: false,
      otherPartyPhoneNumber: recipientPhoneNumber,
      contents: contents,
      timestamp: DateTime.fromMillisecondsSinceEpoch(timestamp),
    );

    onMessageEvent?.call(message);
  }

  void handleNewChat(Map<String, dynamic> event) {
    final contactPhoneNumber = event["contactPhoneNumber"] as String;

    onNewChatEvent?.call(contactPhoneNumber);
  }

  Future<void> notifyPcPutContact(Contact contact) async {
    final relayId = this.pcRelayId;

    if (relayId != null) {
      _collection(relayId).add({
        "origin": "phone",
        "type": "putContact",
        "contact": jsonEncode(contact),
      });
    }
  }

  Future<void> notifyPcDeleteContact(String contactPhoneNumber) async {
    final relayId = this.pcRelayId;

    if (relayId != null) {
      FirebaseFirestore.instance
          .collection("relays")
          .doc(relayId)
          .collection("communication")
          .add({
        "origin": "phone",
        "type": "deleteContact",
        "contactPhoneNumber": contactPhoneNumber,
      });
    }
  }

  Future<void> notifyPcPutChat(Chat chat) async {
    final relayId = this.pcRelayId;

    if (relayId != null) {
      _collection(relayId).add({
        "origin": "phone",
        "type": "putChat",
        "chat": jsonEncode(chat),
      });
    }
  }

  Future<void> notifyPcDeleteChat(String chatId) async {
    final relayId = this.pcRelayId;

    if (relayId != null) {
      _collection(relayId).add({
        "origin": "phone",
        "type": "deleteChat",
        "chatId": chatId,
      });
    }
  }

  Future<void> notifyPcPutMessage(Message message) async {
    final relayId = this.pcRelayId;

    if (relayId != null) {
      _collection(relayId).add({
        "origin": "phone",
        "type": "putMessage",
        "message": jsonEncode(message),
      });
    }
  }

  Future<void> notifyPcDeleteMessage(String messageId) async {
    final relayId = this.pcRelayId;

    if (relayId != null) {
      _collection(relayId).add({
        "origin": "phone",
        "type": "deleteMessage",
        "messageId": messageId,
      });
    }
  }

  CollectionReference<Map<String, dynamic>> _collection(String relayId) =>
      FirebaseFirestore.instance
          .collection("relays")
          .doc(relayId)
          .collection("communication");
}
