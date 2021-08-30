import 'package:mobile/domain/Message.dart';
import 'package:mobx/mobx.dart';

part 'ChatPageModel.g.dart';

class ChatPageModel = _ChatPageModel with _$ChatPageModel;

abstract class _ChatPageModel with Store {
  @observable
  String contactTitle = "";

  @observable
  String contactStatus = "";

  @observable
  String contactProfileImage = "";

  @observable
  ObservableList<Message> messages = <Message>[].asObservable();

  @action
  void addMessage(Message message) {
    messages.insert(0, message);
  }

  @action
  void replaceMessages(Iterable<Message> messages) {
    this.messages.clear();
    this.messages.addAll(messages);
  }

  @action
  void removeMessageById(String messageId) {
    messages.removeWhere((message) => message.id == messageId);
  }

  @action
  void setReadReceiptById(String messageId, ReadReceipt readReceipt) {
    messages.where((message) => message.id == messageId).forEach((message) {
      message.readReceipt = readReceipt;
    });
  }

  @action
  void setDeletedById(String messageId) {
    messages.where((message) => message.id == messageId).forEach((message) {
      message.deleted = true;
      message.contents = "";
    });
  }
}
