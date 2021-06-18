import 'dart:collection';
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/domain/Contact.dart';
import 'package:mobile/domain/User.dart';
import 'package:mobile/services/DatabaseAccess.dart';

class UserService {
  final db = GetIt.I.get<DatabaseAccess>();

  User? _loggedInUser;

  List<void Function(User)> _userInfoListeners = [];
  List<void Function(UnmodifiableListView<Contact>)> _chatsListeners = [];

  Future<bool> login(String number, String password) async {
    // TODO this is mock data
    _loggedInUser = User(number, "Dylan Pfab", "Just chilling");
    final url = Uri.parse("http://10.0.2.2:8080/rs/v1/login");

    final bodyMap = {"number": number, "password": password};

    final body = jsonEncode(bodyMap);

    final headers = {"Content-Type": "application/json"};

    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      final storage = FlutterSecureStorage();
      storage.write(key: "bearer_token", value: response.body);
    }
    return response.statusCode == 200;
  }

  Future<bool> register(
      String number, String deviceToken, String password) async {
    final url = Uri.parse("http://10.0.2.2:8080/rs/v1/register");

    final bodyMap = {
      "number": number,
      "deviceToken": deviceToken,
      "password": password
    };
    final body = jsonEncode(bodyMap);

    final headers = {
      "Content-Type": "application/json",
    };

    final response = await http.post(url, headers: headers, body: body);
    return response.statusCode == 200;
  }

  void setDisplayName(String displayName) {
    final user = _loggedInUser;
    if (user != null) {
      user.displayName = displayName;
      _notifyUserInfoListeners();
    }
  }

  void setStatus(String status) {
    final user = _loggedInUser;
    if (user != null) {
      user.status = status;
      _notifyUserInfoListeners();
    }
  }

  Future<Contact?> newChat(String withContactNumber) async {
    final user = _loggedInUser;
    if (user != null) {
      final created = await db.createChatWithContact(withContactNumber);
      if (created) {
        _notifyChatsListeners();
        return await db.fetchContact(withContactNumber);
      } else {
        return null;
      }
    }
  }

  void deleteChat(String withContactNumber) {
    final user = _loggedInUser;
    if (user != null) {}
  }

  User? getUser() {
    return _loggedInUser;
  }

  Future<UnmodifiableListView<Contact>> getContactsWithChats() async {
    final contacts = await db.getContactsWithChats();
    return UnmodifiableListView(contacts);
  }

  Future<UnmodifiableListView<Contact>> getContacts() async {
    final contacts = await db.getContacts();
    return UnmodifiableListView(contacts);
  }

  void onChangeUserInfo(void Function(User) callback) {
    this._userInfoListeners.add(callback);
  }

  void onChangeChats(void Function(UnmodifiableListView<Contact>) callback) {
    this._chatsListeners.add(callback);
  }

  void _notifyUserInfoListeners() {
    final user = this._loggedInUser;
    if (user != null) {
      _userInfoListeners.forEach((listener) {
        listener(user);
      });
    }
  }

  Future<void> _notifyChatsListeners() async {
    final chats = await getContactsWithChats();
    _chatsListeners.forEach((listener) {
      listener(chats);
    });
  }
}
