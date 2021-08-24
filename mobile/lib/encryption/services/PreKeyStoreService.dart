import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

import 'package:mobile/services/DatabaseService.dart';

class PreKeyStoreService extends PreKeyStore {
  final DatabaseService _databaseService;

  PreKeyStoreService(this._databaseService);

  @override
  Future<bool> containsPreKey(int preKeyId) async =>
      _databaseService.checkExistsPreKey(preKeyId);

  @override
  Future<PreKeyRecord> loadPreKey(int preKeyId) async {
    try {
      final preKeyRecord = await _databaseService.fetchPreKey(preKeyId);
      if (preKeyRecord == null) {
        throw InvalidKeyIdException('No such prekeyrecord! - $preKeyId');
      }

      return preKeyRecord;
    } on Exception catch (e) {
      throw AssertionError(e);
    }
  }

  @override
  Future<void> removePreKey(int preKeyId) async {
    _databaseService.deletePreKey(preKeyId);
  }

  @override
  Future<void> storePreKey(int preKeyId, PreKeyRecord record) async {
    _databaseService.savePreKey(preKeyId, record);
  }

  Future<List<PreKeyRecord>> loadPreKeys() async {
    return await _databaseService.fetchPreKeys();
  }
}