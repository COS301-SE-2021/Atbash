class ChatCacheService {
  Map<String, String> _typedMessages = {};

  void put(String chatId, String message) {
    _typedMessages[chatId] = message;
  }

  String get(String chatId) {
    return _typedMessages[chatId] ?? "";
  }
}
