import 'dart:convert';

import 'package:http/http.dart';
import 'package:mobile/domain/Message.dart';
import 'package:mobile/models/UserModel.dart';
import 'package:mobile/services/ContactsService.dart';
import 'package:mobile/services/DatabaseService.dart';
import 'package:mobile/services/NotificationService.dart';
import 'package:mobile/services/UserService.dart';
import 'package:uuid/uuid.dart';
import 'package:web_socket_channel/io.dart';

class AppService {
  IOWebSocketChannel? _channel;

  final UserService _userService;
  final UserModel _userModel;
  final DatabaseService _databaseService;
  final NotificationService _notificationService;
  final ContactsService _contactsService;

  AppService(
    this._userService,
    this._userModel,
    this._databaseService,
    this._notificationService,
    this._contactsService,
  );

  final Map<String, void Function(Message m)> messageReceivedCallbacks = {};

  /// Connect the application to the server. A web socket connection is made,
  /// and the service will listen to and handle events on the socket. The user's
  /// access_token is used to connect. If this is not set, a [StateError] is
  /// thrown
  void goOnline() async {
    final phoneNumber = await _userService.getUserPhoneNumber();

    _channel = IOWebSocketChannel.connect(
      Uri.parse(
          "wss://8tnhyjrehg.execute-api.af-south-1.amazonaws.com/dev/?phoneNumber=$phoneNumber"),
    );

    final channel = this._channel;
    if (channel != null) {
      channel.stream.forEach((event) {
        _handleEvent(phoneNumber, event);
      });
    }

    _fetchUnreadMessages();
  }

  void _fetchUnreadMessages() async {
    final phoneNumber = await _userService.getUserPhoneNumber();

    final url = Uri.parse(
        "https://bjarhthz5j.execute-api.af-south-1.amazonaws.com/dev/message?phoneNumber=$phoneNumber");

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

    if (id != null && fromNumber != null && contents != null) {
      final eventType = contents["type"] as String?;
      switch (eventType) {
        case "message":
          final text = contents["text"] as String?;
          if (text != null) {
            _handleMessageEvent(id, fromNumber, userPhoneNumber, text);
          }
          break;
        case "requestProfileImage":
          _handleRequestProfileImageEvent(fromNumber);
          _deleteMessageFromServer(id);
          break;
        case "profileImage":
          final image = contents["imageData"] as String?;
          if (image != null) {
            _handleProfileImageEvent(fromNumber, image);
          }
          _deleteMessageFromServer(id);
          break;
        case "requestStatus":
          _handleRequestStatusEvent(fromNumber);
          _deleteMessageFromServer(id);
          break;
        case "status":
          final status = contents["status"] as String?;
          if (status != null) {
            _handleStatusEvent(fromNumber, status);
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
  ) {
    final message =
        _databaseService.saveMessage(fromNumber, userPhoneNumber, text, id: id);

    final callback = messageReceivedCallbacks[fromNumber];
    if (callback != null) {
      callback(message);
    } else {
      _databaseService.fetchContactByNumber(fromNumber).then((fromContact) {
        String title = fromNumber;

        if (fromContact == null) {
          _contactsService.addContact(fromNumber, "", true, false);
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

  void _handleRequestProfileImageEvent(String fromNumber) async {
    final channel = this._channel;
    if (channel != null) {
      final imageData = await _userService.getUserProfilePictureAsString();

      final data = {
        "action": "sendmessage",
        "id": Uuid().v4(),
        "recipientPhoneNumber": fromNumber,
        "contents": {
          "type": "profileImage",
          "imageData": imageData,
        }
      };

      channel.sink.add(jsonEncode(data));
    }
  }

  void _handleProfileImageEvent(String fromNumber, String imageBase64) {
    _contactsService.setContactProfileImage(fromNumber, imageBase64);
  }

  void _handleRequestStatusEvent(String fromNumber) {
    final channel = this._channel;
    if (channel != null) {
      final status = _userModel.status;

      final data = {
        "action": "sendmessage",
        "id": Uuid().v4(),
        "recipientPhoneNumber": fromNumber,
        "contents": {
          "type": "status",
          "status": status,
        }
      };

      channel.sink.add(jsonEncode(data));
    }
  }

  void _handleStatusEvent(String fromNumber, String status) {
    _contactsService.setContactStatus(fromNumber, status);
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
    final savedMessage = _databaseService.saveMessage(
      userPhoneNumber,
      recipientNumber,
      text,
    );

    final channel = this._channel;
    if (channel != null) {
      final data = {
        "action": "sendmessage",
        "id": savedMessage.id,
        "recipientPhoneNumber": recipientNumber,
        "contents": {"type": "message", "text": text},
      };

      channel.sink.add(jsonEncode(data));
    }

    return savedMessage;
  }

  void sendStatus(String recipientNumber, String status) {
    final channel = this._channel;
    if (channel != null) {
      final data = {
        "action": "sendmessage",
        "id": Uuid().v4(),
        "recipientPhoneNumber": recipientNumber,
        "contents": {
          "type": "status",
          "status": status,
        }
      };

      channel.sink.add(data);
    }
  }

  /// Adds [fn] as a callback function to new messages from [senderNumber].
  void listenForMessagesFrom(String senderNumber, void Function(Message m) fn) {
    messageReceivedCallbacks[senderNumber] = fn;
  }

  /// Removed [senderNumber] from the callback map.
  void stopListeningForMessagesFrom(String senderNumber) {
    messageReceivedCallbacks.remove(senderNumber);
  }
}
