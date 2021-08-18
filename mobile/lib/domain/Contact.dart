class Contact {
  final String phoneNumber;
  String displayName;
  String status;
  String profileImage;
  bool hasChat;
  bool saved;
  String symmetricKey;

  Contact(
    this.phoneNumber,
    this.displayName,
    this.status,
    this.profileImage,
    this.hasChat,
    this.saved,
    this.symmetricKey,
  );

  Map<String, dynamic> toMap() {
    return {
      COLUMN_PHONE_NUMBER: this.phoneNumber,
      COLUMN_DISPLAY_NAME: this.displayName,
      COLUMN_STATUS: this.status,
      COLUMN_PROFILE_IMAGE: this.profileImage,
      COLUMN_HAS_CHAT: this.hasChat ? 1 : 0,
      COLUMN_SAVED: this.saved ? 1 : 0,
      COLUMN_SYMMETRIC_KEY: this.symmetricKey,
    };
  }

  static Contact? fromMap(Map<String, Object?> map) {
    final phoneNumber = map[Contact.COLUMN_PHONE_NUMBER];
    final displayName = map[Contact.COLUMN_DISPLAY_NAME];
    final status = map[Contact.COLUMN_STATUS];
    final profileImage = map[Contact.COLUMN_PROFILE_IMAGE];
    final hasChat = map[Contact.COLUMN_HAS_CHAT];
    final saved = map[Contact.COLUMN_SAVED];
    final symmetricKey = map[Contact.COLUMN_SYMMETRIC_KEY];

    if (phoneNumber is String &&
        displayName is String &&
        status is String &&
        profileImage is String &&
        hasChat is int &&
        saved is int &&
        symmetricKey is String) {
      return Contact(phoneNumber, displayName, status, profileImage,
          hasChat == 1, saved == 1, symmetricKey);
    } else {
      return null;
    }
  }

  static const String TABLE_NAME = "contact";
  static const String COLUMN_PHONE_NUMBER = "phone_number";
  static const String COLUMN_DISPLAY_NAME = "display_name";
  static const String COLUMN_STATUS = "status";
  static const String COLUMN_PROFILE_IMAGE = "profile_image";
  static const String COLUMN_HAS_CHAT = "has_chat";
  static const String COLUMN_SAVED = "saved";
  static const String COLUMN_SYMMETRIC_KEY = "symmetric_key";

  static const String CREATE_TABLE = "create table $TABLE_NAME ("
      "$COLUMN_PHONE_NUMBER text primary key,"
      "$COLUMN_DISPLAY_NAME text not null,"
      "$COLUMN_STATUS text not null,"
      "$COLUMN_PROFILE_IMAGE blob,"
      "$COLUMN_HAS_CHAT tinyint not null,"
      "$COLUMN_SAVED tinyint not null,"
      "$COLUMN_SYMMETRIC_KEY text not null"
      ");";
}
