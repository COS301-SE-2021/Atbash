import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:mobile/domain/Message.dart';
import 'package:mobile/models/ChatModel.dart';
import 'package:mobile/models/ContactsModel.dart';
import 'package:mobile/services/DatabaseService.dart';
import 'package:mobile/services/NotificationService.dart';
import 'package:mobile/services/UserService.dart';
import 'package:uuid/uuid.dart';
import 'package:web_socket_channel/io.dart';

class AppService {
  IOWebSocketChannel? _channel;

  final UserService _userService;
  final DatabaseService _databaseService;
  final NotificationService _notificationService;
  final ContactsModel _contactsModel;
  final ChatModel chatModel;

  final _messageQueue = StreamController<String>();

  AppService(
    this._userService,
    this._databaseService,
    this._notificationService,
    this._contactsModel,
    this.chatModel,
  ) {
    _messageQueue.stream.listen((event) async {
      final channel = _channel;
      if (channel != null) {
        channel.sink.add(event);
      } else {
        await goOnline();

        final channel = _channel;
        if (channel != null) {
          channel.sink.add(event);
        }
      }
    });
  }

  /// Connect the application to the server. A web socket connection is made,
  /// and the service will listen to and handle events on the socket. The user's
  /// access_token is used to connect. If this is not set, a [StateError] is
  /// thrown
  Future<void> goOnline() async {
    final phoneNumber = await _userService.getUserPhoneNumber();

    final encodedPhoneNumber = Uri.encodeQueryComponent("$phoneNumber");

    _channel = IOWebSocketChannel.connect(
      Uri.parse(
          "wss://8tnhyjrehg.execute-api.af-south-1.amazonaws.com/dev/?phoneNumber=$encodedPhoneNumber"),
      pingInterval: Duration(minutes: 3),
    );

    final channel = this._channel;
    if (channel != null) {
      channel.stream.listen(
        (event) => _handleEvent(phoneNumber, event),
        onDone: () {
          if (channel.closeCode != 1005) {
            this._channel = null;
          }
        },
      );
    }

    _fetchUnreadMessages();
  }

  void _fetchUnreadMessages() async {
    final phoneNumber = await _userService.getUserPhoneNumber();
    final encodedPhoneNumber = Uri.encodeQueryComponent("$phoneNumber");

    final url = Uri.parse(
        "https://bjarhthz5j.execute-api.af-south-1.amazonaws.com/dev/message?phoneNumber=$encodedPhoneNumber");

    final response = await get(url);
    if (response.statusCode == 200) {
      final messages = jsonDecode(response.body);
      if (messages is List) {
        messages.forEach((m) {
          final id = m["id"] as String?;
          if (id != null) {
            _databaseService.messageWithIdExists(id).then((exists) {
              if (exists) {
                _deleteMessageFromServer(id);
              } else {
                _handleEvent(phoneNumber, m);
              }
            });
          }
        });
      }
    } else {
      print("Failed to get messages: ${response.statusCode}: ${response.body}");
    }
  }

  void _deleteMessageFromServer(String id) {
    final url = Uri.parse(
        "https://bjarhthz5j.execute-api.af-south-1.amazonaws.com/dev/message/$id");
    delete(url);
  }

  void _handleEvent(String userPhoneNumber, dynamic event) {
    final decodedEvent =
        event is Map ? event : jsonDecode(event) as Map<String, Object?>;
    final id = decodedEvent["id"] as String?;
    final fromNumber = decodedEvent["senderPhoneNumber"] as String?;
    final contents = decodedEvent["contents"] as Map<String, Object?>?;
    final timestamp = decodedEvent["timestamp"] as int?;

    if (id != null && fromNumber != null && contents != null) {
      final eventType = contents["type"] as String?;
      switch (eventType) {
        case "message":
          final text = contents["text"] as String?;
          if (text != null) {
            _handleMessageEvent(
                id, fromNumber, userPhoneNumber, text, timestamp);
          }
          break;
        case "profileImage":
          final image = contents["imageData"] as String?;
          if (image != null) {
            _handleProfileImageEvent(fromNumber, image);
          }
          _deleteMessageFromServer(id);
          break;
        case "status":
          final status = contents["status"] as String?;
          if (status != null) {
            _handleStatusEvent(fromNumber, status);
          }
          _deleteMessageFromServer(id);
          break;
        case "ack":
          final messageId = contents["id"] as String?;
          if (messageId != null) {
            _handleAckEvent(messageId);
          }
          _deleteMessageFromServer(id);
          break;
      }
    }
  }

