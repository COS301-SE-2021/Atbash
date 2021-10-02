// class ChildProfanityWord {
//   final String phoneNumber;
//   final String profanityWordRegex;
//   final String profanityID;
//   final String profanityOriginalWord;
//
//   ChildProfanityWord(
//       {required this.phoneNumber,
//       required this.profanityWordRegex,
//       required this.profanityID,
//       required this.profanityOriginalWord});
//
//   Map<String, Object?> toMap() {
//     return {
//       COLUMN_PHONE_NUMBER: phoneNumber,
//       COLUMN_PROFANITY_WORD_REGEX: profanityWordRegex,
//       COLUMN_PROFANITY_ID: profanityID,
//       COLUMN_PROFANITY_ORIGINAL_WORD: profanityOriginalWord,
//     };
//   }
//
//   static ChildProfanityWord? fromMap(Map<String, Object?> map) {
//     final phoneNumber = map[COLUMN_PHONE_NUMBER] as String?;
//     final profanityWordRegex = map[COLUMN_PROFANITY_WORD_REGEX] as String?;
//     final profanityID = map[COLUMN_PROFANITY_ID] as String?;
//     final profanityOriginalWord =
//         map[COLUMN_PROFANITY_ORIGINAL_WORD] as String?;
//
//     if (profanityID != null &&
//         phoneNumber != null &&
//         profanityWordRegex != null &&
//         profanityOriginalWord != null) {
//       return ChildProfanityWord(
//         phoneNumber: phoneNumber,
//         profanityWordRegex: profanityWordRegex,
//         profanityID: profanityID,
//         profanityOriginalWord: profanityOriginalWord,
//       );
//     }
//   }
//
//   static const TABLE_NAME = "child_profanity_word";
//   static const COLUMN_PHONE_NUMBER = "phone_number";
//   static const COLUMN_PROFANITY_WORD_REGEX = "profanity_word_regex";
//   static const COLUMN_PROFANITY_ID = "profanity_word_id";
//   static const COLUMN_PROFANITY_ORIGINAL_WORD = "profanity_original_word";
//   static const CREATE_TABLE = "create table $TABLE_NAME ("
//       "$COLUMN_PROFANITY_ID text,"
//       "$COLUMN_PHONE_NUMBER text,"
//       "$COLUMN_PROFANITY_WORD_REGEX text,"
//       "$COLUMN_PROFANITY_ORIGINAL_WORD text,"
//       "PRIMARY KEY($COLUMN_PHONE_NUMBER,$COLUMN_PROFANITY_ID)"
//       ");";
// }

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
