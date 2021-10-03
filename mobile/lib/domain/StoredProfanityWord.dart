class StoredProfanityWord {
  final String id;
  final String packageName;
  final String word;
  final String regex;
  final bool removable;
  final bool downloaded;

  StoredProfanityWord(
      {required this.id,
      required this.packageName,
      required this.word,
      required this.regex,
      required this.removable,
      this.downloaded = true});

  Map<String, Object?> toMap() {
    return {
      COLUMN_ID: id,
      COLUMN_PACKAGE_NAME: packageName,
      COLUMN_WORD: word,
      COLUMN_REGEX: regex,
      COLUMN_REMOVABLE: removable ? 1 : 0,
      COLUMN_DOWNLOADED: downloaded ? 1 : 0
    };
  }

  static StoredProfanityWord? fromMap(Map<String, Object?> map) {
    final id = map[COLUMN_ID] as String?;
    final packageName = map[COLUMN_PACKAGE_NAME] as String?;
    final word = map[COLUMN_WORD] as String?;
    final regex = map[COLUMN_REGEX] as String?;
    final removable = map[COLUMN_REMOVABLE] as int?;
    final downloaded = map[COLUMN_DOWNLOADED] as int?;

    if (id != null &&
        packageName != null &&
        word != null &&
        regex != null &&
        removable != null &&
        downloaded != null) {
      return StoredProfanityWord(
          id: id,
          packageName: packageName,
          word: word,
          regex: regex,
          removable: removable != 0,
          downloaded: downloaded != 0);
    }
  }

  static const String TABLE_NAME = "stored_profanity_word";
  static const String COLUMN_ID = "id";
  static const String COLUMN_PACKAGE_NAME = "package_name";
  static const String COLUMN_WORD = "word";
  static const String COLUMN_REGEX = "regex";
  static const String COLUMN_REMOVABLE = "removable";
  static const String COLUMN_DOWNLOADED = "downloaded";
  static const String CREATE_TABLE = "create table $TABLE_NAME ("
      "$COLUMN_ID text primary key,"
      "$COLUMN_PACKAGE_NAME text not null,"
      "$COLUMN_WORD text not null,"
      "$COLUMN_REGEX text not null,"
      "$COLUMN_REMOVABLE tinyint not null,"
      "$COLUMN_DOWNLOADED tinyint not null"
      ");";
}
