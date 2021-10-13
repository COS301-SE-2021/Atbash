class FailedDecryptionCounter {
  final String phoneNumber;
  final int counter;

  FailedDecryptionCounter(
      this.phoneNumber,
      this.counter,
      );

  Map<String, dynamic> toMap() {
    return {
      COLUMN_PHONE_NUMBER: this.phoneNumber,
      COLUMN_COUNTER: this.counter
    };
  }

  static FailedDecryptionCounter? fromMap(Map<String, Object?> map) {
    final phoneNumber = map[FailedDecryptionCounter.COLUMN_PHONE_NUMBER] as String?;
    final counter = map[FailedDecryptionCounter.COLUMN_COUNTER] as int?;

    if (phoneNumber is String && counter is int) {
      return FailedDecryptionCounter(
        phoneNumber,
        counter
      );
    } else {
      return null;
    }
  }

  static const String TABLE_NAME = "failed_decryption_counter";
  static const String COLUMN_PHONE_NUMBER = "phone_number";
  static const String COLUMN_COUNTER = "counter";

  static const String CREATE_TABLE =
      "create table $TABLE_NAME ($COLUMN_PHONE_NUMBER text not null, $COLUMN_COUNTER int not null, PRIMARY KEY ($COLUMN_PHONE_NUMBER));";
}