import 'package:mobile/domain/BlockedNumber.dart';
import 'package:mobile/services/DatabaseService.dart';

class BlockedNumbersService {
  final DatabaseService databaseService;

  BlockedNumbersService(this.databaseService);

  final List<void Function()> _onChangedListeners = [];

  void onChanged(void Function() cb) => _onChangedListeners.add(cb);

  void disposeOnChanged(void Function() cb) => _onChangedListeners.remove(cb);

  Future<List<BlockedNumber>> fetchAll() async {
    final db = await databaseService.database;

    final response = await db.query(BlockedNumber.TABLE_NAME);

    final numbers = <BlockedNumber>[];
    response.forEach((e) {
      final blockedNumber = BlockedNumber.fromMap(e);
      if (blockedNumber != null) numbers.add(blockedNumber);
    });

    return numbers;
  }

  Future<bool> checkIfBlocked(String phoneNumber) async {
    final db = await databaseService.database;

    final response = await db.query(
      BlockedNumber.TABLE_NAME,
      where: "${BlockedNumber.COLUMN_PHONE_NUMBER} = ?",
      whereArgs: [phoneNumber],
    );

    if (response.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<BlockedNumber> insert(BlockedNumber blockedNumber) async {
    final db = await databaseService.database;

    await db.transaction((txn) async {
      final existingNumber = await txn.query(BlockedNumber.TABLE_NAME,
          where: "${BlockedNumber.COLUMN_PHONE_NUMBER} = ?",
          whereArgs: [blockedNumber.phoneNumber]);

      if (existingNumber.isNotEmpty) throw duplicateBlockedNumberException();

      await txn.insert(BlockedNumber.TABLE_NAME, blockedNumber.toMap());
    });

    _notifyListeners();
    return blockedNumber;
  }

  Future<void> delete(String number) async {
    final db = await databaseService.database;

    await db.transaction((txn) async {
      final existingNumber = await txn.query(BlockedNumber.TABLE_NAME,
          where: "${BlockedNumber.COLUMN_PHONE_NUMBER} = ?",
          whereArgs: [number]);

      if (existingNumber.isEmpty) throw blockedNumberDoesNotExistException();

      await txn.delete(BlockedNumber.TABLE_NAME,
          where: "${BlockedNumber.COLUMN_PHONE_NUMBER} =?",
          whereArgs: [number]);
    });

    _notifyListeners();
  }

  void _notifyListeners() {
    _onChangedListeners.forEach((listener) => listener);
  }
}

class duplicateBlockedNumberException implements Exception {}

class blockedNumberDoesNotExistException implements Exception {}
