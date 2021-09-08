class BlockedNumber {
  final String phoneNumber;

  BlockedNumber({required this.phoneNumber});

  Map<String, Object?> toMap() {
    return {
      COLUMN_PHONE_NUMBER: phoneNumber,
    };
  }

  BlockedNumber? fromMap(Map<String, Object?> map) {
    final phoneNumber = map[COLUMN_PHONE_NUMBER] as String?;

    if (phoneNumber != null) {
      return BlockedNumber(phoneNumber: phoneNumber);
    }
  }

  static const TABLE_NAME = "blocked_number";
  static const COLUMN_PHONE_NUMBER = "blocked_number_phone_number";
  static const CREATE_TABLE = "create table $TABLE_NAME ("
      "$COLUMN_PHONE_NUMBER text primary key"
      ");";
}
