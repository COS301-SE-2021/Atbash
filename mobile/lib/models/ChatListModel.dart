import 'package:mobile/domain/Chat.dart';
import 'package:mobile/domain/Contact.dart';
import 'package:mobile/domain/Message.dart';
import 'package:mobile/observables/ObservableChat.dart';
import 'package:mobx/mobx.dart';

part 'ChatListModel.g.dart';

class ChatListModel = _ChatListModel with _$ChatListModel;

abstract class _ChatListModel with Store {
  @observable
  ObservableList<ObservableChat> chats = <ObservableChat>[].asObservable();

  @action
  void startChatWithContact(Contact contact, ChatType chatType) {}

  @action
  void startChatWithPhoneNumber(String phoneNumber, ChatType chatType) {}

  @action
  void deleteChat(String id) {}

  @action
  void setChatContact(Contact contact) {}

  @action
  void setChatMostRecentMessage(Message message) {}
}
