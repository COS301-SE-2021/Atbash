import 'package:mobile/domain/Chat.dart';
import 'package:mobx/mobx.dart';

import 'ObservableContact.dart';
import 'ObservableMessage.dart';

part 'ObservableChat.g.dart';

class ObservableChat = _ObservableChat with _$ObservableChat;

abstract class _ObservableChat with Store {
  final Chat chat;

  final String id;

  final String contactPhoneNumber;

  @observable
  ObservableContact? contact;

  final ChatType chatType;

  @observable
  ObservableMessage? mostRecentMessage;

  _ObservableChat(this.chat)
      : this.id = chat.id,
        this.contactPhoneNumber = chat.contactPhoneNumber,
        this.contact = chat.contact?.asObservable(),
        this.chatType = chat.chatType,
        this.mostRecentMessage = chat.mostRecentMessage?.asObservable();
}

extension ChatExtension on Chat {
  ObservableChat asObservable() {
    return ObservableChat(this);
  }
}
