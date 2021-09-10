import 'dart:convert';
import 'dart:typed_data';

// import 'package:cryptography/cryptography.dart'; //Need to use this
import 'package:crypto/crypto.dart'; //Remove this and use "cryptography"
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

import 'package:mobile/constants.dart';
import 'package:mobile/exceptions/InvalidNumberException.dart';
import 'package:mobile/exceptions/RegistrationErrorException.dart';
import 'package:mobile/util/Validations.dart';
import 'EncryptionService.dart';

// import 'package:rsa_encrypt/rsa_encrypt.dart' as rsa;
// import 'package:encrypt/encrypt.dart' as encrypt;
// import 'package:pointycastle/asymmetric/api.dart';
// import 'package:pointycastle/export.dart';
import 'package:crypton/crypton.dart';

class RegistrationService {
  RegistrationService(this._encryptionService);

  final EncryptionService _encryptionService; // = GetIt.I.get<EncryptionService>();

  final _storage = FlutterSecureStorage();

  Future<bool> register(String phoneNumber) async {
    // final url = Uri.parse("https://" + baseURL + "accounts/code/$verificationCode");

    final url = Uri.parse(Constants.httpUrl + "register");

    throwIfNot(Validations().numberIsValid(phoneNumber),
        new InvalidNumberException("Invalid number provided in requestRegistrationCode method"));

    // final phoneNumber = await getUserPhoneNumber();
    final registrationId = generateRegistrationId(false);
    final aesKey = generateRandomBytes(32);
    final hmacSha256 = Hmac(sha256, aesKey);
    var signalingKeyBytesBuilder = BytesBuilder();

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
      final responseBodyJson = jsonDecode(response.body);
      final encryptedDevicePassword = responseBodyJson["password"] as String?;
      final formattedPhoneNumber = responseBodyJson["phoneNumber"] as String?;
      if(encryptedDevicePassword == null){
        throw new RegistrationErrorException("Server response was in an invalid format. Response body: " + response.body);
      }
      if(formattedPhoneNumber != null){
        phoneNumber = formattedPhoneNumber;
      }

      final base64DevicePassword = rsaKeypair.privateKey.decrypt(encryptedDevicePassword);
      final devicePassword = base64Decode(base64DevicePassword);

      final authTokenEncoded = _generateAuthenticationToken(phoneNumber, devicePassword);

      Future.wait([
        //_storage.write(key: "registration_id", value: registrationId.toString()),
        _storage.write(
            key: "device_password_base64",
            value: base64DevicePassword),
        _storage.write(
            key: "device_authentication_token_base64", value: authTokenEncoded),
        _storage.write(key: "phone_number", value: phoneNumber),
      ]);

      await _encryptionService.generateInitialKeyBundle(registrationId);

      return registerKeys();
    } else {
      print("Server request was unsuccessful.\nResponse code: " + response.statusCode.toString() + ".\nReason: " + response.body);
      throw new RegistrationErrorException("Server request was unsuccessful.\nResponse code: " + response.statusCode.toString() + ".\nReason: " + response.body);
      //return false;
    }
  }

  Future<bool> registerKeys() async {
    final url = Uri.parse(Constants.httpUrl + "keys/register");

    final phoneNumber = await _encryptionService.getUserPhoneNumber();
    // final devicePassword = await getDevicePassword();
    // final authTokenEncoded = _generateAuthenticationToken(phoneNumber, devicePassword);
    final authTokenEncoded = await _encryptionService.getDeviceAuthTokenEncoded();

    final identityKeyPair = await _encryptionService.getIdentityKeyPair();
    final signedPreKey = await _encryptionService.fetchLocalSignedPreKey();
    final preKeys = await _encryptionService.loadPreKeys();

    if (identityKeyPair == null ||
        signedPreKey == null ||
        preKeys.isEmpty ||
        preKeys.length < 100) {
      ///Output reason for failure to log here??
      return false;
    }

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
      print("Server request was unsuccessful.\nResponse code: " + response.statusCode.toString() + ".\nReason: " + response.body);
      throw new RegistrationErrorException("Server request was unsuccessful.\nResponse code: " + response.statusCode.toString() + ".\nReason: " + response.body);
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