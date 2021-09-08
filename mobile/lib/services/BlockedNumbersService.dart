import 'package:mobile/services/DatabaseService.dart';

class BlockedNumbersService {
  final DatabaseService databaseService;

  BlockedNumbersService(this.databaseService);

  final List<void Function()> _onChangedListeners = [];

  void onChanged(void Function() cb) => _onChangedListeners.add(cb);

  void disposeOnChanged(void Function() cb) => _onChangedListeners.remove(cb);

  void _notifyListeners() {
    _onChangedListeners.forEach((listener) => listener());
  }
}
