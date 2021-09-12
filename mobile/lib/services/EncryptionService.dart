import 'dart:typed_data';
import 'dart:convert';

// import 'package:crypto/crypto.dart'; //For Hmac function
// import 'dart:math';

import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'package:mobile/exceptions/DecryptionErrorException.dart';
import 'package:mobile/exceptions/InvalidNumberException.dart';
import 'package:mobile/exceptions/InvalidPreKeyBundleFormat.dart';
import 'package:mobile/exceptions/PreKeyBundleFetchError.dart';
import 'package:mobile/exceptions/UnsupportedCiphertextMessageType.dart';
import 'package:mobile/constants.dart';

//Signal Imports
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';
import 'package:libsignal_protocol_dart/src/invalid_message_exception.dart';

//Encryption Imports
import 'package:mobile/encryption/DataPackages/PreKeyBundlePackage.dart';
import 'package:mobile/encryption/services/SignalProtocolStoreService.dart';
import 'package:mobile/encryption/services/IdentityKeyStoreService.dart';
import 'package:mobile/encryption/services/PreKeyStoreService.dart';
import 'package:mobile/encryption/services/SessionStoreService.dart';
import 'package:mobile/encryption/services/SignedPreKeyStoreService.dart';

import 'package:synchronized/synchronized.dart';

class EncryptionService {
  EncryptionService(
      this._signalProtocolStoreService,
      this._identityKeyStoreService,
      this._signedPreKeyStoreService,
      this._preKeyStoreService,
      this._sessionStoreService);

  final SessionStoreService _sessionStoreService;
  final PreKeyStoreService _preKeyStoreService;
  final SignedPreKeyStoreService _signedPreKeyStoreService;
  final IdentityKeyStoreService _identityKeyStoreService;
  final SignalProtocolStoreService _signalProtocolStoreService;

  final _storage = FlutterSecureStorage();

  var encryptionLock = new Lock();

  /// This method creates, serializes and returns a CipherTextMessage
  /// using the createCipherTextMessage function. The CipherTextMessage
  /// contains the encrypted message content as well other information
  /// needed by the signal algorithm
  Future<String> encryptMessageContent(
      String messageContent, String recipientNumber) async {
    ///This provides mutual exclusion for the encryptMessageContent function
    return await encryptionLock.synchronized(() async {
      final thisUserNumber = await getUserPhoneNumber();
      print("Encrypting message from: " +
          thisUserNumber +
          " to: " +
          recipientNumber);

      if (recipientNumber == thisUserNumber) {
        throw InvalidNumberException(
            "Cannot create encrypted message to self.");
      }

      print("Creating CipherTextMessage");
      CiphertextMessage ciphertext = await _createCipherTextMessage(
          recipientNumber, jsonEncode(messageContent));
      final serializedCipherMessage = ciphertext.serialize();
      final encodedSerializedCipherMessage =
          base64Encode(serializedCipherMessage);

      // return encodedSerializedCipherMessage;

      print("Created type: " + ciphertext.getType().toString());

      final mNumber = await _storage.read(key: "m_number");
      int number = 1;
      if (mNumber == null) {
        await _storage.write(key: "m_number", value: "1");
      } else {
        number = int.parse(mNumber) + 1;
        await _storage.write(key: "m_number", value: number.toString());
      }

      var data = {
        "type": ciphertext.getType(),
        "m_number": number,
        "message": encodedSerializedCipherMessage,
      };

      print("Sending message number: " +
          number.toString() +
          " Content: " +
          messageContent);

      return jsonEncode(data);
    });
  }

