import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile/domain/Message.dart';
import 'package:mobile/services/DatabaseService.dart';
import 'package:mobile/services/UserService.dart';
import 'package:web_socket_channel/io.dart';

class AppService {
  IOWebSocketChannel? _channel;

  final UserService _userService;
  final DatabaseService _databaseService;

  AppService(this._userService, this._databaseService);

  final Map<String, void Function(Message m)> messageReceivedCallbacks = {};

  /// Connect the application to the server. A web socket connection is made,
  /// and the service will listen to and handle events on the socket. The user's
  /// access_token is used to connect. If this is not set, a [StateError] is
  /// thrown
  void goOnline() async {
    final storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: "access_token");

    if (accessToken == null) {
      throw StateError("access_token is not readable");
    }

    _channel = IOWebSocketChannel.connect(
      Uri.parse("ws://10.0.2.2:8080/chat?access_token=$accessToken"),
    );

    final channel = this._channel;
    final phoneNumber = await _userService.getUserPhoneNumber();

    if (channel != null) {
      await for (final event in channel.stream) {
        _handleEvent(phoneNumber, event);
      }
    }
  }

  void _handleEvent(String userPhoneNumber, dynamic event) {
    final decodedEvent = jsonDecode(event) as Map<String, Object?>;
    final fromNumber = decodedEvent["fromNumber"] as String?;
    final contents = decodedEvent["contents"] as String?;
    final timestamp = decodedEvent["timestamp"] as int?;

    if (fromNumber != null && contents != null && timestamp != null) {
      final message = _databaseService.saveMessage(
        fromNumber,
        userPhoneNumber,
        contents,
      );

      final callback = messageReceivedCallbacks[fromNumber];
      if (callback != null) {
        callback(message);
      } else {
        // TODO handle if not currently in chat
      }
    }
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
  Future<Message> sendMessage(String recipientNumber, String contents) async {
    final channel = this._channel;
    if (channel != null) {
      final data = {
        "recipientNumber": recipientNumber,
        "contents": contents,
      };

      channel.sink.add(jsonEncode(data));
    }

    final userPhoneNumber = await _userService.getUserPhoneNumber();
    return _databaseService.saveMessage(
      userPhoneNumber,
      recipientNumber,
      contents,
    );
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
