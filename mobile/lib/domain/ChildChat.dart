class ChildChat {
  final String id;
  final String childId;
  final String otherPartyNumber;
  String? otherPartyName;

  ChildChat(
      {required this.id,
      required this.childId,
      required this.otherPartyNumber,
      this.otherPartyName});

  Map<String, Object?> toMap() {
    return {
      COLUMN_ID: id,
      COLUMN_CHILD_ID: childId,
      COLUMN_OTHER_PARTY_NUMBER: otherPartyNumber,
      COLUMN_OTHER_PARTY_NAME: otherPartyName,
    };
  }

  static ChildChat? fromMap(Map<String, Object?> map) {
    final id = map[COLUMN_ID] as String?;
    final childId = map[COLUMN_CHILD_ID] as String?;
    final otherPartyNumber = map[COLUMN_OTHER_PARTY_NUMBER] as String?;
    final otherPartyName = map[COLUMN_OTHER_PARTY_NAME] as String?;

    if (id != null && childId != null && otherPartyNumber != null) {
      return ChildChat(
          id: id,
          childId: childId,
          otherPartyNumber: otherPartyNumber,
          otherPartyName: otherPartyName);
    }
  }

  static const String TABLE_NAME = "child_chat";
  static const String COLUMN_ID = "id";
  static const String COLUMN_CHILD_ID = "child_id";
  static const String COLUMN_OTHER_PARTY_NUMBER = "other_party_number";
  static const String COLUMN_OTHER_PARTY_NAME = "other_party_name";
  static const String CREATE_TABLE = "create table $TABLE_NAME ("
      "$COLUMN_ID text primary key,"
      "$COLUMN_CHILD_ID text not null,"
      "$COLUMN_OTHER_PARTY_NUMBER text not null,"
      "$COLUMN_OTHER_PARTY_NAME text,"
      ");";
}
