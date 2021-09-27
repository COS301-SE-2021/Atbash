class ChildsChats {
  final String id;
  final String childPhoneNumber;
  final String otherPartyNumber;
  String? otherPartyName;

  ChildsChats({
    required this.id,
    required this.childPhoneNumber,
    required this.otherPartyNumber,
  });

  static const String TABLE_NAME = "childs_chats";
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
