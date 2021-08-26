import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:mobile/constants.dart';
import 'package:mobile/domain/Message.dart';
import 'package:mobile/services/EncryptionService.dart';
import 'package:mobile/services/UserService.dart';
import 'package:web_socket_channel/io.dart';

//Use "encryptMessageContent" and "decryptMessageContents"
//from "EncryptionService"
//for encrypting and decrypting messsages

class CommunicationService {
  final EncryptionService encryptionService;
  final UserService userService;

  CommunicationService(this.encryptionService, this.userService);

  Stream<Message> listenForMessages() async* {
    throw UnimplementedError();
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
