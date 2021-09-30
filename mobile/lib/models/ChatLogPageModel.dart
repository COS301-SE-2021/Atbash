import 'package:mobile/domain/ChildChat.dart';
import 'package:mobx/mobx.dart';

part 'ChatLogPageModel.g.dart';

class ChatLogPageModel = _ChatLogPageModel with _$ChatLogPageModel;

abstract class _ChatLogPageModel with Store {
  @observable
  String childPhoneNumber = "";

  @observable
  String childName = "";

  @observable
  List<ChildChat> chats = <ChildChat>[].asObservable();

  @computed
  List<ChildChat> get sortedChats {
    List<ChildChat> chatCopy = List.of(chats);
    chatCopy.sort((a, b) => _compareNames(a, b));
    return chatCopy;
  }
  
  int _compareNames(ChildChat a, ChildChat b){
    final aName = a.otherPartyName;
    final bName = b.otherPartyName;
    
    if(aName != null && bName != null){
      return aName.compareTo(bName);
    }else if(aName != null && bName == null){
      return -1;
    }else if(aName == null && bName != null){
      return 1;
    }else{
      return a.otherPartyNumber.compareTo(b.otherPartyNumber);
    }
  }
}
