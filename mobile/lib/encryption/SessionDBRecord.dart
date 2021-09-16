import 'dart:convert';
import 'dart:typed_data';

import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

class SessionDBRecord {
  final SignalProtocolAddress signalProtocolAddress;
  final Uint8List serializedSession;

  SessionDBRecord(
    this.signalProtocolAddress,
    this.serializedSession,
  );

  Map<String, dynamic> toMap() {
    return {
      COLUMN_PROTOCOL_ADDRESS_NAME: this.signalProtocolAddress.getName(),
      COLUMN_PROTOCOL_ADDRESS_DEVICE_ID:
          this.signalProtocolAddress.getDeviceId(),
      COLUMN_SERIALIZED_SESSION: base64.encode(this.serializedSession)
    };
  }

  static SessionDBRecord? fromMap(Map<String, Object?> map) {
    final name = map[SessionDBRecord.COLUMN_PROTOCOL_ADDRESS_NAME];
    final deviceId = map[SessionDBRecord.COLUMN_PROTOCOL_ADDRESS_DEVICE_ID];
    final sessionEncoded = map[SessionDBRecord.COLUMN_SERIALIZED_SESSION];

    if (name is String && deviceId is int && sessionEncoded is String) {
      return SessionDBRecord(
        SignalProtocolAddress(name, deviceId),
        base64.decode(sessionEncoded),
      );
    } else {
      return null;
    }
  }

  static const String TABLE_NAME = "session_db_record";
  static const String COLUMN_PROTOCOL_ADDRESS_NAME = "protocol_address_name";
  static const String COLUMN_PROTOCOL_ADDRESS_DEVICE_ID =
      "protocol_address_device_id";
  static const String COLUMN_SERIALIZED_SESSION = "serialized_session";

  static const String CREATE_TABLE =
      "create table $TABLE_NAME ($COLUMN_PROTOCOL_ADDRESS_NAME text, $COLUMN_PROTOCOL_ADDRESS_DEVICE_ID int, $COLUMN_SERIALIZED_SESSION text not null, PRIMARY KEY ($COLUMN_PROTOCOL_ADDRESS_NAME, $COLUMN_PROTOCOL_ADDRESS_DEVICE_ID));";
}
