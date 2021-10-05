class Parent {
  final String phoneNumber;
  String name;
  String code;
  bool enabled;

  Parent(
      {required this.phoneNumber,
      required this.name,
      required this.code,
      this.enabled = false});

  Map<String, Object?> toMap() {
    return {
      COLUMN_PHONE_NUMBER: phoneNumber,
      COLUMN_NAME: name,
      COLUMN_CODE: code,
      COLUMN_ENABLED: enabled ? 1 : 0,
    };
  }

  static Parent? fromMap(Map<String, Object?> map) {
    final phoneNumber = map[COLUMN_PHONE_NUMBER] as String?;
    final name = map[COLUMN_NAME] as String?;
    final code = map[COLUMN_CODE] as String?;
    final enabled = map[COLUMN_ENABLED] as int?;

    if (phoneNumber != null &&
        name != null &&
        code != null &&
        enabled != null) {
      return Parent(
          phoneNumber: phoneNumber,
          name: name,
          code: code,
          enabled: enabled != 0);
    }
  }

  static const String TABLE_NAME = "parent";
  static const String COLUMN_PHONE_NUMBER = "phone_number";
  static const String COLUMN_NAME = "name";
  static const String COLUMN_CODE = "code";
  static const String COLUMN_ENABLED = "enabled";

  static const String CREATE_TABLE = "create table $TABLE_NAME ("
      "$COLUMN_PHONE_NUMBER text primary key,"
      "$COLUMN_NAME text not null,"
      "$COLUMN_CODE text unique not null,"
      "$COLUMN_ENABLED tinyint not null"
      ");";
}
