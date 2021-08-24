class Contact {
  final String phoneNumber;
  final String displayName;
  final String status;
  final String profileImage;
  final DateTime? birthday;

  Contact(
      {required this.phoneNumber,
      required this.displayName,
      required this.status,
      required this.profileImage,
      this.birthday});

  static const String TABLE_NAME = "contact";
  static const String COLUMN_PHONE_NUMBER = "contact_phone_number";
  static const String COLUMN_DISPLAY_NAME = "contact_display_name";
  static const String COLUMN_STATUS = "contact_status";
  static const String COLUMN_PROFILE_IMAGE = "contact_profile_image";
  static const String COLUMN_BIRTHDAY = "contact_birthday";
  static const String CREATE_TABLE = "create table $TABLE_NAME ("
      "$COLUMN_PHONE_NUMBER text primary key,"
      "$COLUMN_DISPLAY_NAME text,"
      "$COLUMN_STATUS text,"
      "$COLUMN_PROFILE_IMAGE text,"
      "$COLUMN_BIRTHDAY int"
      ");";
}
