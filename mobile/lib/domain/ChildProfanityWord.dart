class ChildProfanityWord {
  final String phoneNumber;
  final String profanityWordRegex;
  final String profanityID;
  final String profanityOriginalWord;

  ChildProfanityWord(
      {required this.phoneNumber,
      required this.profanityWordRegex,
      required this.profanityID,
      required this.profanityOriginalWord});

  Map<String, Object?> toMap() {
    return {
      COLUMN_PHONE_NUMBER: phoneNumber,
      COLUMN_PROFANITY_WORD_REGEX: profanityWordRegex,
      COLUMN_PROFANITY_ID: profanityID,
      COLUMN_PROFANITY_ORIGINAL_WORD: profanityOriginalWord,
    };
  }

  static ChildProfanityWord? fromMap(Map<String, Object?> map) {
    final phoneNumber = map[COLUMN_PHONE_NUMBER] as String?;
    final profanityWordRegex = map[COLUMN_PROFANITY_WORD_REGEX] as String?;
    final profanityID = map[COLUMN_PROFANITY_ID] as String?;
    final profanityOriginalWord =
        map[COLUMN_PROFANITY_ORIGINAL_WORD] as String?;

    if (profanityID != null &&
        phoneNumber != null &&
        profanityWordRegex != null &&
        profanityOriginalWord != null) {
      return ChildProfanityWord(
        phoneNumber: phoneNumber,
        profanityWordRegex: profanityWordRegex,
        profanityID: profanityID,
        profanityOriginalWord: profanityOriginalWord,
      );
    }
  }

  static const TABLE_NAME = "child_profanity_word";
  static const COLUMN_PHONE_NUMBER = "phone_number";
  static const COLUMN_PROFANITY_WORD_REGEX = "profanity_word_regex";
  static const COLUMN_PROFANITY_ID = "profanity_word_id";
  static const COLUMN_PROFANITY_ORIGINAL_WORD = "profanity_original_word";
  static const CREATE_TABLE = "create table $TABLE_NAME ("
      "$COLUMN_PROFANITY_ID text,"
      "$COLUMN_PHONE_NUMBER text,"
      "$COLUMN_PROFANITY_WORD_REGEX text,"
      "$COLUMN_PROFANITY_ORIGINAL_WORD text,"
      "PRIMARY KEY($COLUMN_PHONE_NUMBER,$COLUMN_PROFANITY_ID)"
      ");";
}
