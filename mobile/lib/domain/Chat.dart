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

  static const String TABLE_NAME = "chat";
  static const String COLUMN_ID = "chat_id";
  static const String COLUMN_CONTACT_PHONE_NUMBER = "chat_contact_phone_number";
  static const String COLUMN_CHAT_TYPE = "chat_type";
  static const String COLUMN_RECENT_MESSAGE_ID = "chat_recent_message_id";
  static const String CREATE_TABLE = "create table $TABLE_NAME ("
      "$COLUMN_ID text primary key,"
      "$COLUMN_CONTACT_PHONE_NUMBER text not null,"
      "$COLUMN_CHAT_TYPE int not null,"
      "$COLUMN_RECENT_MESSAGE_ID text"
      ");";
}

enum ChatType { general, private }
