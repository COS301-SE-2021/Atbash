import 'dart:convert';
import 'dart:typed_data';

import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:mobile/constants.dart';
import 'package:mobile/domain/MessagePayload.dart';
import 'package:mobile/domain/MessageResendRequest.dart';
import 'package:mobile/encryption/FailedDecryptionCounter.dart';
import 'package:mobile/encryption/Messagebox.dart';
import 'package:mobile/encryption/MessageboxToken.dart';
import 'package:mobile/encryption/PreKeyDBRecord.dart';
import 'package:mobile/encryption/SessionDBRecord.dart';
import 'package:mobile/encryption/SignedPreKeyDBRecord.dart';
import 'package:mobile/encryption/TrustedKeyDBRecord.dart';
import 'package:mobile/exceptions/InvalidNumberException.dart';
import 'package:mobile/exceptions/RegistrationErrorException.dart';
import 'package:mobile/exceptions/VerificationErrorException.dart';
import 'package:mobile/util/Validations.dart';
import 'DatabaseService.dart';
import 'EncryptionService.dart';

import 'package:crypton/crypton.dart';
import 'package:crypto/crypto.dart'; //For Hmac function
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

import 'UserService.dart';
import 'MessageboxService.dart';

class RegistrationService {
  RegistrationService(
      this._encryptionService, this._userService, this._databaseService, this._messageboxService);

  final EncryptionService _encryptionService;
  final UserService _userService;
  final MessageboxService _messageboxService;
  final DatabaseService _databaseService;
  final _storage = FlutterSecureStorage();

  ///This method will return false if the number is already registered and
  ///true if the code was successfully created
  Future<bool> requestRegistrationCode(String phoneNumber, bool reregister) async {
    throwIfNot(
        Validations().numberIsValid(phoneNumber),
        new InvalidNumberException(
            "Invalid number provided in register method"));

    if(!reregister && (await isRegistered())){
      return false;
    } else if (await isRegistering()){
      reregister = true;
    }

    final url = Uri.parse(Constants.httpUrl + "requestRegistrationCode");

    var data = {
      "phoneNumber": phoneNumber,
      "reregister": reregister
    };

    final response = await http.post(url, body: jsonEncode(data));

    if (response.statusCode == 200){
      return true;
    } else {
      throw new RegistrationErrorException(
          "Request of Registration Code was unsuccessful: " +
              response.body);
    }
    return false;
  }



