class ChildChat {
  final String childPhoneNumber;
  final String otherPartyNumber;

  ChildChat({required this.childPhoneNumber, required this.otherPartyNumber});

  Map<String, Object?> toMap() {
    return {
      COLUMN_CHILD_PHONE_NUMBER: childPhoneNumber,
      COLUMN_OTHER_PARTY_NUMBER: otherPartyNumber,
    };
  }

  static ChildChat? fromMap(Map<String, Object?> map) {
    final childPhoneNumber = map[COLUMN_CHILD_PHONE_NUMBER] as String?;
    final otherPartyNumber = map[COLUMN_OTHER_PARTY_NUMBER] as String?;

    if (childPhoneNumber != null && otherPartyNumber != null) {
      return ChildChat(
          childPhoneNumber: childPhoneNumber,
          otherPartyNumber: otherPartyNumber);
    }
  }

  static const String TABLE_NAME = "child_chat";
  static const String COLUMN_CHILD_PHONE_NUMBER = "child_phone_number";
  static const String COLUMN_OTHER_PARTY_NUMBER = "other_party_number";
  static const String CREATE_TABLE = "create table $TABLE_NAME ("
      "$COLUMN_CHILD_PHONE_NUMBER text not null,"
      "$COLUMN_OTHER_PARTY_NUMBER text not null,"
      "primary key($COLUMN_CHILD_PHONE_NUMBER, $COLUMN_OTHER_PARTY_NUMBER)"
      ");";
}
