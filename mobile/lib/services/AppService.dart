import 'package:mobile/domain/Message.dart';
import 'package:mobile/services/DatabaseService.dart';
import 'package:mobile/services/UserService.dart';

class AppService {
  final UserService _userService;
  final DatabaseService _databaseService;

  AppService(this._userService, this._databaseService);

  /// Connect the application to the server. A web socket connection is made,
  /// and the service will listen to and handle events on the socket.
  void goOnline(String accessToken) {
    throw UnimplementedError();
  }

  /// Send a message to a [recipientNumber] through the web socket. The message
  /// is additionally saved in the database, and is returned.
  Future<Message> sendMessage(String recipientNumber, String contents) {
    throw UnimplementedError();
  }

  /// Adds [fn] as a callback function to new messages from [senderNumber].
  void listenForMessagesFrom(String senderNumber, void Function(Message m) fn) {
    throw UnimplementedError();
  }

  /// Removed [senderNumber] from the callback map.
  void stopListeningForMessagesFrom(String senderNumber) {
    throw UnimplementedError();
  }
}
