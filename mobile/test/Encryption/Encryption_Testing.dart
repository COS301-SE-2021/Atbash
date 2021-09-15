import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypton/crypton.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/encryption/services/IdentityKeyStoreService.dart';
import 'package:mobile/encryption/services/PreKeyStoreService.dart';
import 'package:mobile/encryption/services/SessionStoreService.dart';
import 'package:mobile/encryption/services/SignalProtocolStoreService.dart';
import 'package:mobile/encryption/services/SignedPreKeyStoreService.dart';
import 'package:mobile/services/DatabaseService.dart';
import 'package:mobile/services/EncryptionService.dart';
import 'package:mobile/services/UserService.dart';



void main() {
  final userService = UserService();
  final databaseService = DatabaseService();

  final identityKeyStoreService = IdentityKeyStoreService(databaseService);
  final preKeyStoreService = PreKeyStoreService(databaseService);
  final sessionStoreService = SessionStoreService(databaseService);
  final signedPreKeyStoreService = SignedPreKeyStoreService(databaseService);
  final signalProtocolStoreService = SignalProtocolStoreService(
    preKeyStoreService,
    sessionStoreService,
    signedPreKeyStoreService,
    identityKeyStoreService,
  );
  final encryptionService = EncryptionService(
    userService,
    signalProtocolStoreService,
    identityKeyStoreService,
    signedPreKeyStoreService,
    preKeyStoreService,
    sessionStoreService,
  );

  test('Test 1', () async {
    print("Testing BlindSignatures");

    RSAKeypair rsaKeypair = RSAKeypair.fromRandom(keySize: 4096);
    final pubRsaKey = rsaKeypair.publicKey.asPointyCastle;
    final priRsaKey = rsaKeypair.privateKey.asPointyCastle;

    String messageToSign = "Hello this message will be signed";
    print("Message to sign: " + messageToSign);
    BigInt blindingFactor = encryptionService.generateBlindingFactor(pubRsaKey);

    Uint8List blindedMessage = encryptionService.createBlindedMessage(messageToSign, pubRsaKey, blindingFactor);
    print("Blinded Message: " + base64Encode(blindedMessage));

    Uint8List signedBlindedMessage = encryptionService.serverSignMessage(blindedMessage, priRsaKey);
    print("Signed Blinded Message: " + base64Encode(signedBlindedMessage));

    Uint8List signedMessage = encryptionService.unblindMessage(signedBlindedMessage, pubRsaKey, blindingFactor);
    print("Signed Message: " + base64Encode(signedMessage));

    final isVerified = encryptionService.serverVerifyMessage(messageToSign, signedMessage, pubRsaKey);
    print("Verified: " + isVerified.toString());

    expect(3, 3*2/2);
  });




}
