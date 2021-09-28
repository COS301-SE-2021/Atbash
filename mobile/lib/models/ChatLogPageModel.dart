import 'package:mobile/domain/ChildChat.dart';
import 'package:mobx/mobx.dart';

part 'ChatLogPageModel.g.dart';

class ChatLogPageModel = _ChatLogPageModel with _$ChatLogPageModel;

abstract class _ChatLogPageModel with Store {
  @observable
  String childName = "";

  @observable
  List<ChildChat> chats = <ChildChat>[].asObservable();
}