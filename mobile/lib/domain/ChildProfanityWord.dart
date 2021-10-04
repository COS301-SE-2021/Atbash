class ChildProfanityWord {
  final String phoneNumber;
  final String id;
  final String packageName;
  final String word;
  final String regex;

  ChildProfanityWord(
      {required this.phoneNumber,
      required this.id,
      required this.packageName,
      required this.word,
      required this.regex});

  Map<String, Object?> toMap() {
    return {
      COLUMN_PHONE_NUMBER: phoneNumber,
      COLUMN_ID: id,
      COLUMN_PACKAGE_NAME: packageName,
      COLUMN_WORD: word,
      COLUMN_REGEX: regex
    };
  }

  static ChildProfanityWord? fromMap(Map<String, Object?> map) {
    final phoneNumber = map[COLUMN_PHONE_NUMBER] as String?;
    final id = map[COLUMN_ID] as String?;
    final packageName = map[COLUMN_PACKAGE_NAME] as String?;
    final word = map[COLUMN_WORD] as String?;
    final regex = map[COLUMN_REGEX] as String?;

    if (phoneNumber != null &&
        id != null &&
        packageName != null &&
        word != null &&
        regex != null) {
      return ChildProfanityWord(
          phoneNumber: phoneNumber,
          id: id,
          packageName: packageName,
          word: word,
          regex: regex);
    }
  }

  Map toJson() => {
        'phoneNumber': phoneNumber,
        'id': id,
        'packageName': packageName,
        'word': word,
        'regex': regex
      };

  static const String TABLE_NAME = "child_profanity_word";
  static const String COLUMN_PHONE_NUMBER = "phone_number";
  static const String COLUMN_ID = "id";
  static const String COLUMN_PACKAGE_NAME = "package_name";
  static const String COLUMN_WORD = "word";
  static const String COLUMN_REGEX = "regex";
  static const String CREATE_TABLE = "create table $TABLE_NAME ("
      "$COLUMN_PHONE_NUMBER text not null,"
      "$COLUMN_ID text not null,"
      "$COLUMN_PACKAGE_NAME text not null,"
      "$COLUMN_WORD text not null,"
      "$COLUMN_REGEX text not null,"
      "primary key($COLUMN_PHONE_NUMBER,$COLUMN_ID)"
      ");";
}
