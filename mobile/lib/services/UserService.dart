import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/services/KeyGenService.dart';

class UserService {
  final KeyGenService _keyGenService;

  UserService(this._keyGenService);

  final _storage = FlutterSecureStorage();

  /// Register a user on the server. [deviceToken] is the firebase device token
  /// for push notifications
  Future<bool> register(String phoneNumber, String deviceToken) async {
    final url = Uri.parse(
        "https://bjarhthz5j.execute-api.af-south-1.amazonaws.com/dev/register");

    final publicKeyStr = await _keyGenService.generateAndSaveKeyPair();

    final data = {
      "phoneNumber": phoneNumber,
      "rsaPublicKey": publicKeyStr,
      "deviceToken": deviceToken,
    };

    final response = await http.post(url, body: jsonEncode(data));

    if (response.statusCode == 200) {
      await Future.wait([
        _storage.write(key: "phone_number", value: phoneNumber),
      ]);

      return true;
    } else {
      return false;
    }
  }

  Future<bool> isRegistered() async {
    return await _storage.containsKey(key: "phone_number");
  }

  Future<String?> getUserProfilePictureAsString() async {
    return await _storage.read(key: "profile_image");
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
}
