import 'package:mobile/util/Tuple.dart';

class MemoryStoreService {
  final List<String> _onlineContacts = [];
  final List<Tuple<String, void Function(bool online)>>
      _onContactOnlineListeners = [];

  final List<String> _typingContacts = [];

  void addOnlineContact(String contactPhoneNumber) {
    _onlineContacts.add(contactPhoneNumber);
    _onContactOnlineListeners
        .where((element) => element.first == contactPhoneNumber)
        .forEach((element) => element.second(true));
  }

  void removeOnlineContact(String contactPhoneNumber) {
    _onlineContacts.remove(contactPhoneNumber);
    _onContactOnlineListeners
        .where((element) => element.first == contactPhoneNumber)
        .forEach((element) => element.second(false));
  }

  bool isContactOnline(String contactPhoneNumber) {
    return _onlineContacts.contains(contactPhoneNumber);
  }

  void onContactOnline(
      String contactPhoneNumber, void Function(bool online) cb) {
    _onContactOnlineListeners.add(Tuple(contactPhoneNumber, cb));
  }

  void disposeOnContactOnline(void Function(bool online) cb) {
    _onContactOnlineListeners.removeWhere((element) => element.second == cb);
  }

  void addTypingContact(String contactPhoneNumber) {
    _typingContacts.add(contactPhoneNumber);
  }

  void removeTypingContact(String contactPhoneNumber) {
    _typingContacts.remove(contactPhoneNumber);
  }

  bool isContactTyping(String contactPhoneNumber) {
    return _typingContacts.contains(contactPhoneNumber);
  }
}
