import 'package:mobile/domain/Message.dart';
import 'package:mobile/observables/ObservableTag.dart';
import 'package:mobx/mobx.dart';

part 'ObservableMessage.g.dart';

class ObservableMessage = _ObservableMessage with _$ObservableMessage;

abstract class _ObservableMessage with Store {
  final Message message;

  final String id;

  final String senderPhoneNumber;

  final String recipientPhoneNumber;

  @observable
  String contents;

  final DateTime timestamp;

  @observable
  ReadReceipt readReceipt;

  @observable
  bool deleted;

  @observable
  bool liked;

  @observable
  ObservableList<ObservableTag> tags;

  _ObservableMessage(this.message)
      : id = message.id,
        senderPhoneNumber = message.senderPhoneNumber,
        recipientPhoneNumber = message.recipientPhoneNumber,
        contents = message.contents,
        timestamp = message.timestamp,
        readReceipt = message.readReceipt,
        deleted = message.deleted,
        liked = message.liked,
        tags =
            message.tags.map((e) => ObservableTag(e)).toList().asObservable();
}

extension MessageExtension on Message {
  ObservableMessage asObservable() {
    return ObservableMessage(this);
  }
}
