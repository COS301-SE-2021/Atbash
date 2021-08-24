import 'dart:async';

import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

import 'package:mobile/services/DatabaseService.dart';

import '../SessionDBRecord.dart';

class SessionStoreService extends SessionStore {
  final DatabaseService _databaseService;

  SessionStoreService(this._databaseService);

  // @override
  // Future<bool> containsSession(SignalProtocolAddress address) async {
  //   print("Checking session exists for number: " + address.getName());
  //   return (await _databaseService.fetchSession(address)) != null;
  // }

  // @override
  // Future<void> deleteAllSessions(String name) async {
  //   await _databaseService.deleteAllSessions();
  // }

  // @override
  // Future<void> deleteSession(SignalProtocolAddress address) async {
  //   await _databaseService.deleteSession(address);
  // }

  @override
  Future<List<int>> getSubDeviceSessions(String name) async {
    return await _databaseService.fetchSubDeviceSessions(name);
  }

  @override
  Future<SessionRecord> loadSession(SignalProtocolAddress address) async {
    print("Loading session for number: " + address.getName());
    try {
      final sessionRecord = await _databaseService.fetchSession(address);
      if (sessionRecord != null) {
        print("Returning session");
        return sessionRecord;
      } else {
        print("Returning blank/new session");
        return SessionRecord();
      }
    } on Exception catch (e) {
      throw AssertionError(e);
    }
  }

  @override
  Future<void> storeSession(
      SignalProtocolAddress address, SessionRecord record) async {
    print("Storing session for number: " + address.getName());
    await _databaseService.saveSession(address, record);
  }

  /// ******************** Database Methods ********************

  ///Checking session exists for number in the database
  @override
  Future<bool> containsSession(SignalProtocolAddress address) async {
    final db = await _databaseService.database;
    final response = await db.query(
      SessionDBRecord.TABLE_NAME,
      where:
      "${SessionDBRecord.COLUMN_PROTOCOL_ADDRESS_NAME} = ? and ${SessionDBRecord.COLUMN_PROTOCOL_ADDRESS_DEVICE_ID} = ?",
      whereArgs: [address.getName(), address.getDeviceId()],
    );

    return response.isNotEmpty;
  }

  /// Deletes all sessions from database.
  @override
  Future<void> deleteAllSessions() async {
    final db = await _databaseService.database;
    db.delete(SessionDBRecord.TABLE_NAME);
  }

  /// Deletes sessions from database with specified SignalProtocolAddress.
  @override
  Future<void> deleteSession(SignalProtocolAddress address) async {
    final db = await _databaseService.database;
    db.delete(
      SessionDBRecord.TABLE_NAME,
      where:
      "${SessionDBRecord.COLUMN_PROTOCOL_ADDRESS_NAME} = ? and ${SessionDBRecord.COLUMN_PROTOCOL_ADDRESS_DEVICE_ID} = ?",
      whereArgs: [address.getName(), address.getDeviceId()],
    );
  }

}