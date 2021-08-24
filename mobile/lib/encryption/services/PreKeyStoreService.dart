import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

import 'package:mobile/services/DatabaseService.dart';
import 'package:sqflite/sqflite.dart';

import '../PreKeyDBRecord.dart';

class PreKeyStoreService extends PreKeyStore {
  final DatabaseService _databaseService;

  PreKeyStoreService(this._databaseService);

  @override
  Future<bool> containsPreKey(int preKeyId) async =>
      _databaseService.checkExistsPreKey(preKeyId);

  @override
  Future<PreKeyRecord> loadPreKey(int preKeyId) async {
    try {
      final preKeyRecord = await fetchPreKey(preKeyId);
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

  /// ******************** Database Methods ********************

  ///Fetches PreKey from the database
  Future<PreKeyRecord?> fetchPreKey(int preKeyId) async {
    final db = await _databaseService.database;
    final response = await db.query(
      PreKeyDBRecord.TABLE_NAME,
      where: "${PreKeyDBRecord.COLUMN_KEY_ID} = ?",
      whereArgs: [preKeyId],
    );

    if (response.isNotEmpty) {
      final preKey = PreKeyDBRecord.fromMap(response.first);
      if (preKey != null) {
        return PreKeyRecord.fromBuffer(preKey.serializedKey);
      }
    }
    return null;
  }

  /// Fetches all PreKeys
  Future<List<PreKeyRecord>> fetchPreKeys() async {
    final db = await _databaseService.database;
    final response = await db.query(
      PreKeyDBRecord.TABLE_NAME,
    );

    final list = <PreKeyRecord>[];

    response.forEach((element) {
      final record = PreKeyDBRecord.fromMap(element);
      if (record != null) {
        final preKeyRecord = PreKeyRecord.fromBuffer(record.serializedKey);

        if (preKeyRecord is PreKeyRecord) {
          list.add(preKeyRecord);
        }
      }
    });

    return list;
  }

  ///Checks if PreKey exists in the database
  Future<bool> checkExistsPreKey(int preKeyId) async {
    final db = await _databaseService.database;
    final response = await db.query(
      PreKeyDBRecord.TABLE_NAME,
      where: "${PreKeyDBRecord.COLUMN_KEY_ID} = ?",
      whereArgs: [preKeyId],
    );

    return response.isNotEmpty;
  }

  /// Saves a PreKey to the database and returns.
  Future<PreKeyDBRecord> savePreKey(int preKeyId, PreKeyRecord preKeyRecord) async {
    PreKeyDBRecord preKeyDBRecord = PreKeyDBRecord(preKeyId, preKeyRecord.serialize());
    final db = await _databaseService.database;

    db.insert(PreKeyDBRecord.TABLE_NAME, preKeyDBRecord.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    return preKeyDBRecord;
  }

  /// Deletes PreKey from database.
  Future<void> deletePreKey(int preKeyId) async {
    final db = await _databaseService.database;

    db.delete(
      PreKeyDBRecord.TABLE_NAME,
      where: "${PreKeyDBRecord.COLUMN_KEY_ID} = ?",
      whereArgs: [preKeyId],
    );
  }

}