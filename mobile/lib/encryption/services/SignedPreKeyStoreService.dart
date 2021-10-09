import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

import 'package:mobile/services/DatabaseService.dart';
import 'package:sqflite/sqflite.dart';

import '../SignedPreKeyDBRecord.dart';

class SignedPreKeyStoreService extends SignedPreKeyStore {
  final DatabaseService _databaseService;
  final _storage = FlutterSecureStorage();

  SignedPreKeyStoreService(this._databaseService);

  @override
  Future<SignedPreKeyRecord> loadSignedPreKey(int signedPreKeyId) async {
    try {
      final signedPreKeyRecord = await fetchSignedPreKey(signedPreKeyId);
      if (signedPreKeyRecord == null) {
        throw InvalidKeyIdException(
            'No such signedprekeyrecord! $signedPreKeyId');
      }
      return signedPreKeyRecord;
    } on Exception catch (e) {
      throw AssertionError(e);
    }
  }

  @override
  Future<List<SignedPreKeyRecord>> loadSignedPreKeys() async {
    try {
      final results = await fetchSignedPreKeys();
      return results;
    } on Exception catch (e) {
      throw AssertionError(e);
    }
  }

  Future<void> storeLocalSignedPreKeyID(int signedPreKeyId) async {
    await _storage.write(
        key: "local_signed_prekey_id", value: signedPreKeyId.toString());
  }

  Future<int?> fetchLocalSignedPreKeyID() async {
    final id = await _storage.read(key: "local_signed_prekey_id");
    if (id == null) return null;
    return int.parse(id);
  }

  /// ******************** Database Methods ********************

  ///Fetches SignedPreKey from the database
  Future<SignedPreKeyRecord?> fetchSignedPreKey(int preKeyId) async {
    final db = await _databaseService.database;
    final response = await db.query(
      SignedPreKeyDBRecord.TABLE_NAME,
      where: "${SignedPreKeyDBRecord.COLUMN_KEY_ID} = ?",
      whereArgs: [preKeyId],
    );

    if (response.isNotEmpty) {
      final signedPreKey = SignedPreKeyDBRecord.fromMap(response.first);
      if (signedPreKey != null) {
        return SignedPreKeyRecord.fromSerialized(signedPreKey.serializedKey);
      }
    }
    return null;
  }

  /// Fetches all SignedPreKeys
  Future<List<SignedPreKeyRecord>> fetchSignedPreKeys() async {
    final db = await _databaseService.database;
    final response = await db.query(
      SignedPreKeyDBRecord.TABLE_NAME,
    );

    final list = <SignedPreKeyRecord>[];

    response.forEach((element) {
      final record = SignedPreKeyDBRecord.fromMap(element);
      if (record != null) {
        final signedPreKeyRecord =
            SignedPreKeyRecord.fromSerialized(record.serializedKey);

        if (signedPreKeyRecord is SignedPreKeyRecord) {
          list.add(signedPreKeyRecord);
        }
      }
    });

    return list;
  }

  /// Saves a SignedPreKey to the database and returns.
  @override
  Future<void> storeSignedPreKey(
      int signedPreKeyId, SignedPreKeyRecord record) async {
    SignedPreKeyDBRecord signedPreKeyDBRecord =
        SignedPreKeyDBRecord(signedPreKeyId, record.serialize());
    final db = await _databaseService.database;

    await db.insert(SignedPreKeyDBRecord.TABLE_NAME, signedPreKeyDBRecord.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  ///Checks if SignedPreKey exists in the database
  @override
  Future<bool> containsSignedPreKey(int signedPreKeyId) async {
    final db = await _databaseService.database;
    final response = await db.query(
      SignedPreKeyDBRecord.TABLE_NAME,
      where: "${SignedPreKeyDBRecord.COLUMN_KEY_ID} = ?",
      whereArgs: [signedPreKeyId],
    );

    return response.isNotEmpty;
  }

  /// Deletes SignedPreKey from database.
  @override
  Future<void> removeSignedPreKey(int signedPreKeyId) async {
    final db = await _databaseService.database;

    await db.delete(
      SignedPreKeyDBRecord.TABLE_NAME,
      where: "${SignedPreKeyDBRecord.COLUMN_KEY_ID} = ?",
      whereArgs: [signedPreKeyId],
    );
  }
}
