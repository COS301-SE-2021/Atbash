import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile/domain/Chat.dart';
import 'package:mobile/domain/Contact.dart';
import 'package:mobile/domain/Message.dart';

class PCConnectionService {
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
