class ProfanityWord {
  final String profanityWordRegex;
  final String profanityID;
  final String profanityOriginalWord;

  ProfanityWord(
      {required this.profanityWordRegex,
      required this.profanityID,
      required this.profanityOriginalWord});

  Map<String, Object?> toMap() {
    return {
      COLUMN_PROFANITY_WORD_REGEX: profanityWordRegex,
      COLUMN_PROFANITY_ID: profanityID,
      COLUMN_PROFANITY_ORIGINAL_WORD: profanityOriginalWord,
    };
  }

  static ProfanityWord? fromMap(Map<String, Object?> map) {
    final profanityWordRegex = map[COLUMN_PROFANITY_WORD_REGEX] as String?;
    final profanityID = map[COLUMN_PROFANITY_ID] as String?;
    final profanityOriginalWord =
        map[COLUMN_PROFANITY_ORIGINAL_WORD] as String?;

    if (profanityID != null &&
        profanityWordRegex != null &&
        profanityOriginalWord != null) {
      return ProfanityWord(
        profanityWordRegex: profanityWordRegex,
        profanityID: profanityID,
        profanityOriginalWord: profanityOriginalWord,
      );
    }
  }

  static const TABLE_NAME = "profanity_word";
  static const COLUMN_PROFANITY_WORD_REGEX = "profanity_word_regex";
  static const COLUMN_PROFANITY_ID = "profanity_word_id";
  static const COLUMN_PROFANITY_ORIGINAL_WORD = "profanity_original_word";
  static const CREATE_TABLE = "create table $TABLE_NAME ("
      "$COLUMN_PROFANITY_ID text primary key,"
      "$COLUMN_PROFANITY_WORD_REGEX text,"
      "$COLUMN_PROFANITY_ORIGINAL_WORD text"
      ");";
}
