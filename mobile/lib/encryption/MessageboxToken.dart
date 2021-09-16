import 'package:crypton/crypton.dart';

class MessageboxToken {
  final int id;
  final RSAKeypair keypair;
  final BigInt signedPK;

  MessageboxToken(
      this.id,
      this.keypair,
      this.signedPK
      );

  Map<String, dynamic> toMap() {
    return {
      COLUMN_MT_ID: this.id,
      COLUMN_SERIALIZED_KEYPAIR: keypair.privateKey.toString(),
      COLUMN_SIGNED_PK: signedPK.toString(),
    };
  }

  static MessageboxToken? fromMap(Map<String, Object?> map) {
    final id = map[MessageboxToken.COLUMN_MT_ID];
    final keypair = map[MessageboxToken.COLUMN_SERIALIZED_KEYPAIR];
    final signedPK = map[MessageboxToken.COLUMN_SIGNED_PK];

    if (id is int && keypair is String && signedPK is String) {
      return MessageboxToken(
        id,
        RSAKeypair(RSAPrivateKey.fromString(keypair)),
        BigInt.parse(signedPK)
      );
    } else {
      return null;
    }
  }

  static const String TABLE_NAME = "messagebox_token";
  static const String COLUMN_MT_ID = "messagebox_token_id";
  static const String COLUMN_SERIALIZED_KEYPAIR = "serialized_keypair";
  static const String COLUMN_SIGNED_PK = "signed_pk";

  static const String CREATE_TABLE =
      "create table $TABLE_NAME ($COLUMN_MT_ID int primary key, $COLUMN_SERIALIZED_KEYPAIR text not null, $COLUMN_SIGNED_PK text not null);";
}