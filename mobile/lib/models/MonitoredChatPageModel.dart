import 'package:mobile/domain/ChildBlockedNumber.dart';
import 'package:mobile/domain/ChildMessage.dart';
import 'package:mobx/mobx.dart';

part 'MonitoredChatPageModel.g.dart';

class MonitoredChatPageModel = _MonitoredChatPageModel
    with _$MonitoredChatPageModel;

abstract class _MonitoredChatPageModel with Store {
  @observable
  String childName = "";

  @observable
  String otherMemberName = "";

  @observable
  String otherMemberNumber = "";

  @observable
  List<ChildBlockedNumber> blockedNumbers =
      <ChildBlockedNumber>[].asObservable();

  @computed
  bool get blocked =>
      blockedNumbers.any((number) => number.blockedNumber == otherMemberNumber);

  @observable
  List<ChildMessage> messages = <ChildMessage>[].asObservable();
}
