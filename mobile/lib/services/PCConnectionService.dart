import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:mobile/domain/Chat.dart';
import 'package:mobile/domain/Contact.dart';
import 'package:mobile/domain/Message.dart';

class PCConnectionService {
  static const configuration = {
    "iceServers": [
      {
        "urls": [
          "stun:stun1.l.google.com:19302",
          "stun:stun2.l.google.com:19302",
        ]
      }
    ]
  };

  void Function(Message message)? onMessageEvent;
  void Function(String contactPhoneNumber)? onNewChatEvent;
  void Function(List<String> messageIds)? onSeenEvent;

  RTCDataChannel? dataChannel;

  Future<void> connectToPc(
    String callId, {
    required String userDisplayName,
    required String userProfilePhoto,
    required List<Contact> contacts,
    required List<Chat> chats,
    required List<Message> messages,
  }) async {
    final call = db.collection("calls").doc(callId);
    final offer = (await call.get()).data()?["offer"];

    if (offer == null) {
      print("Tried to answer with unset offer");
      return;
    }

    final remoteConnection = await createPeerConnection(configuration);

    remoteConnection.onDataChannel = (channel) {
      this.dataChannel = channel;
      channel.messageStream.listen((mEvent) {
        handleEvent(jsonDecode(mEvent.text) as Map<String, dynamic>);
      });
    };

    remoteConnection.onIceCandidate = (candidate) {
      call.collection("calleeCandidates").add(candidate.toMap());
    };

    await remoteConnection.setRemoteDescription(RTCSessionDescription(
      offer["sdp"],
      offer["type"],
    ));
    final answer = await remoteConnection.createAnswer();
    await remoteConnection.setLocalDescription(answer);
    await call.update({"answer": answer.toMap()});

    call.collection("callerCandidates").snapshots().listen((snapshot) {
      snapshot.docChanges.forEach((change) {
        if (change.type == DocumentChangeType.added) {
          final data = change.doc.data();
          if (data != null) {
            print(data);

            remoteConnection.addCandidate(RTCIceCandidate(
              data["candidate"],
              data["sdpMid"],
              data["sdpMLineIndex"],
            ));
          }
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
        case "seen":
          handleSeen(event);
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

  void handleSeen(Map<String, dynamic> event) {
    final messageIds =
        (event["messageIds"] as List).map((e) => e as String).toList();

    if (messageIds.isNotEmpty) {
      onSeenEvent?.call(messageIds);
    }
  }

  Future<void> notifyPcPutContact(Contact contact) async {
    if (dataChannel?.state == RTCDataChannelState.RTCDataChannelOpen) {
      dataChannel?.send(
        RTCDataChannelMessage(jsonEncode({
          "origin": "phone",
          "type": "putContact",
          "contact": jsonEncode(contact),
        })),
      );
    }
  }

  Future<void> notifyPcDeleteContact(String contactPhoneNumber) async {
    if (dataChannel?.state == RTCDataChannelState.RTCDataChannelOpen) {
      dataChannel?.send(
        RTCDataChannelMessage(jsonEncode({
          "origin": "phone",
          "type": "deleteContact",
          "contactPhoneNumber": contactPhoneNumber,
        })),
      );
    }
  }

  Future<void> notifyPcPutChat(Chat chat) async {
    if (dataChannel?.state == RTCDataChannelState.RTCDataChannelOpen) {
      dataChannel?.send(
        RTCDataChannelMessage(jsonEncode({
          "origin": "phone",
          "type": "putChat",
          "chat": jsonEncode(chat),
        })),
      );
    }
  }

  Future<void> notifyPcDeleteChat(String chatId) async {
    if (dataChannel?.state == RTCDataChannelState.RTCDataChannelOpen) {
      dataChannel?.send(
        RTCDataChannelMessage(jsonEncode({
          "origin": "phone",
          "type": "deleteChat",
          "chatId": chatId,
        })),
      );
    }
  }

  Future<void> notifyPcPutMessage(Message message) async {
    if (dataChannel?.state == RTCDataChannelState.RTCDataChannelOpen) {
      dataChannel?.send(
        RTCDataChannelMessage(jsonEncode({
          "origin": "phone",
          "type": "putMessage",
          "message": jsonEncode(message),
        })),
      );
    }
  }

  Future<void> notifyPcDeleteMessage(String messageId) async {
    if (dataChannel?.state == RTCDataChannelState.RTCDataChannelOpen) {
      dataChannel?.send(
        RTCDataChannelMessage(jsonEncode({
          "origin": "phone",
          "type": "deleteMessage",
          "messageId": messageId,
        })),
      );
    }
  }

  FirebaseFirestore get db => FirebaseFirestore.instance;
}
