import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/domain/Chat.dart';
import 'package:mobile/services/ChatService.dart';
import 'package:mobile/services/ContactService.dart';
import 'package:mobile/services/MessageService.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mobile/domain/Contact.dart';

import 'AnalyticsPage_test.mocks.dart';

@GenerateMocks([ContactService, MessageService, ChatService])
void main() {
  final contactService = MockContactService();
  final messageService = MockMessageService();
  final chatService = MockChatService();

  GetIt.I.registerSingleton<ContactService>(contactService);
  GetIt.I.registerSingleton<MessageService>(messageService);
  GetIt.I.registerSingleton<ChatService>(chatService);

  setUpAll(() {
    when(chatService.fetchByChatType(any)).thenAnswer((_) => Future.value([
          Chat(
              id: "123",
              contactPhoneNumber: "0837772222",
              contact: Contact(
                  phoneNumber: "0837772222",
                  displayName: "John",
                  profileImage: "",
                  status: "Hi"),
              chatType: ChatType.general),
          Chat(
              id: "456",
              contactPhoneNumber: "0721233413",
              contact: Contact(
                  phoneNumber: "0721233413",
                  displayName: "Liam",
                  profileImage: "",
                  status: "New to Atbash"),
              chatType: ChatType.general),
          Chat(
              id: "789",
              contactPhoneNumber: "0836006179",
              contact: Contact(
                  phoneNumber: "0836006179",
                  displayName: "Dylan",
                  profileImage: "",
                  status: "Yum"),
              chatType: ChatType.general)
        ]));
  });
}
