class Contact {
  final String phoneNumber;
  final String displayName;
  final String status;
  final String profileImage;
  final DateTime? birthday;

  Contact({
    required this.phoneNumber,
    required this.displayName,
    required this.status,
    required this.profileImage,
    this.birthday,
  });

  Map<String, Object?> toMap() {
    return {
      COLUMN_PHONE_NUMBER: phoneNumber,
      COLUMN_DISPLAY_NAME: displayName,
      COLUMN_STATUS: status,
      COLUMN_PROFILE_IMAGE: profileImage,
      COLUMN_BIRTHDAY: birthday?.millisecondsSinceEpoch,
    };
  }

  static Contact? fromMap(Map<String, Object?> map) {
    final phoneNumber = map[COLUMN_PHONE_NUMBER] as String?;
    final displayName = map[COLUMN_DISPLAY_NAME] as String?;
    final status = map[COLUMN_STATUS] as String?;
    final profileImage = map[COLUMN_PROFILE_IMAGE] as String?;
    final birthday = map[COLUMN_BIRTHDAY] as int?;

    if (phoneNumber != null &&
        displayName != null &&
        status != null &&
        profileImage != null) {
      return Contact(
        phoneNumber: phoneNumber,
        displayName: displayName,
        status: status,
        profileImage: profileImage,
        birthday: birthday != null
            ? DateTime.fromMillisecondsSinceEpoch(birthday)
            : null,
      );
    } else {
      return null;
    }
  }

  static const String TABLE_NAME = "contact";
  static const String COLUMN_PHONE_NUMBER = "contact_phone_number";
  static const String COLUMN_DISPLAY_NAME = "contact_display_name";
  static const String COLUMN_STATUS = "contact_status";
  static const String COLUMN_PROFILE_IMAGE = "contact_profile_image";
  static const String COLUMN_BIRTHDAY = "contact_birthday";
  static const String CREATE_TABLE = "create table $TABLE_NAME ("
      "$COLUMN_PHONE_NUMBER text primary key,"
      "$COLUMN_DISPLAY_NAME text not null,"
      "$COLUMN_STATUS text not null,"
      "$COLUMN_PROFILE_IMAGE blob not null,"
      "$COLUMN_BIRTHDAY int"
      ");";
}
