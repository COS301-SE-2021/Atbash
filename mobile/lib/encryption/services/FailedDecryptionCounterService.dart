import 'package:mobile/services/DatabaseService.dart';
import 'package:sqflite/sqflite.dart';

import '../FailedDecryptionCounter.dart';

class FailedDecryptionCounterService {
  final DatabaseService _databaseService;

  FailedDecryptionCounterService(this._databaseService);

  Future<int> incrementCounter(String phoneNumber) async {
    FailedDecryptionCounter? failedDecryptionCounter = await fetchCounter(phoneNumber);

    if(failedDecryptionCounter == null){
      await storeCounter(new FailedDecryptionCounter(phoneNumber, 1));
      return 1;
    } else {
      int count = failedDecryptionCounter.counter + 1;
      await storeCounter(new FailedDecryptionCounter(phoneNumber, count));
      return count;
    }
  }

  Future<void> resetCounter(String phoneNumber) async {
    await storeCounter(new FailedDecryptionCounter(phoneNumber, 0));
  }

  /// ******************** Database Methods ********************

  ///Fetches Counter from the database
  Future<FailedDecryptionCounter?> fetchCounter(String phoneNumber) async {
    final db = await _databaseService.database;
    final response = await db.query(
      FailedDecryptionCounter.TABLE_NAME,
      where: "${FailedDecryptionCounter.COLUMN_PHONE_NUMBER} = ?",
      whereArgs: [phoneNumber],
    );

    if (response.isNotEmpty) {
      return FailedDecryptionCounter.fromMap(response.first);
    }
    return null;
  }

  ///Stores Counter to the database
  Future<void> storeCounter(FailedDecryptionCounter counter) async {
    final db = await _databaseService.database;

    await db.insert(FailedDecryptionCounter.TABLE_NAME, counter.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }
}