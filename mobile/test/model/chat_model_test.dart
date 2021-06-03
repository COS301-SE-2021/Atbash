import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/domain/Chat.dart';
import 'package:mobile/model/ChatModel.dart';

void main() {
  test("New message should be sent and recieved", () {
    final Chat chat = Chat();

    final chatModel = ChatModel(chat);

    chatModel.addMessage("", "any", "message");
    expect(2, chatModel.messages.length);
  });

  test("Empty string sent, no messages should be sent or received", () {
    final Chat chat = Chat();

    final chatModel = ChatModel(chat);

    chatModel.addMessage("", "any", "");
    expect(0, chatModel.messages.length);
  });

  test("String with only spaces sent, no messages should be sent or received",
      () {
    final Chat chat = Chat();

    final chatModel = ChatModel(chat);

    chatModel.addMessage("", "any", "    ");
    expect(0, chatModel.messages.length);
  });

  test(
      "String with only spaces and newlines sent, no messages should be sent or received",
      () {
    final Chat chat = Chat();

    final chatModel = ChatModel(chat);

    chatModel.addMessage("", "any", " \n \n ");
    expect(0, chatModel.messages.length);
  });

  test("String with only newlines sent, no messages should be sent or received",
      () {
    final Chat chat = Chat();

    final chatModel = ChatModel(chat);

    chatModel.addMessage("", "any", "\n\n");
    expect(0, chatModel.messages.length);
  });
}
