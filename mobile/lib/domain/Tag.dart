import 'package:mobx/mobx.dart';

part 'Tag.g.dart';

class Tag extends _Tag with _$Tag {
  Tag({
    required String id,
    required String name,
  }) : super(id: id, name: name);

  Map<String, Object> toMap() {
    return {
      COLUMN_ID: id,
      COLUMN_NAME: name,
    };
  }

  static Tag? fromMap(Map<String, Object?> map) {
    final id = map[COLUMN_ID] as String?;
    final name = map[COLUMN_NAME] as String?;

    if (id != null && name != null) {
      return Tag(id: id, name: name);
    } else {
      return null;
    }
  }

  static const String TABLE_NAME = "tag";
  static const String COLUMN_ID = "tag_id";
  static const String COLUMN_NAME = "tag_name";
  static const String CREATE_TABLE = "create table $TABLE_NAME ("
      "$COLUMN_ID text primary key,"
      "$COLUMN_NAME text not null"
      ");";
}

abstract class _Tag with Store {
  final String id;

  @observable
  String name;

  _Tag({
    required this.id,
    required this.name,
  });
}
