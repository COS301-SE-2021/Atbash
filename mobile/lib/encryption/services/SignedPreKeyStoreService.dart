import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

import 'package:mobile/services/DatabaseService.dart';

class SignedPreKeyStoreService extends SignedPreKeyStore {
  final DatabaseService _databaseService;
  final _storage = FlutterSecureStorage();

  SignedPreKeyStoreService(this._databaseService);

  // final store = HashMap<int, Uint8List>();

  @override
  Future<SignedPreKeyRecord> loadSignedPreKey(int signedPreKeyId) async {
    try {
      final signedPreKeyRecord = await _databaseService.fetchSignedPreKey(signedPreKeyId);
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
      final results = await _databaseService.fetchSignedPreKeys();
      return results;
    } on Exception catch (e) {
      throw AssertionError(e);
    }
  }

  @override
  Future<void> storeSignedPreKey(
      int signedPreKeyId, SignedPreKeyRecord record) async {
    _databaseService.saveSignedPreKey(signedPreKeyId, record);
  }

  @override
  Future<bool> containsSignedPreKey(int signedPreKeyId) async =>
      _databaseService.checkExistsSignedPreKey(signedPreKeyId);

  @override
  Future<void> removeSignedPreKey(int signedPreKeyId) async {
    _databaseService.deleteSignedPreKey(signedPreKeyId);
  }

  Future<void> storeLocalSignedPreKeyID(int signedPreKeyId) async {
    await _storage.write(key: "local_signed_prekey_id", value: signedPreKeyId.toString());
  }

  Future<int?> fetchLocalSignedPreKeyID() async {
    final id = await _storage.read(key: "local_signed_prekey_id");
    if(id == null) return null;
    return int.parse(id);
  }
}