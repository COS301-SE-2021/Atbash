import 'Contact.dart';
import 'Message.dart';

class Chat {
  final String id;
  final String contactPhoneNumber;
  final Contact? contact;
  final ChatType chatType;
  final Message? mostRecentMessage;

  Chat({
    required this.id,
    required this.contactPhoneNumber,
    this.contact,
    required this.chatType,
    this.mostRecentMessage,
  });
}

enum ChatType { general, private }
