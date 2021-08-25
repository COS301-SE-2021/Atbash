import 'dart:convert';
import 'dart:typed_data';

import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

class TrustedKeyDBRecord {
  final SignalProtocolAddress signalProtocolAddress;
  final Uint8List serializedKey;

  TrustedKeyDBRecord(
      this.signalProtocolAddress,
      this.serializedKey,
      );

  Map<String, dynamic> toMap() {
    return {
      COLUMN_PROTOCOL_ADDRESS_NAME: this.signalProtocolAddress.getName(),
      COLUMN_PROTOCOL_ADDRESS_DEVICE_ID: this.signalProtocolAddress.getDeviceId(),
      COLUMN_SERIALIZED_KEY: base64.encode(this.serializedKey)
    };
  }

  static TrustedKeyDBRecord? fromMap(Map<String, Object?> map) {
    final name = map[TrustedKeyDBRecord.COLUMN_PROTOCOL_ADDRESS_NAME];
    final deviceId = map[TrustedKeyDBRecord.COLUMN_PROTOCOL_ADDRESS_DEVICE_ID];
    final keyEncoded = map[TrustedKeyDBRecord.COLUMN_SERIALIZED_KEY];

    if (name is String &&
        deviceId is int &&
        keyEncoded is String) {
      return TrustedKeyDBRecord(
        SignalProtocolAddress(name, deviceId),
        base64.decode(keyEncoded),
      );
    } else {
      return null;
    }
  }

  static const String TABLE_NAME = "trusted_key_db_record";
  static const String COLUMN_PROTOCOL_ADDRESS_NAME = "protocol_address_name";
  static const String COLUMN_PROTOCOL_ADDRESS_DEVICE_ID = "protocol_address_device_id";
  static const String COLUMN_SERIALIZED_KEY = "serialized_key";

  static const String CREATE_TABLE =
      "create table $TABLE_NAME ($COLUMN_PROTOCOL_ADDRESS_NAME text, $COLUMN_PROTOCOL_ADDRESS_DEVICE_ID int, $COLUMN_SERIALIZED_KEY text not null, PRIMARY KEY ($COLUMN_PROTOCOL_ADDRESS_NAME, $COLUMN_PROTOCOL_ADDRESS_DEVICE_ID));";
}