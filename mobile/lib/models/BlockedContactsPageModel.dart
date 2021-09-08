import 'package:mobile/domain/BlockedNumber.dart';
import 'package:mobx/mobx.dart';

part 'BlockedContactsPageModel.g.dart';

class BlockedContactsPageModel = _BlockedContactsPageModel
    with _$BlockedContactsPageModel;

abstract class _BlockedContactsPageModel with Store {
  @observable
  List<BlockedNumber> blockedNumbers = [];
}
