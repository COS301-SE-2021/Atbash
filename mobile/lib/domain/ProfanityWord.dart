// class ProfanityWord {
// //   final String profanityWordRegex;
// //   final String profanityID;
// //   final String profanityOriginalWord;
// //   final bool addedByParent;
// //
// //   ProfanityWord(
// //       {required this.profanityWordRegex,
// //       required this.profanityID,
// //       required this.profanityOriginalWord,
// //       this.addedByParent = false,
// //       });
// //
// //   Map<String, Object?> toMap() {
// //     return {
// //       COLUMN_PROFANITY_WORD_REGEX: profanityWordRegex,
// //       COLUMN_PROFANITY_ID: profanityID,
// //       COLUMN_PROFANITY_ORIGINAL_WORD: profanityOriginalWord,
// //       COLUMN_ADDED_BY_PARENT: addedByParent ? 1 : 0,
// //     };
// //   }
// //
// //   Map toJson() => {
// //         'profanityWordRegex': profanityWordRegex,
// //         'profanityID': profanityID,
// //         'profanityOriginalWord': profanityOriginalWord,
// //         'addedByParent': addedByParent
// //       };
// //
// //   static ProfanityWord? fromMap(Map<String, Object?> map) {
// //     final profanityWordRegex = map[COLUMN_PROFANITY_WORD_REGEX] as String?;
// //     final profanityID = map[COLUMN_PROFANITY_ID] as String?;
// //     final profanityOriginalWord =
// //         map[COLUMN_PROFANITY_ORIGINAL_WORD] as String?;
// //     final addedByParent = map[COLUMN_ADDED_BY_PARENT] as int?;
// //
// //     if (profanityID != null &&
// //         profanityWordRegex != null &&
// //         profanityOriginalWord != null &&
// //         addedByParent != null) {
// //       return ProfanityWord(
// //           profanityWordRegex: profanityWordRegex,
// //           profanityID: profanityID,
// //           profanityOriginalWord: profanityOriginalWord,
// //           addedByParent: addedByParent != 0);
// //     }
// //   }
// //
// //   static const TABLE_NAME = "profanity_word";
// //   static const COLUMN_PROFANITY_WORD_REGEX = "profanity_word_regex";
// //   static const COLUMN_PROFANITY_ID = "profanity_word_id";
// //   static const COLUMN_PROFANITY_ORIGINAL_WORD = "profanity_original_word";
// //   static const COLUMN_ADDED_BY_PARENT = "added_by_parent";
// //   static const CREATE_TABLE = "create table $TABLE_NAME ("
// //       "$COLUMN_PROFANITY_ID text primary key,"
// //       "$COLUMN_PROFANITY_WORD_REGEX text,"
// //       "$COLUMN_PROFANITY_ORIGINAL_WORD text,"
// //       "$COLUMN_ADDED_BY_PARENT tinyint not null"
// //       ");";
// // }

class ProfanityWord {
  final String id;
  final String packageName;
  final String word;
  final String regex;
  final bool addedByParent;

  ProfanityWord(
      {required this.id,
      required this.packageName,
      required this.word,
      required this.regex,
      this.addedByParent = false});

  Map<String, Object?> toMap() {
    return {
      COLUMN_ID: id,
      COLUMN_PACKAGE_NAME: packageName,
      COLUMN_WORD: word,
      COLUMN_REGEX: regex,
      COLUMN_ADDED_BY_PARENT: addedByParent ? 1 : 0
    };
  }

  static ProfanityWord? fromMap(Map<String, Object?> map) {
    final id = map[COLUMN_ID] as String?;
    final packageName = map[COLUMN_PACKAGE_NAME] as String?;
    final word = map[COLUMN_WORD] as String?;
    final regex = map[COLUMN_REGEX] as String?;
    final addedByParent = map[COLUMN_ADDED_BY_PARENT] as int?;

    if (id != null &&
        packageName != null &&
        word != null &&
        regex != null &&
        addedByParent != null) {
      return ProfanityWord(
          id: id,
          packageName: packageName,
          word: word,
          regex: regex,
          addedByParent: addedByParent != 0);
    }
  }

  Map toJson() => {
        'id': id,
        'packageName': packageName,
        'word': word,
        'regex': regex,
        'addedByParent': addedByParent
      };

  static const String TABLE_NAME = "profanity_word";
  static const String COLUMN_ID = "id";
  static const String COLUMN_PACKAGE_NAME = "package_name";
  static const String COLUMN_WORD = "word";
  static const String COLUMN_REGEX = "regex";
  static const String COLUMN_ADDED_BY_PARENT = "added_by_parent";
  static const String CREATE_TABLE = "create table $TABLE_NAME ("
      "$COLUMN_ID text primary key,"
      "$COLUMN_PACKAGE_NAME text not null,"
      "$COLUMN_WORD text not null,"
      "$COLUMN_REGEX text not null,"
      "$COLUMN_ADDED_BY_PARENT tinyint not null"
      ");";
}
