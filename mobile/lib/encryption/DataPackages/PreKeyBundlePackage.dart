import 'dart:convert';

import 'package:crypton/crypton.dart';
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

import 'PreKeyPackage.dart';
import 'SignedPreKeyPackage.dart';

class PreKeyBundlePackage {
  final IdentityKey identityKey;
  final int registrationId;
  final int deviceId;
  final SignedPreKeyPackage signedPreKey;
  final PreKeyPackage preKey;
  final RSAPublicKey rsaPublicKey;

  PreKeyBundlePackage(this.registrationId, this.deviceId, this.identityKey,
      this.signedPreKey, this.preKey, this.rsaPublicKey);

  PreKeyBundlePackage.fromJson(Map<String, dynamic> json)
      : identityKey =
            IdentityKey.fromBytes(base64Decode(json['identityKey']), 0),
        deviceId = json['deviceId'],
        registrationId = json['registrationId'],
        signedPreKey = SignedPreKeyPackage.fromJson(json['signedPreKey']),
        //Unhandled Exception: type '_InternalLinkedHashMap<String, dynamic>' is not a subtype of type 'String'
        preKey = PreKeyPackage.fromJson(json['preKey']),
        rsaPublicKey = RSAPublicKey.fromString(json["rsaKey"]);

  PreKeyBundle createPreKeyBundle() {
    PreKeyBundle preKeyBundle = PreKeyBundle(
        registrationId,
        deviceId,
        preKey.keyId,
        Curve.decodePoint(base64Decode(preKey.publicKey), 0),
        signedPreKey.keyId,
        Curve.decodePoint(base64Decode(signedPreKey.publicKey), 0),
        base64Decode(signedPreKey.signature),
        identityKey);

    return preKeyBundle;
  }
}

// "identityKey":"Bbqgqsljd0xcMK8zCU/Ex12/A0OQAiakaxHg8pXd85BW",
// "deviceId":1,
// "registrationId":13975,
// "signedPreKey":
// {
//   "keyId":4590740,
//   "publicKey":"BfSBjiwTiiShoQb3PuTKHANgNI+KCSiDHfL6cmetFO0d",
//   "signature":"yrpFYdPCl0d9cDsLVUm9JQPlIp5APKNuvHdKnVSOab7m6JuMNe6Xp1LcQMDG4mu3cRfpirCZ2aT7FQtAxVLWBA"
// },
// "preKey": {
//   "keyId":12146509,
//   "publicKey":"BRszJOJohHaI7zDMM3h3o95z/tllmqPmnOd7SjbzD41n" }
// }
