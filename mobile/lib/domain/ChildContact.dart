class ChildContact {
  final String childPhoneNumber;
  final String contactPhoneNumber;
  String name;
  String status;
  String profileImage;

  ChildContact(
      {required this.childPhoneNumber,
      required this.contactPhoneNumber,
      required this.name,
      required this.status,
      required this.profileImage});

  Map<String, Object?> toMap() {
    return {
      COLUMN_CHILD_PHONE_NUMBER: childPhoneNumber,
      COLUMN_CONTACT_PHONE_NUMBER: contactPhoneNumber,
      COLUMN_NAME: name,
      COLUMN_STATUS: status,
      COLUMN_PROFILE_IMAGE: profileImage,
    };
  }

  static ChildContact? fromMap(Map<String, Object?> map) {
    final childPhoneNumber = map[COLUMN_CHILD_PHONE_NUMBER] as String?;
    final contactPhoneNumber = map[COLUMN_CONTACT_PHONE_NUMBER] as String?;
    final name = map[COLUMN_NAME] as String?;
    final status = map[COLUMN_STATUS] as String?;
    final profileImage = map[COLUMN_PROFILE_IMAGE] as String?;

    if (childPhoneNumber != null &&
        contactPhoneNumber != null &&
        name != null &&
        status != null &&
        profileImage != null) {
      return ChildContact(
          childPhoneNumber: childPhoneNumber,
          contactPhoneNumber: contactPhoneNumber,
          name: name,
          status: status,
          profileImage: profileImage);
    }
  }

  static const String TABLE_NAME = "child_contact";
  static const String COLUMN_CHILD_PHONE_NUMBER = "child_phone_number";
  static const String COLUMN_CONTACT_PHONE_NUMBER = "contact_phone_number";
  static const String COLUMN_NAME = "name";
  static const String COLUMN_STATUS = "status";
  static const String COLUMN_PROFILE_IMAGE = "profile_image";

  static const String CREATE_TABLE = "create table $TABLE_NAME ("
      "$COLUMN_CHILD_PHONE_NUMBER text not null,"
      "$COLUMN_CONTACT_PHONE_NUMBER text not null,"
      "$COLUMN_NAME text not null,"
      "$COLUMN_STATUS text not null,"
      "$COLUMN_PROFILE_IMAGE text not null,"
      "primary key($COLUMN_CHILD_PHONE_NUMBER, $COLUMN_CONTACT_PHONE_NUMBER)"
      ");";
}
