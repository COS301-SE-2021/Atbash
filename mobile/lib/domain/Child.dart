class Child {
  final String id;
  final String phoneNumber;
  final String name;
  final String pin;
  bool editableSettings = false;
  bool blurImages = false;
  bool shareProfilePicture = false;
  bool shareStatus = false;
  bool shareReadReceipts = false;
  bool shareBirthday = false;
  bool lockedAccount = false;
  bool privateChatAccess = false;
  bool blockSaveMedia = false;
  bool blockEditingMessages = false;
  bool blockDeletingMessages = false;

  Child({
    required this.id,
    required this.phoneNumber,
    required this.name,
    required this.pin,
    required this.editableSettings,
    required this.blurImages,
    required this.shareProfilePicture,
    required this.shareStatus,
    required this.shareReadReceipts,
    required this.shareBirthday,
    required this.lockedAccount,
    required this.privateChatAccess,
    required this.blockSaveMedia,
    required this.blockEditingMessages,
    required this.blockDeletingMessages,
  });

  static const String TABLE_NAME = "child";
  static const String COLUMN_ID = "id";
  static const String COLUMN_PHONE_NUMBER = "phone_number";
  static const String COLUMN_NAME = "name";
  static const String COLUMN_PIN = "pin";
  static const String COLUMN_EDITABLE_SETTINGS = "editable_settings";
  static const String COLUMN_BLUR_IMAGES = "blur_images";
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
      "$COLUMN_ID text primary key,"
      "$COLUMN_PHONE_NUMBER text not null,"
      "$COLUMN_NAME text not null,"
      "$COLUMN_PIN text not null,"
      "$COLUMN_EDITABLE_SETTINGS tinyint not null,"
      "$COLUMN_BLUR_IMAGES tinyint not null,"
      "$COLUMN_SHARE_PROFILE_PICTURE tinyint not null,"
      "$COLUMN_SHARE_STATUS tinyint not null,"
      "$COLUMN_SHARE_READ_RECEIPTS tinyint not null,"
      "$COLUMN_SHARE_BIRTHDAY tinyint not null,"
      "$COLUMN_LOCKED_ACCOUNT tinyint not null,"
      "$COLUMN_PRIVATE_CHAT_ACCESS tinyint not null,"
      "$COLUMN_PRIVATE_CHAT_ACCESS tinyint not null,"
      "$COLUMN_BLOCK_SAVE_MEDIA tinyint not null,"
      "$COLUMN_BLOCK_EDITING_MESSAGES tinyint not null,"
      "$COLUMN_BLOCK_DELETING_MESSAGES tinyint not null"
      ");";
}
