import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
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
  StreamController<Map<String, dynamic>>? _outgoingStream;

  Future<void> connectToPc(
    String callId, {
    required String userDisplayName,
    required String userProfilePhoto,
    required List<Contact> contacts,
    required List<Chat> chats,
    required List<Message> messages,
  }) async {
    _outgoingStream = StreamController();

    final call = db.collection("calls").doc(callId);
    final offer = (await call.get()).data()?["offer"];

    if (offer == null) {
      print("Tried to answer with unset offer");
      return;
    }

    final remoteConnection = await createPeerConnection(configuration);

    remoteConnection.onDataChannel = (channel) {
      channel.messageStream.listen((mEvent) {
        handleEvent(jsonDecode(mEvent.text) as Map<String, dynamic>);
      });

      _outgoingStream?.stream.listen((event) async {
        event["origin"] = "phone";

        if (event["type"] == "putMessage") {
          event["message"] = await _compressImageIfTooLarge(event);
        }

        channel.send(RTCDataChannelMessage(jsonEncode(event)));
      });

      channel.send(
        RTCDataChannelMessage(jsonEncode({
          "origin": "phone",
          "type": "connected",
        })),
      );

      _outgoingStream?.sink.add({
        "type": "userProfileImage",
        "profileImage": userProfilePhoto,
      });

      _outgoingStream?.sink.add({
        "type": "userDisplayName",
        "displayName": userDisplayName,
      });

      contacts.forEach((contact) {
        notifyPcPutContact(contact);
      });

      chats.forEach((chat) {
        notifyPcPutChat(chat);
      });

      messages.forEach((message) {
        notifyPcPutMessage(message);
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
    final messageEvent = event["message"] as Map<String, dynamic>;

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
    _outgoingStream?.sink.add({
      "origin": "phone",
      "type": "putContact",
      "contact": contact,
    });
  }

  Future<void> notifyPcDeleteContact(String contactPhoneNumber) async {
    _outgoingStream?.sink.add({
      "origin": "phone",
      "type": "deleteContact",
      "contactPhoneNumber": contactPhoneNumber,
    });
  }

  Future<void> notifyPcPutChat(Chat chat) async {
    _outgoingStream?.sink.add({
      "origin": "phone",
      "type": "putChat",
      "chat": chat,
    });
  }

  Future<void> notifyPcDeleteChat(String chatId) async {
    _outgoingStream?.sink.add({
      "origin": "phone",
      "type": "deleteChat",
      "chatId": chatId,
    });
  }

  Future<void> notifyPcPutMessage(Message message) async {
    _outgoingStream?.sink.add({
      "origin": "phone",
      "type": "putMessage",
      "message": message,
    });
  }

  Future<void> notifyPcDeleteMessage(String messageId) async {
    _outgoingStream?.sink.add({
      "origin": "phone",
      "type": "deleteMessage",
      "messageId": messageId,
    });
  }

  FirebaseFirestore get db => FirebaseFirestore.instance;

  Future<Message> _compressImageIfTooLarge(Map<String, dynamic> event) async {
    final message = event["message"] as Message;
    final isMedia = message.isMedia;

    if (!isMedia) {
      return message;
    } else {
      final contents = message.contents;

      if (contents.length > 60000) {
        final binaryContents = base64Decode(contents);
        var compressionLevel = 95;
        Uint8List compressedContents;
        do {
          compressedContents = await FlutterImageCompress.compressWithList(
            binaryContents,
            quality: compressionLevel,
          );
          compressionLevel -= 5;
        } while (compressedContents.length > 44500);

        message.contents = base64Encode(compressedContents);
      }

      return message;
    }
  }
}
