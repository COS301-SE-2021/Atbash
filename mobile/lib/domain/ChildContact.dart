class ChildContact {
  final String phoneNumber;
  String name;
  String status;
  String profileImage;

  ChildContact(
      {required this.phoneNumber,
      required this.name,
      required this.status,
      required this.profileImage});

  Map<String, Object?> toMap() {
    return {
      COLUMN_PHONE_NUMBER: phoneNumber,
      COLUMN_NAME: name,
      COLUMN_STATUS: status,
      COLUMN_PROFILE_IMAGE: profileImage,
    };
  }

  static ChildContact? fromMap(Map<String, Object?> map) {
    final phoneNumber = map[COLUMN_PHONE_NUMBER] as String?;
    final name = map[COLUMN_NAME] as String?;
    final status = map[COLUMN_STATUS] as String?;
    final profileImage = map[COLUMN_PROFILE_IMAGE] as String?;

    if (phoneNumber != null &&
        name != null &&
        status != null &&
        profileImage != null) {
      return ChildContact(
          phoneNumber: phoneNumber,
          name: name,
          status: status,
          profileImage: profileImage);
    }
  }

  static const String TABLE_NAME = "child_contact";
  static const String COLUMN_PHONE_NUMBER = "phone_number";
  static const String COLUMN_NAME = "name";
  static const String COLUMN_STATUS = "status";
  static const String COLUMN_PROFILE_IMAGE = "profile_image";

  static const String CREATE_TABLE = "create table $TABLE_NAME ("
      "$COLUMN_PHONE_NUMBER text primary key,"
      "$COLUMN_NAME text not null,"
      "$COLUMN_STATUS text not null,"
      "$COLUMN_PROFILE_IMAGE text not null"
      ");";
}
