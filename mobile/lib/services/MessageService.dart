import 'package:get_it/get_it.dart';
import 'package:mobile/domain/Contact.dart';
import 'package:mobile/domain/Message.dart';
import 'package:mobile/services/DatabaseAccess.dart';

class MessageService {
  final db = GetIt.I.get<DatabaseAccess>();
  final Contact _contact;
  List<Message> _messages = [];
  List<void Function(List<Message>)> _newMessageListeners = [];

  MessageService(this._contact) {
    db.getChatWithContact(_contact.phoneNumber).then((messages) {
      this._messages = messages;
      _notifyNewMessageListeners(_messages);
    });
  }

  void sendMessage(String from, String to, String contents) {
    final message = db.saveMessage(from, to, contents);
    _addMessage(message);
  }

  void _addMessage(Message m) {
    _messages.add(m);
    _notifyNewMessageListeners([m]);
  }

  void deleteMessage(Message m) {
    _messages.remove(m);
    db.deleteMessage(m.id);
  }

  void listenForNewMessages(void Function(List<Message>) cb) {
    _newMessageListeners.add(cb);
  }

  void _notifyNewMessageListeners(List<Message> of) {
    _newMessageListeners.forEach((listener) {
      listener(of);
    });
  }
}
