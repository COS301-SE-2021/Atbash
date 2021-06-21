class Contact {
  final String phoneNumber;
  final String displayName;
  bool hasChat;

  Contact(this.phoneNumber, this.displayName, this.hasChat);

  Map<String, dynamic> toMap() {
    return {
      "phone_number": phoneNumber,
      "display_name": displayName,
      "has_chat": hasChat,
    };
  }

  static Contact fromMap(Map<String, dynamic> map) {
    final number = map["phone_number"] as String;
    final displayName = map["display_name"] as String;
    final hasChat = (map["has_chat"] as int) != 0;

    return Contact(number, displayName, hasChat);
  }
}
