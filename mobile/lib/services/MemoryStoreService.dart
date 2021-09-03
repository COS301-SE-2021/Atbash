class MemoryStoreService {
  final List<String> _onlineContacts = [];
  final List<String> _typingContacts = [];

  void addOnlineContact(String contactPhoneNumber) {
    _onlineContacts.add(contactPhoneNumber);
  }

  void removeOnlineContact(String contactPhoneNumber) {
    _onlineContacts.remove(contactPhoneNumber);
  }

  bool isContactOnline(String contactPhoneNumber) {
    return _onlineContacts.contains(contactPhoneNumber);
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
