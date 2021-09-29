import 'package:mobile/domain/ChildBlockedNumber.dart';
import 'package:mobile/services/DatabaseService.dart';

class ChildBlockedNumberService {
  final DatabaseService databaseService;

  ChildBlockedNumberService(this.databaseService);

  Future<List<ChildBlockedNumber>> fetchAllByNumber(String number) async {
    final db = await databaseService.database;

    final result = await db.query(ChildBlockedNumber.TABLE_NAME,
        where: "${ChildBlockedNumber.COLUMN_CHILD_NUMBER} = ?",
        whereArgs: [number]);

    final numbers = <ChildBlockedNumber>[];
    result.forEach((element) {
      final number = ChildBlockedNumber.fromMap(element);
      if (number != null) numbers.add(number);
    });
    return numbers;
  }

  Future<void> insert(ChildBlockedNumber number) async {
    final db = await databaseService.database;

    await db.transaction((txn) async {
      final existingNumber = await txn.query(ChildBlockedNumber.TABLE_NAME,
          where:
              "${ChildBlockedNumber.COLUMN_CHILD_NUMBER} = ? AND ${ChildBlockedNumber.COLUMN_BLOCKED_NUMBER} = ?",
          whereArgs: [number.childNumber, number.blockedNumber]);

      if (existingNumber.isNotEmpty)
        throw BlockedNumberAlreadyExistsException();

      txn.insert(ChildBlockedNumber.TABLE_NAME, number.toMap());
    });
  }

  Future<void> delete(String childNumber, String numberToDelete) async {
    final db = await databaseService.database;

    db.delete(ChildBlockedNumber.TABLE_NAME,
        where:
            "${ChildBlockedNumber.COLUMN_CHILD_NUMBER} = ? AND ${ChildBlockedNumber.COLUMN_BLOCKED_NUMBER} = ?",
        whereArgs: [childNumber, numberToDelete]);
  }
}

class BlockedNumberAlreadyExistsException implements Exception {}
