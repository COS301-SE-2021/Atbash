import 'dart:convert';
import 'dart:typed_data';

import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:mobile/constants.dart';
import 'package:mobile/exceptions/InvalidNumberException.dart';
import 'package:mobile/exceptions/RegistrationErrorException.dart';
import 'package:mobile/util/Validations.dart';
import 'EncryptionService.dart';

import 'package:crypton/crypton.dart';
import 'package:crypto/crypto.dart'; //For Hmac function
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

import 'UserService.dart';

class RegistrationService {
  RegistrationService(this._encryptionService, this._userService);

  final EncryptionService _encryptionService;
  final UserService _userService;
  final _storage = FlutterSecureStorage();

  ///This function creates a new Atbash account on the server which will be
  ///needed for linking a users phone number with their keys
  Future<String?> register(String phoneNumber) async {
    final url = Uri.parse(Constants.httpUrl + "register");

    throwIfNot(
        Validations().numberIsValid(phoneNumber),
        new InvalidNumberException(
            "Invalid number provided in requestRegistrationCode method"));

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
    RSAKeypair rsaKeypair = RSAKeypair.fromRandom(keySize: 4096);
    final pubRsaKey = rsaKeypair.publicKey.asPointyCastle;

    var data = {
      "registrationId": registrationId,
      "phoneNumber": phoneNumber,
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
      final responseBodyJson = jsonDecode(response.body) as Map<String, Object>;
      final encryptedDevicePassword = responseBodyJson["password"] as String?;
      final formattedPhoneNumber = responseBodyJson["phoneNumber"] as String?;
      final verificationCode = responseBodyJson["verification"] as String?;
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

      Future.wait([
        //_storage.write(key: "registration_id", value: registrationId.toString()),
        _storage.write(
            key: "device_password_base64", value: base64DevicePassword),
        _storage.write(
            key: "device_authentication_token_base64", value: authTokenEncoded),
        _storage.write(key: "phone_number", value: phoneNumber),
      ]);

      await _encryptionService.generateInitialKeyBundle(registrationId);

      final success = await registerKeys();
      if (success) {
        return verificationCode;
      } else {
        return null;
      }
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

  ///This method uploads all the generated public keys for the signal
  ///algorithm to the Atbash server
  Future<bool> registerKeys() async {
    final url = Uri.parse(Constants.httpUrl + "keys/register");

    final phoneNumber = await _userService.getPhoneNumber();
    final authTokenEncoded =
        await _userService.getDeviceAuthTokenEncoded();

    final identityKeyPair = await _encryptionService.getIdentityKeyPair();
    final signedPreKey = await _encryptionService.fetchLocalSignedPreKey();
    final preKeys = await _encryptionService.loadPreKeys();

    if (signedPreKey == null || preKeys.isEmpty || preKeys.length < 100) {
      return false;
    }

    RSAKeypair rsaKeypair = RSAKeypair.fromRandom(keySize: 4096);
    await _userService.storeRSAKeyPair(rsaKeypair);

    List<Map<String, Object>> preKeysArr = [];

    for (var p in preKeys) {
      preKeysArr.add({
        "keyId": p.id,
        "publicKey": base64Encode(p.getKeyPair().publicKey.serialize())
      });
    }

    var data = {
      //Todo: Implement Authorization header and place this there instead
      "authorization": "Bearer $authTokenEncoded",
      "phoneNumber": phoneNumber,
      "identityKey": base64Encode(identityKeyPair.getPublicKey().serialize()),
      "preKeys": preKeysArr,
      "rsaKey": {
        "n": rsaKeypair.publicKey.asPointyCastle.n.toString(),
        "e": rsaKeypair.publicKey.asPointyCastle.publicExponent.toString()
      },
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
      Future.wait([
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
    final registered = await _storage.read(key: "registered");
    if (registered == "1") {
      return true;
    } else {
      return false;
    }
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

// Future<bool> requestRegistrationVerificationCode(String phoneNumber) async {
//   throwIfNot(
//       Validations().numberIsValid(phoneNumber),
//       new InvalidNumberException(
//           "Invalid number provided in requestRegistrationCode method"));
//
//   final url =
//   Uri.parse(baseURLHttps + "accounts/sms/code/$phoneNumber");
//
//   final response = await http.get(url);
//
//   if (response.statusCode == 200) {
//     Future.wait([
//       _storage.write(key: "phone_number", value: phoneNumber),
//     ]);
//
//     return true;
//   } else {
//     return false;
//   }
// }

}
