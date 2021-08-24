class Tag {
  final String id;
  String name;

  Tag({
    required this.id,
    required this.name,
  });

  static const String TABLE_NAME = "tag";
  static const String COLUMN_ID = "tag_id";
  static const String COLUMN_NAME = "tag_name";
  static const String CREATE_TABLE = "create table $TABLE_NAME ("
      "$COLUMN_ID text primary key,"
      "$COLUMN_NAME text not null"
      ");";
}
