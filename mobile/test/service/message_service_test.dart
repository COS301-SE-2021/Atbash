import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/service/MessageService.dart';

void main() {
  test("sendMessage returns message", () {
    final messageService = MessageService();

    final message = messageService.sendMessage("123", "456", "mock contents");

    expect(message.from, "123");
    expect(message.to, "456");
    expect(message.contents, "mock contents");
  });
}