  void _handleMessageEvent(
    String id,
    String fromNumber,
    String userPhoneNumber,
    String text,
    int? timestamp,
  ) {
    final message = _databaseService.saveMessage(
      fromNumber,
      userPhoneNumber,
      text,
      id: id,
      timestamp: timestamp,
    );

    sendAcknowledgement(fromNumber, message.id);

    if (chatModel.contactPhoneNumber == fromNumber) {
      chatModel.addMessage(message);
    } else {
      _databaseService.fetchContactByNumber(fromNumber).then((fromContact) {
        String title = fromNumber;

        if (fromContact == null) {
          _contactsModel.addContact(fromNumber, "", true, false);
        } else if (fromContact.hasChat == false) {
          _contactsModel.startChatWithContact(fromNumber);
        } else {
          if (fromContact.displayName.isNotEmpty)
            title = fromContact.displayName;
        }

        _notificationService.showNotification(
          1,
          title,
          text,
          fromNumber,
          false,
        );
      });
    }
  }

  void _handleDeleteEvent(String fromNumber, List<String> ids) {
    chatModel.removeMessages(ids);
    _databaseService.deleteMessagesConstrainContact(fromNumber, ids);
  }

  void _handleProfileImageEvent(String fromNumber, String imageBase64) {
    _contactsModel.setContactProfileImage(fromNumber, imageBase64);
  }

  void _handleStatusEvent(String fromNumber, String status) {
    _contactsModel.setContactStatus(fromNumber, status);
  }

  void _handleAckEvent(String messageId) {
    chatModel.markMessageSeen(messageId);
  }

  /// Disconnect the user from the server
  void disconnect() {
    final channel = this._channel;

    if (channel != null) {
      channel.sink.close();
    }
  }

  /// Send a message to a [recipientNumber] through the web socket. The message
  /// is additionally saved in the database, and is returned.
  Future<Message> sendMessage(String recipientNumber, String text) async {
    final userPhoneNumber = await _userService.getUserPhoneNumber();
    print(userPhoneNumber);
    final savedMessage = _databaseService.saveMessage(
      userPhoneNumber,
      recipientNumber,
      text,
    );

    final data = {
      "action": "sendmessage",
      "id": savedMessage.id,
      "recipientPhoneNumber": recipientNumber,
      "contents": {
        "type": "message",
        "text": text,
      },
    };

    _messageQueue.add(jsonEncode(data));

    return savedMessage;
  }

  void requestDeleteMessages(String recipientNumber, List<String> ids) async {
    final data = {
      "action": "sendmessage",
      "id": Uuid().v4(),
      "recipientPhoneNumber": recipientNumber,
      "contents": {
        "type": "delete",
        "ids": ids,
      }
    };

    _messageQueue.add(jsonEncode(data));
  }

  void sendStatus(String recipientNumber, String status) {
    final data = {
      "action": "sendmessage",
      "id": Uuid().v4(),
      "recipientPhoneNumber": recipientNumber,
      "contents": {
        "type": "status",
        "status": status,
      }
    };

    _messageQueue.add(jsonEncode(data));
  }

  void sendProfileImage(String recipientNumber, String base64Image) {
    final data = {
      "action": "sendmessage",
      "id": Uuid().v4(),
      "recipientPhoneNumber": recipientNumber,
      "contents": {
        "type": "profileImage",
        "imageData": base64Image,
      }
    };

    _messageQueue.add(jsonEncode(data));
  }

  void sendAcknowledgement(String recipientNumber, String messageId) {
    final data = {
      "action": "sendmessage",
      "id": Uuid().v4(),
      "recipientPhoneNumber": recipientNumber,
      "contents": {
        "type": "ack",
        "id": messageId,
      }
    };

    _messageQueue.add(jsonEncode(data));
  }
}
