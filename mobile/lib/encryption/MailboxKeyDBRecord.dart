import 'package:crypton/crypton.dart';

class MailboxTokenDBRecord {
  final int id;
  final RSAKeypair keypair;
  final BigInt signedPK;
  final int expires;

  MailboxTokenDBRecord(
      this.id,
      this.keypair,
      this.signedPK,
      this.expires
      );

  Map<String, dynamic> toMap() {
    return {
      COLUMN_MT_ID: this.id,
      COLUMN_SERIALIZED_KEYPAIR: keypair.privateKey.toString(),
      COLUMN_SIGNED_PK: signedPK.toString(),
      COLUMN_EXPIRES: expires
    };
  }

  static MailboxTokenDBRecord? fromMap(Map<String, Object?> map) {
    final id = map[MailboxTokenDBRecord.COLUMN_MT_ID];
    final keypair = map[MailboxTokenDBRecord.COLUMN_SERIALIZED_KEYPAIR];
    final signedPK = map[MailboxTokenDBRecord.COLUMN_SIGNED_PK];
    final expires = map[MailboxTokenDBRecord.COLUMN_EXPIRES];

    if (id is int && keypair is String && signedPK is String && expires is int) {
      return MailboxTokenDBRecord(
        id,
        RSAKeypair(RSAPrivateKey.fromString(keypair)),
        BigInt.parse(signedPK),
        expires
      );
    } else {
      return null;
    }
  }

  static const String TABLE_NAME = "mailbox_token_db_record";
  static const String COLUMN_MT_ID = "mailbox_token_id";
  static const String COLUMN_SERIALIZED_KEYPAIR = "serialized_keypair";
  static const String COLUMN_SIGNED_PK = "signed_pk";
  static const String COLUMN_EXPIRES = "expires";

  static const String CREATE_TABLE =
      "create table $TABLE_NAME ($COLUMN_MT_ID int primary key, $COLUMN_SERIALIZED_KEYPAIR text not null, $COLUMN_SIGNED_PK text not null, $COLUMN_EXPIRES int not null);";
}