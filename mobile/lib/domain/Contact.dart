import 'package:mobx/mobx.dart';

part 'Contact.g.dart';

class Contact extends _Contact with _$Contact {
  Contact({
    required String phoneNumber,
    required String displayName,
    required String status,
    required String profileImage,
    DateTime? birthday,
  }) : super(
            phoneNumber: phoneNumber,
            displayName: displayName,
            status: status,
            profileImage: profileImage,
            birthday: birthday);

  Map<String, Object?> toMap() {
    return {
      COLUMN_PHONE_NUMBER: phoneNumber,
      COLUMN_DISPLAY_NAME: displayName,
      COLUMN_STATUS: status,
      COLUMN_PROFILE_IMAGE: profileImage,
      COLUMN_BIRTHDAY: birthday?.millisecondsSinceEpoch,
    };
  }

  Map toJson() => {
        'phoneNumber': phoneNumber,
        'displayName': displayName,
        'status': status,
        'profileImage': profileImage,
        'birthday': birthday?.millisecondsSinceEpoch ?? 0
      };

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

  static Contact? fromJson(Map<String, dynamic> json) {
    final phoneNumber = json["phoneNumber"] as String?;
    final displayName = json["displayName"] as String?;
    final status = json["status"] as String?;
    final profileImage = json["profileImage"] as String?;
    final birthday = json["birthday"] as int?;

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

abstract class _Contact with Store {
  final String phoneNumber;

  @observable
  String displayName;

  @observable
  String status;

  @observable
  String profileImage;

  @observable
  DateTime? birthday;

  _Contact({
    required this.phoneNumber,
    required this.displayName,
    required this.status,
    required this.profileImage,
    this.birthday,
  });
}
