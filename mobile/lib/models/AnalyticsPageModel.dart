import 'package:mobile/domain/Chat.dart';
import 'package:mobile/util/Tuple.dart';
import 'package:mobx/mobx.dart';

part 'AnalyticsPageModel.g.dart';

class AnalyticsPageModel = _AnalyticsPageModel with _$AnalyticsPageModel;

abstract class _AnalyticsPageModel with Store {
  @observable
  ObservableList<Tuple<Chat, int>> chatMessageCount =
      <Tuple<Chat, int>>[].asObservable();

  @observable
  int totalTextMessagesSent = 0;

  @observable
  int totalTextMessagesReceived = 0;

  @observable
  int totalPhotosSent = 0;

  @observable
  int totalPhotosReceived = 0;

  @observable
  int totalMessagesLiked = 0;

  @observable
  int totalMessagesTagged = 0;

  @observable
  int totalMessagesDeleted = 0;

  @observable
  int totalProfanityPacksSent = 0;

  @observable
  int totalProfanityPacksReceived = 0;
}
