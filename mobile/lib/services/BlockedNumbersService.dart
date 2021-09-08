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

  Future<List<BlockedNumber>> insert(BlockedNumber blockedNumber) {}

  void _notifyListeners() {
    _onChangedListeners.forEach((listener) => listener);
  }
}