  ///This function creates a new Atbash account on the server which will be
  ///needed for linking a users phone number with their keys
  Future<bool> register(String phoneNumber, String registrationCode) async {
    final url = Uri.parse(Constants.httpUrl + "register");

    throwIfNot(
        Validations().numberIsValid(phoneNumber),
        new InvalidNumberException(
            "Invalid number provided in register method"));

    ///A MAC is used to prevent an attacker from editing the transmitted data
    ///The signalingKey contains the data for this
    final registrationId = generateRegistrationId(false);
    final aesKey = generateRandomBytes(32);
    final hmacSha256 = Hmac(sha256, aesKey);
    var signalingKeyBytesBuilder = BytesBuilder();

    ///An RSA keypair is used so that the server can generate a token
    ///(that is used to verify the authenticity of requests)
    ///and send it back encrypted
    /// See: https://stackoverflow.com/questions/59586980/encrypt-and-decrypt-from-javascript-nodejs-to-dart-flutter-and-from-dart-to/63775191
    RSAKeypair rsaKeypair =
        RSAKeypair.fromRandom(keySize: Constants.RSAKEYSIZE);
    final pubRsaKey = rsaKeypair.publicKey.asPointyCastle;

    var data = {
      "registrationId": registrationId,
      "phoneNumber": phoneNumber,
      "registrationCode": registrationCode,
      "rsaPublicKey": {
        "n": pubRsaKey.n.toString(),
        "e": pubRsaKey.publicExponent.toString()
      },
      "signalingKey": "",
    };

    final hmacKey =
        hmacSha256.convert(utf8.encoder.convert(jsonEncode(data))).bytes;

    signalingKeyBytesBuilder.add(aesKey);
    signalingKeyBytesBuilder.add(hmacKey);
    final signalingKey = base64.encode(signalingKeyBytesBuilder.toBytes());

    data["signalingKey"] = signalingKey;

    // final response = await http.put(url,
    //     body: data, headers: {"Authorization": "Basic $authTokenEncoded"});
    final response = await http.post(url, body: jsonEncode(data));

    if (response.statusCode == 200) {
      final responseBodyJson =
          jsonDecode(response.body) as Map<String, dynamic>;
      final encryptedDevicePassword = responseBodyJson["password"] as String?;
      final formattedPhoneNumber = responseBodyJson["phoneNumber"] as String?;
      if (encryptedDevicePassword == null) {
        throw new RegistrationErrorException(
            "Server response was in an invalid format. Response body: " +
                response.body);
      }
      if (formattedPhoneNumber != null) {
        phoneNumber = formattedPhoneNumber;
      }

      final base64DevicePassword =
          rsaKeypair.privateKey.decrypt(encryptedDevicePassword);
      final devicePassword = base64Decode(base64DevicePassword);

      final authTokenEncoded =
          _generateAuthenticationToken(phoneNumber, devicePassword);

      if(await isRegistering() || await isRegistered()){
        await clearEncryptionTables();
      }

      await Future.wait([
        setRegistering(),
        _storage.write(key: "registration_id", value: registrationId.toString()),
        _storage.write(
            key: "device_password_base64", value: base64DevicePassword),
        _storage.write(
            key: "device_authentication_token_base64", value: authTokenEncoded),
        _userService.setPhoneNumber(phoneNumber),
      ]);

      return true;
    } else if (response.statusCode == 400) {
      throw new VerificationErrorException("Response code: " +
          response.statusCode.toString() +
          ".\nReason: " +response.body);
    } else {
      print("Server request was unsuccessful.\nResponse code: " +
          response.statusCode.toString() +
          ".\nReason: " +
          response.body);
      throw new RegistrationErrorException(
          "Server request was unsuccessful.\nResponse code: " +
              response.statusCode.toString() +
              ".\nReason: " +
              response.body);
      //return false;
    }
  }

  ///This function is called after register to complete the registration process
  Future<bool> registerComplete() async {
    if(!(await isRegistering())){
      return false;
    }

    final registrationId = await _storage.read(key: "registration_id");

    if(registrationId == null){
      return false;
    }

    await _encryptionService.generateInitialKeyBundle(int.parse(registrationId));

    final success = await registerKeys();
    if (success) {
      await setRegistered();
      _messageboxService.getMessageboxKeys(6).then((value) => _messageboxService.getMessageboxKeys(10));
      return true;
    } else {
      return false;
    }
  }

  ///This method uploads all the generated public keys for the signal
  ///algorithm to the Atbash server
  Future<bool> registerKeys() async {
    final url = Uri.parse(Constants.httpUrl + "keys/register");

    final phoneNumber = await _userService.getPhoneNumber();
    final authTokenEncoded = await _userService.getDeviceAuthTokenEncoded();

    final identityKeyPair = await _encryptionService.getIdentityKeyPair();
    final signedPreKey = await _encryptionService.fetchLocalSignedPreKey();
    final preKeys = await _encryptionService.loadPreKeys();

    if (signedPreKey == null || preKeys.isEmpty || preKeys.length < 100) {
      return false;
    }

    RSAKeypair rsaKeypair =
        RSAKeypair.fromRandom(keySize: Constants.RSAKEYSIZE);
    await _userService.storeRSAKeyPair(rsaKeypair);

    List<Map<String, Object>> preKeysArr = [];

    for (var p in preKeys) {
      preKeysArr.add({
        "keyId": p.id,
        "publicKey": base64Encode(p.getKeyPair().publicKey.serialize())
      });
    }

    var data = {
      "authorization": "Bearer $authTokenEncoded",
      "phoneNumber": phoneNumber,
      "identityKey": base64Encode(identityKeyPair.getPublicKey().serialize()),
      "preKeys": preKeysArr,
      "rsaKey": rsaKeypair.publicKey.toString(),
      "signedPreKey": {
        "keyId": signedPreKey.id,
        "publicKey":
            base64Encode(signedPreKey.getKeyPair().publicKey.serialize()),
        "signature": base64Encode(signedPreKey.signature)
      }
    };

    // final response = await http.put(url,
    //     body: data, headers: {"Authorization": "Basic $authTokenEncoded"});
    final response = await http.post(url, body: jsonEncode(data));

    if (response.statusCode == 200) {
      await Future.wait([
        _storage.write(key: "registered", value: "1"),
      ]);

      print("Successfully registered");
      return true;
    } else {
      print("Server request was unsuccessful.\nResponse code: " +
          response.statusCode.toString() +
          ".\nReason: " +
          response.body);
      throw new RegistrationErrorException(
          "Server request was unsuccessful.\nResponse code: " +
              response.statusCode.toString() +
              ".\nReason: " +
              response.body);
      //return false;
    }
  }

