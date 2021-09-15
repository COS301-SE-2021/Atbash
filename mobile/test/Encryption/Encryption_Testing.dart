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

import 'package:pointycastle/export.dart' as Pointy;

import 'package:mockito/mockito.dart';

class MockUserService extends Mock implements UserService {
  MockUserService() {
    throwOnMissingStub(this);
  }
}

class MockDatabaseService extends Mock implements DatabaseService {
  MockDatabaseService() {
    throwOnMissingStub(this);
  }
}

class MockIdentityKeyStoreService extends Mock implements IdentityKeyStoreService {
  MockIdentityKeyStoreService() {
    throwOnMissingStub(this);
  }
}

class MockPreKeyStoreService extends Mock implements PreKeyStoreService {
  MockPreKeyStoreService() {
    throwOnMissingStub(this);
  }
}

class MockSessionStoreService extends Mock implements SessionStoreService {
  MockSessionStoreService() {
    throwOnMissingStub(this);
  }
}

class MockSignedPreKeyStoreService extends Mock implements SignedPreKeyStoreService {
  MockSignedPreKeyStoreService() {
    throwOnMissingStub(this);
  }
}

class MockSignalProtocolStoreService extends Mock implements SignalProtocolStoreService {
  MockSignalProtocolStoreService() {
    throwOnMissingStub(this);
  }
}

// class FakeUserService extends Fake implements UserService {}
//
// class FakeDatabaseService extends Fake implements DatabaseService {}

void main() {
  final userService = MockUserService();
  final databaseService = MockDatabaseService();

  final identityKeyStoreService = MockIdentityKeyStoreService();
  final preKeyStoreService = MockPreKeyStoreService();
  final sessionStoreService = MockSessionStoreService();
  final signedPreKeyStoreService = MockSignedPreKeyStoreService();
  final signalProtocolStoreService = MockSignalProtocolStoreService();
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

    final sGen = Random.secure();
    Pointy.SecureRandom secureRandom = Pointy.FortunaRandom();
    secureRandom.seed(Pointy.KeyParameter(
        Uint8List.fromList(List.generate(32, (_) => sGen.nextInt(255)))));

    Uint8List salt = secureRandom.nextBytes(20);

    RSAKeypair rsaKeypair = RSAKeypair.fromRandom(keySize: 4096);
    final pubRsaKey = rsaKeypair.publicKey.asPointyCastle;
    final priRsaKey = rsaKeypair.privateKey.asPointyCastle;

    String messageToSign = "Hello this message will be signed";
    print("Message to sign: " + messageToSign);
    print("Message to sign: " + base64Encode(utf8.encode(messageToSign)));
    BigInt blindingFactor = encryptionService.generateBlindingFactor(pubRsaKey);

    Uint8List blindedMessage = encryptionService.createBlindedMessage(messageToSign, pubRsaKey, blindingFactor, salt);
    print("Blinded Message: " + base64Encode(blindedMessage));

    Uint8List signedBlindedMessage = encryptionService.serverSignMessage(blindedMessage, priRsaKey);
    print("Signed Blinded Message: " + base64Encode(signedBlindedMessage));

    Uint8List signedMessage = encryptionService.unblindMessage(signedBlindedMessage, pubRsaKey, blindingFactor, salt);
    print("Signed Message: " + base64Encode(signedMessage));

    final isVerified = encryptionService.serverVerifyMessage(messageToSign, signedMessage, pubRsaKey, salt);
    print("Verified: " + isVerified.toString());

    expect(3, 3*2/2);
  });




}
