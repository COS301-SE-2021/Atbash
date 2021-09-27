class Child {
  final String id;
  final String phoneNumber;
  final String name;
  final String pin;
  bool editableSettings = false;
  bool blurImages = false;
  bool safeMode = false;
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
    required this.safeMode,
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

  Map<String, Object?> toMap() {
    return {
      COLUMN_ID: id,
      COLUMN_PHONE_NUMBER: phoneNumber,
      COLUMN_NAME: name,
      COLUMN_PIN: pin,
      COLUMN_EDITABLE_SETTINGS: editableSettings,
      COLUMN_BLUR_IMAGES: blurImages,
      COLUMN_SAFE_MODE: safeMode,
      COLUMN_SHARE_PROFILE_PICTURE: shareProfilePicture,
      COLUMN_SHARE_STATUS: shareStatus,
      COLUMN_SHARE_READ_RECEIPTS: shareReadReceipts,
      COLUMN_SHARE_BIRTHDAY: shareBirthday,
      COLUMN_LOCKED_ACCOUNT: lockedAccount,
      COLUMN_PRIVATE_CHAT_ACCESS: privateChatAccess,
      COLUMN_BLOCK_SAVE_MEDIA: blockSaveMedia,
      COLUMN_BLOCK_EDITING_MESSAGES: blockEditingMessages,
      COLUMN_BLOCK_DELETING_MESSAGES: blockDeletingMessages,
    };
  }

  static Child? fromMap(Map<String, Object?> map) {
    final id = map[COLUMN_ID] as String?;
    final phoneNumber = map[COLUMN_PHONE_NUMBER] as String?;
    final name = map[COLUMN_NAME] as String?;
    final pin = map[COLUMN_PIN] as String?;
    final editableSettings = map[COLUMN_EDITABLE_SETTINGS] as bool?;
    final blurImages = map[COLUMN_BLUR_IMAGES] as bool?;
    final safeMode = map[COLUMN_SAFE_MODE] as bool?;
    final shareProfilePicture = map[COLUMN_SHARE_PROFILE_PICTURE] as bool?;
    final shareStatus = map[COLUMN_SHARE_STATUS] as bool?;
    final shareReadReceipts = map[COLUMN_SHARE_READ_RECEIPTS] as bool?;
    final shareBirthday = map[COLUMN_SHARE_BIRTHDAY] as bool?;
    final lockedAccount = map[COLUMN_LOCKED_ACCOUNT] as bool?;
    final privateChatAccess = map[COLUMN_PRIVATE_CHAT_ACCESS] as bool?;
    final blockSaveMedia = map[COLUMN_BLOCK_SAVE_MEDIA] as bool?;
    final blockEditingMessages = map[COLUMN_BLOCK_EDITING_MESSAGES] as bool?;
    final blockDeletingMessages = map[COLUMN_BLOCK_DELETING_MESSAGES] as bool?;

    if (id != null &&
        phoneNumber != null &&
        name != null &&
        pin != null &&
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
          id: id,
          phoneNumber: phoneNumber,
          name: name,
          pin: pin,
          editableSettings: editableSettings,
          blurImages: blurImages,
          safeMode: safeMode,
          shareProfilePicture: shareProfilePicture,
          shareStatus: shareStatus,
          shareReadReceipts: shareReadReceipts,
          shareBirthday: shareBirthday,
          lockedAccount: lockedAccount,
          privateChatAccess: privateChatAccess,
          blockSaveMedia: blockSaveMedia,
          blockEditingMessages: blockEditingMessages,
          blockDeletingMessages: blockDeletingMessages);
    }
  }

  static const String TABLE_NAME = "child";
  static const String COLUMN_ID = "id";
  static const String COLUMN_PHONE_NUMBER = "phone_number";
  static const String COLUMN_NAME = "name";
  static const String COLUMN_PIN = "pin";
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
      "$COLUMN_ID text primary key,"
      "$COLUMN_PHONE_NUMBER text not null,"
      "$COLUMN_NAME text not null,"
      "$COLUMN_PIN text not null,"
      "$COLUMN_EDITABLE_SETTINGS tinyint not null,"
      "$COLUMN_BLUR_IMAGES tinyint not null,"
      "$COLUMN_SAFE_MODE tinyint not null,"
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
