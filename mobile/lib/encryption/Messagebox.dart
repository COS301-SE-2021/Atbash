import 'package:crypton/crypton.dart';

class Messagebox {
  final String id;
  final RSAKeypair keypair;
  String? number;
  RSAPublicKey? recipientKey;
  final int expires;

  Messagebox(
      this.id,
      this.keypair,
      this.number,
      this.recipientKey,
      this.expires
      );

  Map<String, dynamic> toMap() {
    return {
      COLUMN_M_ID: this.id,
      COLUMN_SERIALIZED_KEYPAIR: this.keypair.privateKey.toString(),
      COLUMN_NUMBER: this.number,
      COLUMN_RECIPIENT_KEY: this.recipientKey.toString(),
      COLUMN_EXPIRES: this.expires,
    };
  }

  static Messagebox? fromMap(Map<String, Object?> map) {
    final id = map[Messagebox.COLUMN_M_ID];
    final keypair = map[Messagebox.COLUMN_SERIALIZED_KEYPAIR];
    final number = map[Messagebox.COLUMN_NUMBER] as String?;
    final recipientKeyStr = map[Messagebox.COLUMN_RECIPIENT_KEY] as String?;
    final expires = map[Messagebox.COLUMN_EXPIRES];

    var recipientKey = null;
    if(recipientKeyStr != null){
      recipientKey = RSAPublicKey.fromString(recipientKeyStr);
    }

    if (id is String && keypair is String && expires is int) {
      return Messagebox(
          id,
          RSAKeypair(RSAPrivateKey.fromString(keypair)),
          number,
          recipientKey,
          expires
      );
    } else {
      return null;
    }
  }

  static const String TABLE_NAME = "messagebox";
  static const String COLUMN_M_ID = "messagebox_id";
  static const String COLUMN_SERIALIZED_KEYPAIR = "serialized_keypair";
  static const String COLUMN_NUMBER = "number";
  static const String COLUMN_RECIPIENT_KEY = "recipient_key";
  static const String COLUMN_EXPIRES = "expires";

  static const String CREATE_TABLE =
      "create table $TABLE_NAME ($COLUMN_M_ID text primary key, $COLUMN_SERIALIZED_KEYPAIR text not null, $COLUMN_NUMBER text, $COLUMN_RECIPIENT_KEY text, $COLUMN_EXPIRES text not null);";
}