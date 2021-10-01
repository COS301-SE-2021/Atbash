class Child {
  final String phoneNumber;
  String name;
  bool editableSettings;
  bool blurImages;
  bool safeMode;
  bool shareProfilePicture;
  bool shareStatus;
  bool shareReadReceipts;
  bool shareBirthday;
  bool lockedAccount;
  bool privateChatAccess;
  bool blockSaveMedia;
  bool blockEditingMessages;
  bool blockDeletingMessages;

  Child({
    required this.phoneNumber,
    required this.name,
    this.editableSettings = true,
    this.blurImages = false,
    this.safeMode = false,
    this.shareProfilePicture = false,
    this.shareStatus = false,
    this.shareReadReceipts = false,
    this.shareBirthday = false,
    this.lockedAccount = false,
    this.privateChatAccess = false,
    this.blockSaveMedia = false,
    this.blockEditingMessages = false,
    this.blockDeletingMessages = false,
  });

  Map<String, Object?> toMap() {
    return {
      COLUMN_PHONE_NUMBER: phoneNumber,
      COLUMN_NAME: name,
      COLUMN_EDITABLE_SETTINGS: editableSettings ? 1 : 0,
      COLUMN_BLUR_IMAGES: blurImages ? 1 : 0,
      COLUMN_SAFE_MODE: safeMode ? 1 : 0,
      COLUMN_SHARE_PROFILE_PICTURE: shareProfilePicture ? 1 : 0,
      COLUMN_SHARE_STATUS: shareStatus ? 1 : 0,
      COLUMN_SHARE_READ_RECEIPTS: shareReadReceipts ? 1 : 0,
      COLUMN_SHARE_BIRTHDAY: shareBirthday ? 1 : 0,
      COLUMN_LOCKED_ACCOUNT: lockedAccount ? 1 : 0,
      COLUMN_PRIVATE_CHAT_ACCESS: privateChatAccess ? 1 : 0,
      COLUMN_BLOCK_SAVE_MEDIA: blockSaveMedia ? 1 : 0,
      COLUMN_BLOCK_EDITING_MESSAGES: blockEditingMessages ? 1 : 0,
      COLUMN_BLOCK_DELETING_MESSAGES: blockDeletingMessages ? 1 : 0,
    };
  }

  static Child? fromMap(Map<String, Object?> map) {
    final phoneNumber = map[COLUMN_PHONE_NUMBER] as String?;
    final name = map[COLUMN_NAME] as String?;
    final editableSettings = map[COLUMN_EDITABLE_SETTINGS] as int?;
    final blurImages = map[COLUMN_BLUR_IMAGES] as int?;
    final safeMode = map[COLUMN_SAFE_MODE] as int?;
    final shareProfilePicture = map[COLUMN_SHARE_PROFILE_PICTURE] as int?;
    final shareStatus = map[COLUMN_SHARE_STATUS] as int?;
    final shareReadReceipts = map[COLUMN_SHARE_READ_RECEIPTS] as int?;
    final shareBirthday = map[COLUMN_SHARE_BIRTHDAY] as int?;
    final lockedAccount = map[COLUMN_LOCKED_ACCOUNT] as int?;
    final privateChatAccess = map[COLUMN_PRIVATE_CHAT_ACCESS] as int?;
    final blockSaveMedia = map[COLUMN_BLOCK_SAVE_MEDIA] as int?;
    final blockEditingMessages = map[COLUMN_BLOCK_EDITING_MESSAGES] as int?;
    final blockDeletingMessages = map[COLUMN_BLOCK_DELETING_MESSAGES] as int?;

    if (phoneNumber != null &&
        name != null &&
        editableSettings != null &&
        blurImages != null &&
        safeMode != null &&
        shareProfilePicture != null &&
        shareStatus != null &&
        shareReadReceipts != null &&
        shareBirthday != null &&
        lockedAccount != null &&
        privateChatAccess != null &&
        blockSaveMedia != null &&
        blockEditingMessages != null &&
        blockDeletingMessages != null) {
      return Child(
          phoneNumber: phoneNumber,
          name: name,
          editableSettings: editableSettings != 0,
          blurImages: blurImages != 0,
          safeMode: safeMode != 0,
          shareProfilePicture: shareProfilePicture != 0,
          shareStatus: shareStatus != 0,
          shareReadReceipts: shareReadReceipts != 0,
          shareBirthday: shareBirthday != 0,
          lockedAccount: lockedAccount != 0,
          privateChatAccess: privateChatAccess != 0,
          blockSaveMedia: blockSaveMedia != 0,
          blockEditingMessages: blockEditingMessages != 0,
          blockDeletingMessages: blockDeletingMessages != 0);
    }
  }

  static const String TABLE_NAME = "child";
  static const String COLUMN_PHONE_NUMBER = "phone_number";
  static const String COLUMN_NAME = "name";
  static const String COLUMN_EDITABLE_SETTINGS = "editable_settings";
  static const String COLUMN_BLUR_IMAGES = "blur_images";
  static const String COLUMN_SAFE_MODE = "safe_mode";
  static const String COLUMN_SHARE_PROFILE_PICTURE = "share_profile_picture";
  static const String COLUMN_SHARE_STATUS = "share_status";
  static const String COLUMN_SHARE_READ_RECEIPTS = "share_read_receipts";
  static const String COLUMN_SHARE_BIRTHDAY = "share_birthday";
  static const String COLUMN_LOCKED_ACCOUNT = "locked_account";
  static const String COLUMN_PRIVATE_CHAT_ACCESS = "private_chat_access";
  static const String COLUMN_BLOCK_SAVE_MEDIA = "block_save_media";
  static const String COLUMN_BLOCK_EDITING_MESSAGES = "block_editing_messages";
  static const String COLUMN_BLOCK_DELETING_MESSAGES =
      "block_deleting_messages";
  static const String CREATE_TABLE = "create table $TABLE_NAME ("
      "$COLUMN_PHONE_NUMBER text primary key,"
      "$COLUMN_NAME text not null,"
      "$COLUMN_EDITABLE_SETTINGS tinyint not null,"
      "$COLUMN_BLUR_IMAGES tinyint not null,"
      "$COLUMN_SAFE_MODE tinyint not null,"
      "$COLUMN_SHARE_PROFILE_PICTURE tinyint not null,"
      "$COLUMN_SHARE_STATUS tinyint not null,"
      "$COLUMN_SHARE_READ_RECEIPTS tinyint not null,"
      "$COLUMN_SHARE_BIRTHDAY tinyint not null,"
      "$COLUMN_LOCKED_ACCOUNT tinyint not null,"
      "$COLUMN_PRIVATE_CHAT_ACCESS tinyint not null,"
      "$COLUMN_BLOCK_SAVE_MEDIA tinyint not null,"
      "$COLUMN_BLOCK_EDITING_MESSAGES tinyint not null,"
      "$COLUMN_BLOCK_DELETING_MESSAGES tinyint not null"
      ");";
}
