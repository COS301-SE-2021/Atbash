class Contact {
  final String phoneNumber;
  String displayName;
  bool hasChat;

  Contact(this.phoneNumber, this.displayName, this.hasChat);

  Map<String, dynamic> toMap() {
    return {
      COLUMN_PHONE_NUMBER: this.phoneNumber,
      COLUMN_DISPLAY_NAME: this.displayName,
      COLUMN_HAS_CHAT: this.hasChat ? 1 : 0
    };
  }

  static Contact fromMap(Map<String, dynamic> map) {
    final number = map["phone_number"] as String;
    final displayName = map["display_name"] as String;
    final hasChat = (map["has_chat"] as int) != 0;

    return Contact(number, displayName, hasChat);
  }

  static const String TABLE_NAME = "contact";
  static const String COLUMN_PHONE_NUMBER = "phone_number";
  static const String COLUMN_DISPLAY_NAME = "display_name";
  static const String COLUMN_HAS_CHAT = "has_chat";

  static const String CREATE_TABLE =
      "create table $TABLE_NAME ($COLUMN_PHONE_NUMBER text primary key, $COLUMN_DISPLAY_NAME text not null, $COLUMN_HAS_CHAT tinyint not null);";
}
