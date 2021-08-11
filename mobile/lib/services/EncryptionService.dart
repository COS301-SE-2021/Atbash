import 'dart:convert';

import 'package:cryptography/cryptography.dart';

class EncryptionService {
  final algorithm = Cryptography.instance.aesCtr(macAlgorithm: Hmac.sha256());

  Future<String> encrypt(String message, String base64SharedSecret) async {
    final sharedSecret = SecretKeyData(base64Decode(base64SharedSecret));

    final encrypted =
        await algorithm.encrypt(message.codeUnits, secretKey: sharedSecret);

    return String.fromCharCodes(encrypted.concatenation());
  }

  Future<String> decrypt(String message, String base64SharedSecret) async {
    final sharedSecret = SecretKeyData(base64Decode(base64SharedSecret));

    final encrypted = SecretBox.fromConcatenation(message.codeUnits,
        nonceLength: 16, macLength: 32);

    final decrypted =
        await algorithm.decrypt(encrypted, secretKey: sharedSecret);

    return String.fromCharCodes(decrypted);
  }
}
