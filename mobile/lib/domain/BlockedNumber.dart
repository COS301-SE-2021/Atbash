class BlockedNumber {
  final String phoneNumber;
  final bool addedByParent;

  BlockedNumber({required this.phoneNumber, this.addedByParent = false});

  Map<String, Object?> toMap() {
    return {
      COLUMN_PHONE_NUMBER: phoneNumber,
      COLUMN_ADDED_BY_PARENT: addedByParent ? 1 : 0,
    };
  }

  static BlockedNumber? fromMap(Map<String, Object?> map) {
    final phoneNumber = map[COLUMN_PHONE_NUMBER] as String?;
    final addedByParent = map[COLUMN_ADDED_BY_PARENT] as int?;

    if (phoneNumber != null && addedByParent != null) {
      return BlockedNumber(
          phoneNumber: phoneNumber, addedByParent: addedByParent != 0);
    }
  }

  Map toJson() => {'phoneNumber': phoneNumber, 'addedByParent': addedByParent};

  static const TABLE_NAME = "blocked_number";
  static const COLUMN_PHONE_NUMBER = "blocked_number_phone_number";
  static const COLUMN_ADDED_BY_PARENT = "added_by_parent";
  static const CREATE_TABLE = "create table $TABLE_NAME ("
      "$COLUMN_PHONE_NUMBER text primary key,"
      "$COLUMN_ADDED_BY_PARENT tinyint not null"
      ");";
}
