import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:mobile/constants.dart';
import 'package:mobile/domain/Chat.dart';
import 'package:mobile/domain/Contact.dart';
import 'package:mobile/domain/Message.dart';
import 'package:mobile/models/ContactsPageModel.dart';
import 'package:mobile/services/ChatService.dart';
import 'package:mobile/services/CommunicationService.dart';
import 'package:mobile/services/ContactService.dart';
import 'package:mobile/util/Utils.dart';
import 'package:uuid/uuid.dart';

class ContactsPageController {
  final CommunicationService communicationService = GetIt.I.get();
  final ContactService contactService = GetIt.I.get();
  final ChatService chatService = GetIt.I.get();

  final ContactsPageModel model = ContactsPageModel();

  ContactsPageController() {
    contactService.onChanged(reload);
    reload();
  }

  void dispose() {
    contactService.disposeOnChanged(reload);
  }

  void deleteContact(String phoneNumber) {
    model.removeContact(phoneNumber);
    contactService.deleteByPhoneNumber(phoneNumber);
  }

  Future<void> addContact(
      BuildContext context, String number, String name) async {
    final response =
        await get(Uri.parse(Constants.httpUrl + "user/$number/exists"));

    if (response.statusCode == 204) {
      Contact contact = new Contact(
          phoneNumber: number, displayName: name, status: "", profileImage: "");
      await contactService.insert(contact);
      model.addContact(contact);
      communicationService.sendRequestStatus(number);
      communicationService.sendRequestProfileImage(number);
      communicationService.sendRequestBirthday(number);
    } else {
      showSnackBar(context, "No user with phone number $number exists");
    }
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
