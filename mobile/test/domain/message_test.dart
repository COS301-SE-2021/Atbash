import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/domain/Message.dart';

void main() {
  test("Message encodeBody", () {
    final message = Message("123", "456", "Contents of the message");

    final encodedBody = message.encodeBody();

    final deserializedEncodedBody = jsonDecode(encodedBody);

    expect(deserializedEncodedBody["from"], "123");
    expect(deserializedEncodedBody["message"], "Contents of the message");
  });
}
