class ProfanityWord {
  final String profanityWordRegex;
  final String profanityID;

  ProfanityWord({
    required this.profanityWordRegex,
    required this.profanityID
  });

  Map<String, Object?> toMap() {
    return {
      COLUMN_PROFANITY_WORD_REGEX: profanityWordRegex,
      COLUMN_PROFANITY_ID: profanityID,
    };
  }

  static ProfanityWord? fromMap(Map<String, Object?> map){
    final profanityWordRegex = map[COLUMN_PROFANITY_WORD_REGEX] as String?;
    final profanityID = map[COLUMN_PROFANITY_ID] as String?;

    if(profanityID !=null && profanityWordRegex !=null){
      return ProfanityWord(profanityWordRegex: profanityWordRegex, profanityID: profanityID);
    }
  }

  static const TABLE_NAME = "profanity_word";
  static const COLUMN_PROFANITY_WORD_REGEX = "profanity_word_regex";
  static const COLUMN_PROFANITY_ID = "profanity_word_id";
  static const CREATE_TABLE = "create table $TABLE_NAME ("
      "$COLUMN_PROFANITY_ID text primary key,"
      "$COLUMN_PROFANITY_WORD_REGEX text"
      ");";
}