  /// Get the device_password_base64 of the device from secure storage. If it is not set,
  /// the function throws a [StateError], since the device_password_base64 is generated
  /// during registration and is expected to be saved.
  Future<Uint8List> getDevicePassword() async {
    final devicePassword = await _storage.read(key: "device_password_base64");
    if (devicePassword == null) {
      throw StateError("device_password_base64 is not readable");
    } else {
      return base64.decode(devicePassword);
    }
  }

  /// Check if the user is registered
  Future<bool> isRegistered() async {
    final registrationStatus = await _storage.read(key: "registrationStatus");
    if (registrationStatus == "2") {
      return true;
    } else {
      return false;
    }
  }

  /// Check if the user has started registering
  Future<bool> isRegistering() async {
    final registrationStatus = await _storage.read(key: "registrationStatus");
    if (registrationStatus == "1") {
      return true;
    } else {
      return false;
    }
  }

  /// Specifies that the user has started registering
  Future<void> setRegistering() async {
    await _storage.write(
        key: "registrationStatus", value: "1");
  }

  /// Specifies that the user is registered
  Future<void> setRegistered() async {
    await _storage.write(
        key: "registrationStatus", value: "2");
  }

  /// Specifies that the user is unregistered
  Future<void> setUnregistered() async {
    await _storage.write(
        key: "registrationStatus", value: "0");
  }

  ///This method combines the phone number with the returned password to
  ///generate the authentification token
  String _generateAuthenticationToken(
      String phoneNumber, Uint8List passwordBytes) {
    var authBytesBuilder = BytesBuilder();
    final numberAsIntList = utf8.encoder.convert(phoneNumber + ":");

    authBytesBuilder.add(numberAsIntList);
    authBytesBuilder.add(passwordBytes);

    return base64.encode(authBytesBuilder.toBytes());
  }

  /// Clears database of encryption related tables
  /// This is used when reregistering
  Future<void> clearEncryptionTables() async {
    final db = await _databaseService.database;

    await Future.wait([
      db.delete(PreKeyDBRecord.TABLE_NAME),
      db.delete(SessionDBRecord.TABLE_NAME),
      db.delete(SignedPreKeyDBRecord.TABLE_NAME),
      db.delete(TrustedKeyDBRecord.TABLE_NAME),
      db.delete(MessageboxToken.TABLE_NAME),
      db.delete(Messagebox.TABLE_NAME),
      db.delete(FailedDecryptionCounter.TABLE_NAME)
    ]);
  }

  Future<void> deleteAccount() async {
    if(!(await isRegistered())){
      return;
    }

    final phoneNumber = await _userService.getPhoneNumber();
    final authTokenEncoded = await _userService.getDeviceAuthTokenEncoded();

    final url = Uri.parse(Constants.httpUrl + "deleteAccount");

    var data = {
      "authorization": "Bearer $authTokenEncoded",
      "phoneNumber": phoneNumber
    };

    final response = await http.post(url, body: jsonEncode(data));

    if (response.statusCode == 200){
      final db = await _databaseService.database;
      await clearEncryptionTables();
      await Future.wait([
        setUnregistered(),
        _userService.setDisplayName(""),
        _userService.setProfileImage(Uint8List.fromList([])),
        _userService.setStatus(""),
        _userService.setPhoneNumber(""),
        db.delete(MessagePayload.TABLE_NAME),
        db.delete(MessageResendRequest.TABLE_NAME),
      ]);
    }
  }

}