  /// This method takes in a serialized CipherTextMessage, decrypts it and
  /// extracts the decrypted message content using the decryptCipherTextMessage
  /// function.
  Future<String> decryptMessageContents(
      String encryptedContents, String senderPhoneNumber) async {
    ///This provides mutual exclusion for the decryptMessageContents function
    return await encryptionLock.synchronized(() async {
      final thisUserNumber = await getUserPhoneNumber();
      print("Decrypting message from: " +
          senderPhoneNumber +
          " to: " +
          thisUserNumber);
      if (senderPhoneNumber == thisUserNumber) {
        throw InvalidNumberException("Cannot decrypt own encrypted message.");
      }

      final Map<String, Object?> data = jsonDecode(encryptedContents);

      int mType = data["type"] as int;
      int mNumber = data["m_number"] as int;
      encryptedContents = data["message"] as String;

      print("Decrypting message number: " + mNumber.toString());
      print("Decrypting message type: " + mType.toString());

      String plaintext = "Failed to decrypt...";
      try {
        print("Decrypting CipherTextMessage");
        final decodedEncryptedContents = base64Decode(encryptedContents);
        // print("Encrypted contents as list: " + decodedEncryptedContents.toString());

        CiphertextMessage? reconstructedCipherMessage;
        print("Trying to reconstruct CipherTextMessage");
        if (mType == CiphertextMessage.prekeyType) {
          reconstructedCipherMessage =
              PreKeySignalMessage(decodedEncryptedContents);
        } else if (mType == CiphertextMessage.whisperType) {
          reconstructedCipherMessage =
              SignalMessage.fromSerialized(decodedEncryptedContents);
        } else {
          print("Failed");
          return plaintext;
        }
        plaintext = await _decryptCipherTextMessage(
            senderPhoneNumber, reconstructedCipherMessage);

        return jsonDecode(plaintext);
      } on InvalidMessageException catch (e) {
        throw DecryptionErrorException(e.detailMessage);
      }
    });
  }

  /// This method creates a CipherTextMessage using the Signal library
  Future<CiphertextMessage> _createCipherTextMessage(
      String number, String plaintext) async {
    final SignalProtocolAddress address = SignalProtocolAddress(number, 1);

    if (!(await _signalProtocolStoreService.containsSession(address))) {
      print("Session for \"" + number + "\" not found. Creating new session.");
      await createSession(address);
    }

    var sessionCipher = SessionCipher(_sessionStoreService, _preKeyStoreService,
        _signedPreKeyStoreService, _identityKeyStoreService, address);

    print("Encrypting plaintext with session");
    final ciphertext =
        await sessionCipher.encrypt(Uint8List.fromList(utf8.encode(plaintext)));

    return ciphertext;
  }

  /// This method decrypts and extracts the plaintext from a CipherTextMessage
  /// using the Signal library
  Future<String> _decryptCipherTextMessage(
      String number, CiphertextMessage ciphertext) async {
    final SignalProtocolAddress address = SignalProtocolAddress(number, 1);

    //Note: New session is created automatically
    var sessionCipher =
        SessionCipher.fromStore(_signalProtocolStoreService, address);

    //Todo: Handle this:
    ///Both methods below throw "InvalidMessageException" and "DuplicateMessageException"
    if (ciphertext.getType() == CiphertextMessage.prekeyType) {
      //Prekey signal message
      print("Message is PreKeySignalMessage");
      final plaintextEncoded =
          await sessionCipher.decrypt(ciphertext as PreKeySignalMessage);
      final plaintext = utf8.decode(plaintextEncoded);
      print("Decrypted plaintext: " + plaintext);

      return plaintext;
    } else if (ciphertext.getType() == CiphertextMessage.whisperType) {
      //Todo: Handle this
      /// This throws "NoSessionException"
      /// Need to handle this!!!
      //Plain signal message
      print("Message is plain SignalMessage");
      final plaintextEncoded =
          await sessionCipher.decryptFromSignal(ciphertext as SignalMessage);
      final plaintext = utf8.decode(plaintextEncoded);

      return plaintext;
    } else if (ciphertext.getType() == CiphertextMessage.senderKeyType) {
      throw UnsupportedCiphertextMessageType(
          "The CiphertextMessage of type \"senderKeyType\" is not supported. \nGroup messaging may be supported in the future.");
    } else if (ciphertext.getType() ==
        CiphertextMessage.senderKeyDistributionType) {
      throw UnsupportedCiphertextMessageType(
          "The CiphertextMessage of type \"senderKeyDistributionType\" is not supported. \nGroup messaging may be supported in the future.");
    } else {
      //There shouldn't be any other types
      throw UnsupportedCiphertextMessageType(
          "The CiphertextMessage with the type \"$ciphertext.getType()\" is not supported.");
    }
  }

  /// This method generates the initial batch of keypairs needed for the Signal
  /// algorithm and stores the keys in the database
  Future<void> generateInitialKeyBundle(int registrationId) async {
    var identityKeyPair = generateIdentityKeyPair();

    var preKeys = generatePreKeys(0, 110);

    var signedPreKey = generateSignedPreKey(identityKeyPair, 0);

    _identityKeyStoreService.setIdentityKPRegistrationId(
        identityKeyPair, registrationId);

    for (var p in preKeys) {
      await _preKeyStoreService.storePreKey(p.id, p);
    }
    await _signedPreKeyStoreService.storeSignedPreKey(
        signedPreKey.id, signedPreKey);
    await _signedPreKeyStoreService.storeLocalSignedPreKeyID(signedPreKey.id);

    ///Store registrationId in FlutterSecureStorage??
    ///Store max pre key index in FlutterSecureStorage??
  }

