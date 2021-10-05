import 'package:mobile/domain/Chat.dart';
import 'package:mobile/domain/Message.dart';
import 'package:mobile/domain/ProfanityWord.dart';
import 'package:mobx/mobx.dart';

part 'ChatPageModel.g.dart';

class ChatPageModel = _ChatPageModel with _$ChatPageModel;

abstract class _ChatPageModel with Store {
  @observable
  String contactTitle = "";

  @observable
  List<ProfanityWord> profanityWords = <ProfanityWord>[].asObservable();

  @observable
  bool online = false;

  @observable
  String contactStatus = "";

  @observable
  String? wallpaperImage;

  @observable
  String contactProfileImage = "";

  @observable
  bool contactSaved = false;

  @observable
  ChatType chatType = ChatType.private;

  @observable
  bool blurImages = true;

  @observable
  bool profanityFilter = true;

  @observable
  bool privateChatAccess = true;

  @observable
  bool blockSaveMedia = false;

  @observable
  bool blockEditingMessages = false;

  @observable
  bool blockDeletingMessages = false;

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
      if (message.readReceipt == ReadReceipt.undelivered ||
          (message.readReceipt == ReadReceipt.delivered &&
              readReceipt == ReadReceipt.seen)) {
        message.readReceipt = readReceipt;
      }
    });
  }

  @action
  void setDeletedById(String messageId) {
    messages.where((message) => message.id == messageId).forEach((message) {
      message.deleted = true;
      message.contents = "";
    });
  }

  @action
  void setLikedById(String messageID, bool liked) {
    messages.where((message) => message.id == messageID).forEach((message) {
      message.liked = liked;
    });
  }

  @action
  void setEditedById(String messageID, String newMessage) {
    messages.where((message) => message.id == messageID).forEach((message) {
      message.edited = true;
      message.contents = newMessage;
    });
  }
}
