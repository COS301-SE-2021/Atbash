class ChildChat {
  final String id;
  final String childPhoneNumber;
  final String otherPartyNumber;
  String? otherPartyName;

  ChildChat(
      {required this.id,
      required this.childPhoneNumber,
      required this.otherPartyNumber,
      this.otherPartyName});

  Map<String, Object?> toMap() {
    return {
      COLUMN_ID: id,
      COLUMN_CHILD_PHONE_NUMBER: childPhoneNumber,
      COLUMN_OTHER_PARTY_NUMBER: otherPartyNumber,
      COLUMN_OTHER_PARTY_NAME: otherPartyName,
    };
  }

  static ChildChat? fromMap(Map<String, Object?> map) {
    final id = map[COLUMN_ID] as String?;
    final childPhoneNumber = map[COLUMN_CHILD_PHONE_NUMBER] as String?;
    final otherPartyNumber = map[COLUMN_OTHER_PARTY_NUMBER] as String?;
    final otherPartyName = map[COLUMN_OTHER_PARTY_NAME] as String?;

    if (id != null && childPhoneNumber != null && otherPartyNumber != null) {
      return ChildChat(
          id: id,
          childPhoneNumber: childPhoneNumber,
          otherPartyNumber: otherPartyNumber,
          otherPartyName: otherPartyName);
    }
  }

  static const String TABLE_NAME = "child_chat";
  static const String COLUMN_ID = "id";
  static const String COLUMN_CHILD_PHONE_NUMBER = "child_phone_number";
  static const String COLUMN_OTHER_PARTY_NUMBER = "other_party_number";
  static const String COLUMN_OTHER_PARTY_NAME = "other_party_name";
  static const String CREATE_TABLE = "create table $TABLE_NAME ("
      "$COLUMN_ID text primary key,"
      "$COLUMN_CHILD_PHONE_NUMBER text not null,"
      "$COLUMN_OTHER_PARTY_NUMBER text not null,"
      "$COLUMN_OTHER_PARTY_NAME text,"
      ");";
}
