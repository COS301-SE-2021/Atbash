import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class KeyGenService {
  final _storage = FlutterSecureStorage();

  void generateAndSaveKeyPair() async {
    final algorithm = Cryptography.instance.x25519();
    final keyPair = await algorithm.newKeyPair();

    final keys = await Future.wait([
      _getPublicKeyString(keyPair),
      _getKeyPairString(keyPair),
    ]);

    await Future.wait([
      _storage.write(key: "public_key", value: keys[0]),
      _storage.write(key: "key_pair", value: keys[1])
    ]);
  }

  Future<String> _getPublicKeyString(SimpleKeyPair keyPair) async {
    return base64Encode((await keyPair.extractPublicKey()).bytes);
  }

  Future<String> _getKeyPairString(SimpleKeyPair keyPair) async {
    return base64Encode((await keyPair.extract()).bytes);
  }
}
