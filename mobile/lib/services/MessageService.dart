import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/domain/Contact.dart';
import 'package:mobile/domain/Message.dart';
import 'package:mobile/services/DatabaseAccess.dart';
import 'package:mobile/services/UserService.dart';
import 'package:uuid/uuid.dart';

class MessageService {
  final db = GetIt.I.get<DatabaseAccess>();
  final Contact _contact;
  List<Message> _messages = [];
  List<void Function(List<Message>)> _newMessageListeners = [];

  MessageService(this._contact) {
    db.getChatWithContact(_contact.phoneNumber).then((messages) {
      this._messages = messages;
      _notifyNewMessageListeners(_messages);
    });

    fetchUnreadMessages().then((messages) {
      this._messages.addAll(messages);
      _notifyNewMessageListeners(messages);
    });
  }

  void sendMessage(String from, String to, String contents) async {
    final message = db.saveMessage(from, to, contents);

    _addMessage(message);

    final storage = FlutterSecureStorage();
    final bearerToken = await storage.read(key: "bearer_token");

    final url = Uri.parse("http://10.0.2.2:8080/rs/v1/messages");
    final headers = {"Authorization": "Bearer $bearerToken"};
    final body = {"to": to, "contents": contents};

    http.post(
      url,
      headers: headers,
      body: body,
    ); //  TODO should use 200 to mark message as sent in db
  }

  Future<List<Message>> fetchUnreadMessages() async {
    final storage = FlutterSecureStorage();
    final bearerToken = await storage.read(key: "bearer_token");
    final userPhoneNumber = GetIt.I.get<UserService>().getUser()?.phoneNumber;

    if (userPhoneNumber != null) {
      final url = Uri.parse("http://10.0.2.2:8080/rs/v1/messages");
      final headers = {"Authorization": "Bearer $bearerToken"};

      final response = await http.get(url, headers: headers);
      final Iterable body = jsonDecode(response.body);

      final uuid = Uuid();
      final messages = <Message>[];
      body.forEach((element) {
        final m = _parseUnreadMessageMap(uuid.v4(), userPhoneNumber, element);
        if (m != null) {
          messages.add(m);
        }
      });
      return messages;
    } else {
      return [];
    }
  }

  Message? _parseUnreadMessageMap(
      String id, String to, Map<dynamic, dynamic> map) {
    final String from = map["fromNumber"];
    final String contents = map["contents"];
    return Message(id, from, to, contents);
  }

  void _addMessage(Message m) {
    _messages.add(m);
    _notifyNewMessageListeners([m]);
  }

  void listenForNewMessages(void Function(List<Message>) cb) {
    _newMessageListeners.add(cb);
  }

  void _notifyNewMessageListeners(List<Message> of) {
    _newMessageListeners.forEach((listener) {
      listener(of);
    });
  }
}
