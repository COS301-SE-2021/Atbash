import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:mobile/constants.dart';
import 'package:mobile/domain/Message.dart';
import 'package:mobile/services/EncryptionService.dart';
import 'package:mobile/services/UserService.dart';
import 'package:web_socket_channel/io.dart';

class CommunicationService {
  final EncryptionService encryptionService;
  final UserService userService;

  CommunicationService(this.encryptionService, this.userService);

  Stream<Message> messages() async* {
    final phoneNumber = await userService.getPhoneNumber();

    final encodedPhoneNumber = Uri.encodeQueryComponent(phoneNumber);

    final channel = IOWebSocketChannel.connect(
      Uri.parse("${Constants.webSocketUrl}?phoneNumber=$encodedPhoneNumber"),
      pingInterval: Duration(minutes: 9),
    );

    await for (var event in channel.stream) {
      final message = await _parseEvent(event);
      if (message != null) {
        yield message;
      }
    }
  }

  Future<Message?> _parseEvent(dynamic event) async {
    final Map<String, Object?> parsedEvent = jsonDecode(event);

    final id = parsedEvent["id"] as String?;
    final type = parsedEvent["type"] as String?;
    final senderPhoneNumber = parsedEvent["senderPhoneNumber"] as String?;
    final timestamp = parsedEvent["timestamp"] as int?;
    final chatId = parsedEvent["chatId"] as String?;
    final contents = parsedEvent["contents"] as String?;

    if (id != null &&
        type != null &&
        senderPhoneNumber != null &&
        timestamp != null &&
        chatId != null &&
        contents != null) {
      final decryptedContents = await encryptionService.decryptMessageContents(
          contents, senderPhoneNumber);

      final message = Message(
        id: id,
        chatId: chatId,
        isIncoming: true,
        contents: decryptedContents,
        timestamp: DateTime.fromMillisecondsSinceEpoch(timestamp),
        readReceipt: ReadReceipt.delivered,
        deleted: false,
        liked: false,
        tags: [],
      );

      return message;
    }
  }

  Future<void> sendMessage(Message message, String recipientPhoneNumber) async {
    final userPhoneNumber = await userService.getPhoneNumber();

    final encryptedContents = await encryptionService.encryptMessageContent(
        message.contents, recipientPhoneNumber);

    final data = {
      "id": message.id,
      "senderPhoneNumber": userPhoneNumber,
      "recipientPhoneNumber": recipientPhoneNumber,
      "chatId": message.chatId,
      "contents": encryptedContents
    };

    await post(Uri.parse("${Constants.httpUrl}messages"),
        body: jsonEncode(data));
  }
}
