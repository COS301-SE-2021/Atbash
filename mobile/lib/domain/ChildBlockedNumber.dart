class ChildBlockedNumber {
  final String id;
  final String childNumber;
  final String blockedNumber;

  ChildBlockedNumber(
      {required this.id,
      required this.childNumber,
      required this.blockedNumber});

  Map<String, Object?> toMap() {
    return {
      COLUMN_ID: id,
      COLUMN_CHILD_NUMBER: childNumber,
      COLUMN_BLOCKED_NUMBER: blockedNumber,
    };
  }

  static ChildBlockedNumber? fromMap(Map<String?, Object?> map) {
    final id = map[COLUMN_ID] as String?;
    final childNumber = map[COLUMN_CHILD_NUMBER] as String?;
    final blockedNumber = map[COLUMN_BLOCKED_NUMBER] as String?;

    if (id != null && childNumber != null && blockedNumber != null) {
      return ChildBlockedNumber(
          id: id, childNumber: childNumber, blockedNumber: blockedNumber);
    }
  }

  static const TABLE_NAME = "child_blocked_number";
  static const COLUMN_ID = "id";
  static const COLUMN_CHILD_NUMBER = "child_number";
  static const COLUMN_BLOCKED_NUMBER = "blocked_number";
  static const CREATE_TABLE = "create table $TABLE_NAME ("
      "$COLUMN_ID text primary key,"
      "$COLUMN_CHILD_NUMBER text not null,"
      "$COLUMN_BLOCKED_NUMBER text not null"
      ");";
}
