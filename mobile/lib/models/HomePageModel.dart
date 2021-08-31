import 'dart:typed_data';

import 'package:mobile/domain/Chat.dart';
import 'package:mobx/mobx.dart';

part 'HomePageModel.g.dart';

class HomePageModel = _HomePageModel with _$HomePageModel;

abstract class _HomePageModel with Store {
  @observable
  String userDisplayName = "";

  @observable
  String userStatus = "";

  @observable
  Uint8List? userProfileImage;

  @observable
  ObservableList<Chat> chats = <Chat>[].asObservable();

  @action
  void addChat(Chat chat) {
    chats.add(chat);
  }

  @action
  void replaceChats(Iterable<Chat> chats) {
    this.chats.clear();
    this.chats.addAll(chats);
  }

  @action
  void removeChat(String chatId) {
    this.chats.removeWhere((chat) => chat.id == chatId);
  }
}
