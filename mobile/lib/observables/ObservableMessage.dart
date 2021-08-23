import 'package:mobile/domain/Message.dart';
import 'package:mobile/observables/ObservableTag.dart';
import 'package:mobx/mobx.dart';

part 'ObservableMessage.g.dart';

class ObservableMessage = _ObservableMessage with _$ObservableMessage;

abstract class _ObservableMessage with Store {
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

  _ObservableMessage(Message m)
      : id = m.id,
        senderPhoneNumber = m.senderPhoneNumber,
        recipientPhoneNumber = m.recipientPhoneNumber,
        contents = m.contents,
        timestamp = m.timestamp,
        readReceipt = m.readReceipt,
        deleted = m.deleted,
        liked = m.liked,
        tags = m.tags.map((e) => ObservableTag(e)).toList().asObservable();
}
