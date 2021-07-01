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

  static Contact? fromMap(Map<String, Object?> map) {
    final phoneNumber = map[Contact.COLUMN_PHONE_NUMBER];
    final displayName = map[Contact.COLUMN_DISPLAY_NAME];
    final hasChat = map[Contact.COLUMN_HAS_CHAT];

    if (phoneNumber is String && displayName is String && hasChat is int) {
      return Contact(phoneNumber, displayName, hasChat == 1);
    } else {
      return null;
    }
  }

  static const String TABLE_NAME = "contact";
  static const String COLUMN_PHONE_NUMBER = "phone_number";
  static const String COLUMN_DISPLAY_NAME = "display_name";
  static const String COLUMN_HAS_CHAT = "has_chat";

  static const String CREATE_TABLE =
      "create table $TABLE_NAME ($COLUMN_PHONE_NUMBER text primary key, $COLUMN_DISPLAY_NAME text not null, $COLUMN_HAS_CHAT tinyint not null);";
}
