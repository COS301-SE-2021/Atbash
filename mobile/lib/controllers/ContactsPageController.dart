import 'package:get_it/get_it.dart';
import 'package:mobile/domain/Chat.dart';
import 'package:mobile/domain/Contact.dart';
import 'package:mobile/domain/Message.dart';
import 'package:mobile/models/ContactsPageModel.dart';
import 'package:mobile/services/ChatService.dart';
import 'package:mobile/services/ContactService.dart';
import 'package:uuid/uuid.dart';

class ContactsPageController {
  final ContactService contactService = GetIt.I.get();
  final ChatService chatService = GetIt.I.get();

  final ContactsPageModel model = ContactsPageModel();

  ContactsPageController() {
    reload();
  }

  void deleteContact(String phoneNumber) {
    model.removeContact(phoneNumber);
    contactService.deleteByPhoneNumber(phoneNumber);
  }

  void addContact(String number, String name) {
    //TODO Request status & profile image.
    Contact contact = new Contact(
        phoneNumber: number, displayName: name, status: "", profileImage: "");
    model.addContact(contact);
    contactService.insert(contact);
  }

  Future<Chat> startChat(Contact contact, ChatType chatType,
      {String? id, Message? mostRecentMessage}) async {
    final chats = await chatService.fetchAll();
    final index = chats.indexWhere((element) =>
        element.contactPhoneNumber == contact.phoneNumber &&
        element.chatType == chatType);
    if (index != -1) {
      return chats[index];
    }

    final chat = Chat(
        id: id ?? Uuid().v4(),
        contactPhoneNumber: contact.phoneNumber,
        contact: contact,
        mostRecentMessage: mostRecentMessage,
        chatType: chatType);

    chatService.insert(chat);
    return chat;
  }

  void reload() {
    contactService.fetchAll().then((contactList) {
      model.replaceContacts(contactList);
    });
  }
}
