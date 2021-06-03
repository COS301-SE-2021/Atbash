import 'dart:collection';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:mobile/domain/Chat.dart';
import 'package:mobile/domain/Contact.dart';
import 'package:mobile/domain/Message.dart';
import 'package:mobile/domain/User.dart';

class SystemModel extends ChangeNotifier {
  User? _loggedInUser = User("12345", "Dylan Pfab", "Hi");

  SystemModel() {
    var c = Contact("123", "Josh", "");
    c.chat = Chat();

    var c2 = Contact("456", "Liam", "");
    c2.chat = Chat();

    var c3 = Contact("789", "Connor", "");

    var c4 = Contact("123456", "Targo", "");

    _loggedInUser?.addContact(c);
    _loggedInUser?.addContact(c2);
    _loggedInUser?.addContact(c3);
    _loggedInUser?.addContact(c4);
  }

  // User information
  String? get userPhoneNumber => _loggedInUser?.phoneNumber;
  String? get userDisplayName => _loggedInUser?.displayName;
  String? get userStatus => _loggedInUser?.status;

  void setUserDisplayName(String displayName) {
    _loggedInUser?.displayName = displayName;
    notifyListeners();
  }

  void setUserStatus(String status) {
    _loggedInUser?.status = status;
    notifyListeners();
  }

  // User contacts
  UnmodifiableListView<Contact> get userContacts =>
      UnmodifiableListView(_loggedInUser?.contacts ?? []);

  // User chats
  UnmodifiableListView<Contact> get userChats => UnmodifiableListView(
      _loggedInUser?.contacts.where((c) => c.chat != null) ?? []);

  void sendMessage(Contact contact, String contents) {
    if (userPhoneNumber != null) {
      contact.chat?.addMessage(
          Message(userPhoneNumber!, contact.phoneNumber, contents));
      contact.chat?.addMessage(Message(
          contact.phoneNumber, userPhoneNumber!, _randomResponseGenerator()));
      notifyListeners();
    }
  }

  void createChatWithContact(String contactNumber) {
    _loggedInUser?.contacts
        .firstWhere((c) => c.phoneNumber == contactNumber)
        .chat = Chat();
    notifyListeners();
  }

  String _randomResponseGenerator() {
    List<String> responses = [
      "Hello",
      "k",
      "perfect!",
      "Why don't you love me anymore? I thought we had something special. :(",
      "Bye!",
      "I'm good thanks"
    ];
    Random rnd = Random();
    return responses[rnd.nextInt(responses.length)];
  }
}
