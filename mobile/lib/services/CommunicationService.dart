import 'dart:async';
import 'dart:convert';
import 'package:encrypt/encrypt.dart';
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
  Future<String> userPhoneNumber;

  IOWebSocketChannel? channel;
  StreamController<MessagePayload> _messageQueue = StreamController();

  List<void Function(Message message)> _onMessageListeners = [];
  void Function(String messageId)? onDelete;
  void Function(String contactPhoneNumber, String profileImage)? onProfileImage;
  void Function(String contactPhoneNumber, String status)? onStatus;
  void Function(String messageId)? onAck;
  void Function(List<String> messageIds)? onAckSeen;

  set onMessage(void Function(Message message) cb) =>
      _onMessageListeners.add(cb);

  CommunicationService(this.encryptionService, this.userService)
      : userPhoneNumber = userService.getPhoneNumber() {
    final uri = Uri.parse("${Constants.httpUrl}messages");

    _messageQueue.stream.listen(
      (payload) async {
        // TODO re-enable encryption
        // final encryptedContents = await encryptionService.encryptMessageContent(
        //     payload.contents, payload.recipientPhoneNumber);
        //
        // payload.contents = encryptedContents;

        await post(uri, body: jsonEncode(payload.asMap));
      },
      onDone: () => _messageQueue.close(),
    );
  }

  Future<void> goOnline() async {
    final phoneNumber = await userService.getPhoneNumber();

    final encodedPhoneNumber = Uri.encodeQueryComponent(phoneNumber);

    channel?.sink.close();
    channel = IOWebSocketChannel.connect(
      Uri.parse("${Constants.webSocketUrl}?phoneNumber=$encodedPhoneNumber"),
      pingInterval: Duration(minutes: 9),
    );

    channel?.stream.listen((event) async {
      await _handleEvent(event);
    });
  }

  Future<void> _handleEvent(dynamic event) async {
    final Map<String, Object?> parsedEvent = jsonDecode(event);

    final id = parsedEvent["id"] as String?;
    final senderPhoneNumber = parsedEvent["senderPhoneNumber"] as String?;
    final timestamp = parsedEvent["timestamp"] as int?;
    final encryptedContents = parsedEvent["contents"] as String?;

    if (id != null &&
        senderPhoneNumber != null &&
        timestamp != null &&
        encryptedContents != null) {
      // TODO re-enable decryption
      // final Map<String, Object?> decryptedContents = jsonDecode(
      //     await encryptionService.decryptMessageContents(
      //         encryptedContents, senderPhoneNumber));

      final decryptedContents = jsonDecode(encryptedContents);

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

          _onMessageListeners.forEach((listener) => listener(message));
          break;
        case "delete":
          final messageId = decryptedContents["messageId"] as String;
          final onDelete = this.onDelete;
          if (onDelete != null) onDelete(messageId);
          break;
        case "profileImage":
          final imageId = decryptedContents["imageId"] as String;
          final base16Key = decryptedContents["key"] as String;
          final base16IV = decryptedContents["iv"] as String;

          final key = Key.fromBase16(base16Key);
          final iv = IV.fromBase16(base16IV);

          final image =
              await _fetchProfileImage(senderPhoneNumber, imageId, key, iv);

          final onProfileImage = this.onProfileImage;
          if (onProfileImage != null && image != null)
            onProfileImage(senderPhoneNumber, image);
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
        case "requestStatus":
          break;
      }
    }
  }

  Future<String?> _fetchProfileImage(
      String senderPhoneNumber, String mediaId, Key key, IV iv) async {
    final uri = Uri.parse(Constants.httpUrl + "upload");
    final body = {"mediaId": mediaId, "method": "GET"};
    final response = await post(uri, body: jsonEncode(body));

    if (response.statusCode == 200) {
      print("received mediaUrl");

      final mediaUrl = Uri.parse(response.body);
      final mediaResponse = await get(mediaUrl);

      if (mediaResponse.statusCode == 200) {
        print("received image");

        final encryptor = Encrypter(AES(key));

        final decryptedImage = encryptor.decrypt64(mediaResponse.body, iv: iv);

        final onProfileImage = this.onProfileImage;
        if (onProfileImage != null)
          onProfileImage(senderPhoneNumber, decryptedImage);
      } else {
        print("${response.statusCode} - ${response.body}");
      }
    } else {
      print("${response.statusCode} - ${response.body}");
    }
  }

  Future<void> sendMessage(Message message, String recipientPhoneNumber) async {
    final contents = jsonEncode({
      "type": "message",
      "chatId": message.chatId,
      "text": message.contents,
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

  Future<void> sendProfileImage(
      String profileImageBase64, String recipientPhoneNumber) async {
    final base16Key = SecureRandom(32).base16;
    final base16IV = SecureRandom(16).base16;

    final key = Key.fromBase16(base16Key);
    final iv = IV.fromBase16(base16IV);

    final encryptor = Encrypter(AES(key));

    final mediaId = Uuid().v4();
    final encryptedImage = encryptor.encrypt(profileImageBase64, iv: iv);

    final uri = Uri.parse(Constants.httpUrl + "upload");
    final body = {"mediaId": mediaId, "method": "PUT"};
    final response = await post(uri, body: jsonEncode(body));

    if (response.statusCode == 200) {
      final uploadUrl = Uri.parse(response.body);
      final uploadResponse = await put(uploadUrl, body: encryptedImage.base64);

      if (uploadResponse.statusCode == 200) {
        final contents = jsonEncode({
          "type": "profileImage",
          "key": base16Key,
          "iv": base16IV,
          "imageId": mediaId,
        });

        _queueForSending(contents, recipientPhoneNumber);
      } else {
        print("${uploadResponse.statusCode} - ${uploadResponse.body}");
      }
    } else {
      print("${response.statusCode} - ${response.body}");
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

    _queueForSending(contents, recipientPhoneNumber);
  }

  Future<void> requestStatus(String contactPhoneNumber) async {
    final contents = jsonEncode({"type": "requestStatus"});
    _queueForSending(contents, contactPhoneNumber);
  }

  void _queueForSending(String unencryptedContents, String recipientPhoneNumber,
      {String? id}) async {
    final userPhoneNumber = await this.userPhoneNumber;

    final payload = MessagePayload(
      id: id ?? Uuid().v4(),
      senderPhoneNumber: userPhoneNumber,
      recipientPhoneNumber: recipientPhoneNumber,
      contents: unencryptedContents,
    );

    _messageQueue.sink.add(payload);
  }
}

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
