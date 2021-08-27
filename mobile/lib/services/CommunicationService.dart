import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:mobile/constants.dart';
import 'package:mobile/domain/Message.dart';
import 'package:mobile/services/EncryptionService.dart';
import 'package:mobile/services/UserService.dart';
import 'package:uuid/uuid.dart';
import 'package:web_socket_channel/io.dart';

class CommunicationService {
  final EncryptionService encryptionService;
  final UserService userService;

  IOWebSocketChannel? channel;

  List<void Function(Message message)> _onMessageListeners = [];
  void Function(String messageId)? onDelete;
  void Function(String contactPhoneNumber, String profileImage)? onProfileImage;
  void Function(String contactPhoneNumber, String status)? onStatus;
  void Function(String messageId)? onAck;
  void Function(List<String> messageIds)? onAckSeen;

  set onMessage(void Function(Message message) cb) =>
      _onMessageListeners.add(cb);

  CommunicationService(this.encryptionService, this.userService);

  Future<void> goOnline() async {
    final phoneNumber = await userService.getPhoneNumber();

    final encodedPhoneNumber = Uri.encodeQueryComponent(phoneNumber);

    channel?.sink.close();
    channel = IOWebSocketChannel.connect(
      Uri.parse("${Constants.webSocketUrl}?phoneNumber=$encodedPhoneNumber"),
      pingInterval: Duration(minutes: 9),
    );

    channel?.stream.listen((event) {
      _handleEvent(event);
    });
  }

  Future<Message?> _handleEvent(dynamic event) async {
    final Map<String, Object?> parsedEvent = jsonDecode(event);

    final id = parsedEvent["id"] as String?;
    final senderPhoneNumber = parsedEvent["senderPhoneNumber"] as String?;
    final timestamp = parsedEvent["timestamp"] as int?;
    final encryptedContents = parsedEvent["contents"] as String?;

    if (id != null &&
        senderPhoneNumber != null &&
        timestamp != null &&
        encryptedContents != null) {
      final Map<String, Object?> decryptedContents = jsonDecode(
          await encryptionService.decryptMessageContents(
              encryptedContents, senderPhoneNumber));

      final type = decryptedContents["type"] as String?;

      switch (type) {
        case "message":
          final chatId = decryptedContents["chatId"] as String;
          final text = decryptedContents["text"] as String;

          final message = Message(
            id: id,
            chatId: chatId,
            isIncoming: true,
            otherPartyPhoneNumber: senderPhoneNumber,
            contents: text,
            timestamp: DateTime.fromMillisecondsSinceEpoch(timestamp),
            readReceipt: ReadReceipt.delivered,
            deleted: false,
            liked: false,
            tags: [],
          );

          print("received message");

          _onMessageListeners.forEach((listener) => listener(message));
          break;
        case "delete":
          final messageId = decryptedContents["messageId"] as String;
          final onDelete = this.onDelete;
          if (onDelete != null) onDelete(messageId);
          break;
        case "profileImage":
          final image = decryptedContents["image"] as String;
          final onProfileImage = this.onProfileImage;
          if (onProfileImage != null) onProfileImage(senderPhoneNumber, image);
          break;
        case "status":
          final status = decryptedContents["status"] as String;
          final onStatus = this.onStatus;
          if (onStatus != null) onStatus(senderPhoneNumber, status);
          break;
        case "ack":
          final messageId = decryptedContents["messageId"] as String;
          final onAck = this.onAck;
          if (onAck != null) onAck(messageId);
          break;
        case "ackSeen":
          final messageIds = (decryptedContents["messageIds"] as List)
              .map((e) => e as String)
              .toList();

          final onAckSeen = this.onAckSeen;
          if (onAckSeen != null) onAckSeen(messageIds);
          break;
      }
    }
  }

  Future<void> sendMessage(Message message, String recipientPhoneNumber) async {
    final userPhoneNumber = await userService.getPhoneNumber();

    final contents = jsonEncode({
      "type": "message",
      "chatId": message.chatId,
      "text": message.contents,
    });

    final encryptedContents = await encryptionService.encryptMessageContent(
        contents, recipientPhoneNumber);

    final data = {
      "id": message.id,
      "senderPhoneNumber": userPhoneNumber,
      "recipientPhoneNumber": recipientPhoneNumber,
      "contents": encryptedContents
    };

    await post(Uri.parse("${Constants.httpUrl}messages"),
        body: jsonEncode(data));
  }

  Future<void> sendDelete(String messageId, String recipientPhoneNumber) async {
    final userPhoneNumber = await userService.getPhoneNumber();

    final contents = jsonEncode({
      "type": "delete",
      "messageId": messageId,
    });

    final encryptedContents = await encryptionService.encryptMessageContent(
        contents, recipientPhoneNumber);

    final data = {
      "id": Uuid().v4(),
      "senderPhoneNumber": userPhoneNumber,
      "recipientPhoneNumber": recipientPhoneNumber,
      "contents": encryptedContents
    };

    await post(Uri.parse("${Constants.httpUrl}messages"),
        body: jsonEncode(data));
  }

  Future<void> sendAck(String messageId, String recipientPhoneNumber) async {
    final userPhoneNumber = await userService.getPhoneNumber();

    final contents = jsonEncode({
      "type": "ack",
      "messageId": messageId,
    });

    final encryptedContents = await encryptionService.encryptMessageContent(
        contents, recipientPhoneNumber);

    final data = {
      "id": Uuid().v4(),
      "senderPhoneNumber": userPhoneNumber,
      "recipientPhoneNumber": recipientPhoneNumber,
      "contents": encryptedContents,
    };

    await post(Uri.parse("${Constants.httpUrl}messages"),
        body: jsonEncode(data));
  }

  Future<void> sendAckSeen(
      List<String> messageIds, String recipientPhoneNumber) async {
    final userPhoneNumber = await userService.getPhoneNumber();

    final contents = jsonEncode({
      "type": "ackSeen",
      "messageIds": messageIds,
    });

    final encryptedContents = await encryptionService.encryptMessageContent(
        contents, recipientPhoneNumber);

    final data = {
      "id": Uuid().v4(),
      "senderPhoneNumber": userPhoneNumber,
      "recipientPhoneNumber": recipientPhoneNumber,
      "contents": encryptedContents
    };

    await post(Uri.parse("${Constants.httpUrl}messages"),
        body: jsonEncode(data));
  }
}
