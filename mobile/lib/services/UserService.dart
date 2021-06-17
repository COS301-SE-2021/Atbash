import 'dart:collection';

import 'package:get_it/get_it.dart';
import 'package:mobile/domain/Contact.dart';
import 'package:mobile/domain/User.dart';
import 'package:mobile/services/DatabaseAccess.dart';

class UserService {
  final db = GetIt.I.get<DatabaseAccess>();

  User? _loggedInUser;

  List<void Function(User)> _userInfoListeners = [];
  List<void Function(UnmodifiableListView<Contact>)> _chatsListeners = [];

  void login(String number, String password) {
    // TODO this is mock data
    _loggedInUser = User(number, "Dylan Pfab", "Just chilling");
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
