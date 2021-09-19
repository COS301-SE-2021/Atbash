import 'dart:convert';
import 'dart:typed_data';

class SignedPreKeyDBRecord {
  final int signedPreKeyId;
  final Uint8List serializedKey;

  SignedPreKeyDBRecord(
    this.signedPreKeyId,
    this.serializedKey,
  );

  Map<String, dynamic> toMap() {
    return {
      COLUMN_KEY_ID: this.signedPreKeyId,
      COLUMN_SERIALIZED_KEY: base64.encode(this.serializedKey)
    };
  }

  static SignedPreKeyDBRecord? fromMap(Map<String, Object?> map) {
    final keyID = map[SignedPreKeyDBRecord.COLUMN_KEY_ID];
    final keyEncoded = map[SignedPreKeyDBRecord.COLUMN_SERIALIZED_KEY];

    if (keyID is int && keyEncoded is String) {
      return SignedPreKeyDBRecord(
        keyID,
        base64.decode(keyEncoded),
      );
    } else {
      return null;
    }
  }

  static const String TABLE_NAME = "signed_pre_key_db_record";
  static const String COLUMN_KEY_ID = "key_id";
  static const String COLUMN_SERIALIZED_KEY = "serialized_key";

  static const String CREATE_TABLE =
      "create table $TABLE_NAME ($COLUMN_KEY_ID int primary key, $COLUMN_SERIALIZED_KEY text not null);";
}
