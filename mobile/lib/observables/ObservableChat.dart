import 'package:mobile/domain/Chat.dart';
import 'package:mobile/domain/Contact.dart';
import 'package:mobile/domain/Message.dart';
import 'package:mobx/mobx.dart';

part 'ObservableChat.g.dart';

class ObservableChat = _ObservableChat with _$ObservableChat;

abstract class _ObservableChat with Store {
  final String id;

  final String contactPhoneNumber;

  @observable
  Contact? contact;

  final ChatType chatType;

  @observable
  Message? mostRecentMessage;

  _ObservableChat(Chat c)
      : this.id = c.id,
        this.contactPhoneNumber = c.contactPhoneNumber,
        this.contact = c.contact,
        this.chatType = c.chatType,
        this.mostRecentMessage = c.mostRecentMessage;
}

extension ChatExtension on Chat {
  ObservableChat asObservable() {
    return ObservableChat(this);
  }
}
