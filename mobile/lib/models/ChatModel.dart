import 'package:mobile/domain/Message.dart';
import 'package:mobile/services/DatabaseService.dart';
import 'package:mobx/mobx.dart';

part 'ChatModel.g.dart';

class ChatModel = ChatModelBase with _$ChatModel;

abstract class ChatModelBase with Store {
  final DatabaseService _databaseService;

  ChatModelBase(this._databaseService);

  @observable
  String contactPhoneNumber = "";

  @observable
  ObservableList<Message> chatMessages = <Message>[].asObservable();

  @observable
  int page = 0;

  @action
  Future<void> initContact(String contactPhoneNumber) async {
    this.page = 0;
    this.contactPhoneNumber = contactPhoneNumber;

    chatMessages.clear();
    await fetchNextMessagesPage();
  }

  @action
  Future<void> fetchNextMessagesPage() async {
    final messages =
        await _databaseService.fetchMessagesWith(contactPhoneNumber, page++);
    chatMessages.addAll(messages);
  }

  @action
  void markMessageDelivered(String messageId) {
    final index = chatMessages.indexWhere((m) => m.id == messageId);
    if (index >= 0) {
      final message = chatMessages.removeAt(index);
      message.readReceipt = ReadReceipt.delivered;
      chatMessages.insert(index, message);
    }

    _databaseService.markMessageDelivered(messageId);
  }

  @action
  void markMessagesSeen(List<String> messageIds) {
    messageIds.forEach((id) {
      final index = chatMessages.indexWhere((m) => m.id == id);
      final message = chatMessages.removeAt(index);
      message.readReceipt = ReadReceipt.seen;
      chatMessages.insert(index, message);
    });

    _databaseService.markMessagesSeen(messageIds);
  }

  @action
  void addMessage(Message m) {
    chatMessages.insert(0, m);
  }

  @action
  void removeMessages(List<String> ids) {
    ids.forEach((id) {
      chatMessages.removeWhere((m) => m.id == id);
    });
  }

  @action
  void deleteMessages(List<String> ids) {
    removeMessages(ids);
    _databaseService.deleteMessages(ids);
  }

  @action
  void markMessagesDeleted(List<String> ids) {
    _databaseService.markMessagesDeleted(ids);
    ids.forEach((id) {
      final index = chatMessages.indexWhere((m) => m.id == id);
      if (index >= 0) {
        final message = chatMessages.removeAt(index);
        message.deleted = true;
        message.contents = "";
        chatMessages.insert(index, message);
      }
    });
  }
}
