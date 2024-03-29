import 'dart:convert';
import 'dart:typed_data';

import 'package:crypton/crypton.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserService {
  final _storage = FlutterSecureStorage();

  Future<String> getPhoneNumber() async {
    final phoneNumber = await _storage.read(key: "phone_number");
    if (phoneNumber == null) {
      throw PhoneNumberNotFoundException();
    } else {
      return phoneNumber;
    }
  }

  Future<void> setPhoneNumber(String phoneNumber) async {
    await _storage.write(key: "phone_number", value: phoneNumber);
  }

  Future<String> getDisplayName() async {
    final displayName = await _storage.read(key: "display_name");
    if (displayName == null) {
      return "";
    } else {
      return displayName;
    }
  }

  Future<void> setDisplayName(String displayName) async {
    await _storage.write(key: "display_name", value: displayName);
  }

  Future<String> getStatus() async {
    final status = await _storage.read(key: "status");
    if (status == null) {
      return "";
    } else {
      return status;
    }
  }

  Future<void> setStatus(String status) async {
    await _storage.write(key: "status", value: status);
  }

  Future<Uint8List?> getProfileImage() async {
    final profileImage = await _storage.read(key: "profile_image");
    if (profileImage != null) {
      return base64Decode(profileImage);
    } else {
      return null;
    }
  }

  Future<void> setProfileImage(Uint8List profileImage) async {
    await _storage.write(
        key: "profile_image", value: base64Encode(profileImage));
  }

  Future<DateTime?> getBirthday() async {
    final birthday = await _storage.read(key: "birthday");
    if (birthday != null) {
      final timestamp = int.parse(birthday);
      return DateTime.fromMillisecondsSinceEpoch(timestamp);
    } else {
      return null;
    }
  }

  Future<void> setBirthday(DateTime birthday) async {
    final timestamp = birthday.millisecondsSinceEpoch;
    await _storage.write(key: "birthday", value: timestamp.toString());
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

  Future<void> storeRSAKeyPair(RSAKeypair rsaKeypair) async {
    await _storage.write(
        key: "my_rsa_keypair", value: rsaKeypair.privateKey.toString());
  }

  Future<RSAKeypair> fetchRSAKeyPair() async {
    final privKeyStr = await _storage.read(key: "my_rsa_keypair");
    if (privKeyStr == null) {
      throw StateError("my_rsa_keypair is not readable");
    } else {
      return RSAKeypair(RSAPrivateKey.fromString(privKeyStr));
    }
  }
}

class PhoneNumberNotFoundException implements Exception {}