  /// This method downloads the PreKeyBundle from the server for a particular number
  Future<PreKeyBundle?> getPreKeyBundle(String number) async {
    final url = Uri.parse(Constants.httpUrl + "keys/get");

    final authTokenEncoded = await getDeviceAuthTokenEncoded();

    final phoneNumber = await getUserPhoneNumber();

    var data = {
      //Todo: Implement Authorization header and place this there instead
      "authorization": "Bearer $authTokenEncoded",
      "phoneNumber": phoneNumber,
      "recipientNumber": number
    };

    // final response = await http.post(url, body: jsonEncode(data), headers: {"Authorization": "Basic $authTokenEncoded"});
    final response = await http.post(url, body: jsonEncode(data));

    if (response.statusCode == 200) {
      PreKeyBundlePackage preKeyBundlePackage;
      print("Received PKBundle. Body: " + response.body);

      try {
        preKeyBundlePackage =
            PreKeyBundlePackage.fromJson(jsonDecode(response.body));
      } catch (error) {
        print(
            "Receive incorrectly formatted PreKeyBundle from server for number: $number. Error: " +
                error.toString() +
                ". Recieved body: " +
                response.body);
        throw new InvalidPreKeyBundleFormat(
            "Receive incorrectly formatted PreKeyBundle from server for number: $number. Error: " +
                error.toString() +
                ". Recieved body: " +
                response.body);
      }

      PreKeyBundle preKeyBundle = preKeyBundlePackage.createPreKeyBundle();

      print("Returning created PKBundle");
      return preKeyBundle;
    } else {
      print("Server request was unsuccessful.\nResponse code: " +
          response.statusCode.toString() +
          ".\nReason: " +
          response.body);
      throw new PreKeyBundleFetchError(
          "Server request was unsuccessful.\nResponse code: " +
              response.statusCode.toString() +
              ".\nReason: " +
              response.body);
      //return null;
    }
  }

  /// This method creates a new Signal session using the Signal library
  Future<void> createSession(SignalProtocolAddress address) async {
    PreKeyBundle? preKeyBundle =
        await getPreKeyBundle(address.getName()); //Name == number

    if (preKeyBundle != null) {
      print("Building new session.");
      var sessionBuilder = SessionBuilder(
          _sessionStoreService,
          _preKeyStoreService,
          _signedPreKeyStoreService,
          _identityKeyStoreService,
          address);

      print("Processing preKeyBundle.");
      await sessionBuilder.processPreKeyBundle(preKeyBundle);
    } else {
      throw Exception("Error in createSession method");
    }
  }

  /// Get the phone_number of the user from secure storage. If it is not set,
  /// the function throws a [StateError], since the phone_number of a logged-in
  /// user is expected to be saved.
  Future<String> getUserPhoneNumber() async {
    final phoneNumber = await _storage.read(key: "phone_number");
    if (phoneNumber == null) {
      throw StateError("phone_number is not readable");
    } else {
      return phoneNumber;
    }
  }

  /// This method gets the users IdentityKeyPair
  Future<IdentityKeyPair> getIdentityKeyPair() async {
    return await _identityKeyStoreService.getIdentityKeyPair();
  }

  /// This method gets the users LocalSignedPreKey
  Future<SignedPreKeyRecord?> fetchLocalSignedPreKey() async {
    int? id = await _signedPreKeyStoreService.fetchLocalSignedPreKeyID();
    if (id == null) return null;
    return await _signedPreKeyStoreService.loadSignedPreKey(id);
  }

  /// This method gets the users PreKeys
  Future<List<PreKeyRecord>> loadPreKeys() async {
    return await _preKeyStoreService.loadPreKeys();
  }

  /// Get the device_authentication_token_base64 of the device from secure storage. If it is not set,
  /// the function throws a [StateError], since the device_authentication_token_base64 is generated
  /// during registration and is expected to be saved.
  Future<String> getDeviceAuthTokenEncoded() async {
    final token =
        await _storage.read(key: "device_authentication_token_base64");
    if (token == null) {
      throw StateError("device_authentication_token_base64 is not readable");
    } else {
      return token;
    }
  }
}
