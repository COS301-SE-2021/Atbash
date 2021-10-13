import 'dart:convert';
import 'package:collection/collection.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

import 'package:mobile/services/DatabaseService.dart';
import 'package:sqflite/sqflite.dart';

import '../TrustedKeyDBRecord.dart';

class IdentityKeyStoreService extends IdentityKeyStore {
  final _storage = FlutterSecureStorage();
  final DatabaseService _databaseService;

  IdentityKeyStoreService(this._databaseService) {
    _storage.read(key: "local_registration_id").then((value) {
      if (value == null) {
        final registrationId = generateRegistrationId(false);
        _storage.write(
            key: "local_registration_id", value: registrationId.toString());
      }
    });

    _storage.read(key: "identity_key_pair").then((value) {
      if (value == null) {
        final identityKeyPair = generateIdentityKeyPair();
        _storage.write(
            key: "identity_key_pair",
            value: base64.encode(identityKeyPair.serialize()));
      }
    });
  }

  @override
  Future<IdentityKey> getIdentity(SignalProtocolAddress address) async {
    final key = await fetchTrustedKey(address);

    return key!;
  }

  ///The returned value should never be null
  @override
  Future<IdentityKeyPair> getIdentityKeyPair() async => _storage
      .read(key: "identity_key_pair")
      .then((value) => IdentityKeyPair.fromSerialized(base64.decode(value!)));

  ///The returned value should never be null
  @override
  Future<int> getLocalRegistrationId() async => _storage
      .read(key: "local_registration_id")
      .then((value) => int.parse(value!));

  Future<void> setIdentityKPRegistrationId(
      IdentityKeyPair identityKeyPair, int registrationId) async {
    Future.wait([
      _storage.write(
          key: "identity_key_pair",
          value: base64.encode(identityKeyPair.serialize())),
      _storage.write(
          key: "local_registration_id", value: registrationId.toString()),
    ]);
  }

  @override
  Future<bool> isTrustedIdentity(SignalProtocolAddress address,
      IdentityKey? identityKey, Direction? direction) async {
    return true;

    ///Disabling this for now as don't really need it
    ///This can be used at a later date to check when an identify key changes
    ///The user should be notified of this so that they can check they're still
    ///talking to who they think they're talking to
    // final trusted = await fetchTrustedKey(address);
    // if (identityKey == null) {
    //   return false;
    // }
    // // ignore: avoid_dynamic_calls
    // return trusted == null ||
    //     ListEquality().equals(trusted.serialize(), identityKey.serialize());
  }

  @override
  Future<bool> saveIdentity(
      SignalProtocolAddress address, IdentityKey? identityKey) async {
    final existing = await fetchTrustedKey(address);
    if (identityKey == null) {
      return false;
    }
    if (identityKey != existing) {
      await saveTrustedKey(address, identityKey);
      return true;
    } else {
      return false;
    }
  }

  /// ******************** Database Methods ********************

  /// Fetches trusted key for a SignalProtocolAddress
  Future<IdentityKey?> fetchTrustedKey(SignalProtocolAddress address) async {
    final db = await _databaseService.database;
    final response = await db.query(
      TrustedKeyDBRecord.TABLE_NAME,
      where:
          "${TrustedKeyDBRecord.COLUMN_PROTOCOL_ADDRESS_NAME} = ? and ${TrustedKeyDBRecord.COLUMN_PROTOCOL_ADDRESS_DEVICE_ID} = ?",
      whereArgs: [address.getName(), address.getDeviceId()],
    );

    if (response.isNotEmpty) {
      final trustedKey = TrustedKeyDBRecord.fromMap(response.first);
      if (trustedKey != null) {
        return IdentityKey.fromBytes(trustedKey.serializedKey, 0);
      }
    }
    return null;
  }

  /// Saves a TrustedKey to the database and returns.
  Future<TrustedKeyDBRecord> saveTrustedKey(
      SignalProtocolAddress address, IdentityKey identityKey) async {
    TrustedKeyDBRecord trustedKey =
        TrustedKeyDBRecord(address, identityKey.serialize());

    final db = await _databaseService.database;

    db.insert(TrustedKeyDBRecord.TABLE_NAME, trustedKey.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    return trustedKey;
  }
}
