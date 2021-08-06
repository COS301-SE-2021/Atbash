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
  void addMessage(Message m) {
    chatMessages.insert(0, m);
  }
}
