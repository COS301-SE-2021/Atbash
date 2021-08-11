import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class KeyGenService {
  final _storage = FlutterSecureStorage();

  Future<String> generateSharedSecret(String base64RemotePublicKey) async {
    final remotePublicKey = SimplePublicKey(
      base64Decode(base64RemotePublicKey),
      type: KeyPairType.x25519,
    );

    final algorithm = Cryptography.instance.x25519();
    final sharedSecretKey = await algorithm.sharedSecretKey(
      keyPair: await _getLocalKeyPair(),
      remotePublicKey: remotePublicKey,
    );

    return base64Encode(await sharedSecretKey.extractBytes());
  }

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

  Future<SimpleKeyPair> _getLocalKeyPair() async {
    final keys = await Future.wait([
      _storage.read(key: "public_key"),
      _storage.read(key: "key_pair"),
    ]);

    final base64PublicKey = keys[0];
    final base64KeyPair = keys[1];

    if (base64PublicKey == null || base64KeyPair == null) {
      throw StateError("_getLocalKeyPair called when local keys not saved");
    }

    final publicKey = SimplePublicKey(
      base64Decode(base64PublicKey),
      type: KeyPairType.x25519,
    );

    return SimpleKeyPairData(
      base64Decode(base64KeyPair),
      publicKey: publicKey,
      type: KeyPairType.x25519,
    );
  }

  Future<String> _getPublicKeyString(SimpleKeyPair keyPair) async {
    return base64Encode((await keyPair.extractPublicKey()).bytes);
  }

  Future<String> _getKeyPairString(SimpleKeyPair keyPair) async {
    return base64Encode((await keyPair.extract()).bytes);
  }
}
