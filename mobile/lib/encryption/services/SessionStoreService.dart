import 'dart:async';

import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

import 'package:mobile/services/DatabaseService.dart';
import 'package:sqflite/sqflite.dart';

import '../SessionDBRecord.dart';

class SessionStoreService extends SessionStore {
  final DatabaseService _databaseService;

  SessionStoreService(this._databaseService);

  @override
  Future<SessionRecord> loadSession(SignalProtocolAddress address) async {
    try {
      final sessionRecord = await fetchSession(address);
      if (sessionRecord != null) {
        return sessionRecord;
      } else {
        return SessionRecord();
      }
    } on Exception catch (e) {
      throw AssertionError(e);
    }
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
  Future<void> deleteAllSessions(String name) async {
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

  /// Fetches a list of sub devices for the specified name
  @override
  Future<List<int>> getSubDeviceSessions(String name) async {
    final db = await _databaseService.database;
    final response = await db.query(
      SessionDBRecord.TABLE_NAME,
      where:
          "${SessionDBRecord.COLUMN_PROTOCOL_ADDRESS_NAME} = ? and ${SessionDBRecord.COLUMN_PROTOCOL_ADDRESS_DEVICE_ID} != 1",
      whereArgs: [name],
    );

    final list = <int>[];

    response.forEach((element) {
      final session = SessionDBRecord.fromMap(element);
      if (session != null) {
        list.add(session.signalProtocolAddress.getDeviceId());
      }
    });

    return list;
  }

  /// Fetches all sessions for a SignalProtocolAddress
  Future<SessionRecord?> fetchSession(SignalProtocolAddress address) async {
    final db = await _databaseService.database;
    final response = await db.query(
      SessionDBRecord.TABLE_NAME,
      where:
          "${SessionDBRecord.COLUMN_PROTOCOL_ADDRESS_NAME} = ? and ${SessionDBRecord.COLUMN_PROTOCOL_ADDRESS_DEVICE_ID} = ?",
      whereArgs: [address.getName(), address.getDeviceId()],
    );

    if (response.isNotEmpty) {
      final sessionDBRecord = SessionDBRecord.fromMap(response.first);
      if (sessionDBRecord != null) {
        return SessionRecord.fromSerialized(sessionDBRecord.serializedSession);
      }
    }
    return null;
  }

  /// Saves a SessionRecord to the database and returns.
  @override
  Future<void> storeSession(
      SignalProtocolAddress address, SessionRecord record) async {
    SessionDBRecord sessionDBRecord =
        SessionDBRecord(address, record.serialize());
    final db = await _databaseService.database;

    await db.insert(SessionDBRecord.TABLE_NAME, sessionDBRecord.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }
}
