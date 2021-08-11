import 'dart:convert';

import 'package:cryptography/cryptography.dart';

class EncryptionService {
  final algorithm = Cryptography.instance.aesCtr(macAlgorithm: Hmac.sha256());

  Future<String> encrypt(String plainText, String base64SharedSecret) async {
    final sharedSecret = SecretKeyData(base64Decode(base64SharedSecret));

    final encrypted =
        await algorithm.encrypt(plainText.codeUnits, secretKey: sharedSecret);

    return String.fromCharCodes(encrypted.concatenation());
  }

  Future<String> decrypt(
      String encryptedText, String base64SharedSecret) async {
    final sharedSecret = SecretKeyData(base64Decode(base64SharedSecret));

    final encrypted = SecretBox.fromConcatenation(encryptedText.codeUnits,
        nonceLength: 16, macLength: 32);

    final decrypted =
        await algorithm.decrypt(encrypted, secretKey: sharedSecret);

    return String.fromCharCodes(decrypted);
  }
}
