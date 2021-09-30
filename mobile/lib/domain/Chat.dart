import 'package:mobx/mobx.dart';

import 'Contact.dart';
import 'Message.dart';

part 'Chat.g.dart';

class Chat extends _Chat with _$Chat {
  Chat({
    required String id,
    required String contactPhoneNumber,
    Contact? contact,
    required ChatType chatType,
    Message? mostRecentMessage,
  }) : super(
          id: id,
          contactPhoneNumber: contactPhoneNumber,
          contact: contact,
          chatType: chatType,
          mostRecentMessage: mostRecentMessage,
        );

  Map<String, Object?> toMap() {
    return {
      COLUMN_ID: id,
      COLUMN_CONTACT_PHONE_NUMBER: contactPhoneNumber,
      COLUMN_CHAT_TYPE: chatType.index,
      COLUMN_RECENT_MESSAGE_ID: mostRecentMessage?.id,
    };
  }

  Map toJson() => {
        'id': id,
        'contactPhoneNumber': contactPhoneNumber,
        'contact': this.contact != null ? this.contact?.toJson() : null,
        'chatType': chatType.toString(),
        'mostRecentMessage':
            mostRecentMessage != null ? mostRecentMessage?.toJson() : null
      };

  static Chat? fromMap(Map<String, Object?> map) {
    final id = map[COLUMN_ID] as String?;
    final contactPhoneNumber = map[COLUMN_CONTACT_PHONE_NUMBER] as String?;
    final contact = Contact.fromMap(map);
    final chatType = map[COLUMN_CHAT_TYPE] as int?;
    final mostRecentMessage = Message.fromMap(map);

    if (id != null && contactPhoneNumber != null && chatType != null) {
      return Chat(
        id: id,
        contactPhoneNumber: contactPhoneNumber,
        contact: contact,
        chatType: ChatType.values[chatType],
        mostRecentMessage: mostRecentMessage,
      );
    }
  }

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

abstract class _Chat with Store {
  final String id;

  final String contactPhoneNumber;

  @observable
  Contact? contact;

  final ChatType chatType;

  @observable
  Message? mostRecentMessage;

  _Chat({
    required this.id,
    required this.contactPhoneNumber,
    this.contact,
    required this.chatType,
    this.mostRecentMessage,
  });
}

enum ChatType { general, private }
