import 'dart:async';

import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

import 'package:mobile/services/DatabaseService.dart';

class SessionStoreService extends SessionStore {
  final DatabaseService _databaseService;

  SessionStoreService(this._databaseService);

  @override
  Future<bool> containsSession(SignalProtocolAddress address) async {
    print("Checking session exists for number: " + address.getName());
    return (await _databaseService.fetchSession(address)) != null;
  }

  @override
  Future<void> deleteAllSessions(String name) async {
    await _databaseService.deleteAllSessions();
  }

  @override
  Future<void> deleteSession(SignalProtocolAddress address) async {
    await _databaseService.deleteSession(address);
  }

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
}