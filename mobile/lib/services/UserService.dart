import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class UserService {
  final _storage = FlutterSecureStorage();
  final _displayNameCallbacks = <void Function(String name)>[];

  /// Register a user on the server. [deviceToken] is the firebase device token
  /// for push notifications
  Future<bool> register(
      String phoneNumber, String password, String deviceToken) async {
    final url = Uri.parse("http://10.0.2.2:8080/rs/v1/register");

    final data = {
      "number": phoneNumber,
      "password": password,
      "deviceToken": deviceToken,
    };

    final response = await http.post(url, body: data);
    return response.statusCode == 200;
  }

  /// Login the user. If successful, access_token and phone_number is saved in
  /// secure storage.
  Future<bool> login(String phoneNumber, String password) async {
    final url = Uri.parse("http://10.0.2.2:8080/rs/v1/login");

    final data = {
      "number": phoneNumber,
      "password": password,
    };

    final response = await http.post(url, body: data);

    if (response.statusCode == 200) {
      Future.wait([
        _storage.write(key: "access_token", value: response.body),
        _storage.write(key: "phone_number", value: phoneNumber),
      ]);

      return true;
    } else {
      return false;
    }
  }

  /// Get the display_name of the user from secure storage. If it is not set,
  /// phone_number is returned instead.
  Future<String> getUserDisplayName() async {
    return await _storage.read(key: "display_name") ??
        await getUserPhoneNumber();
  }

  /// Get the display_name of the user from secure storage. If it is not set,
  /// null is returned instead
  Future<String?> getUserDisplayNameOrNull() async {
    return await _storage.read(key: "display_name");
  }

  /// Adds [fn] to the list of callbacks for changes to user display name.
  /// Returns the current display name.
  Future<String> onUserDisplayNameChanged(void Function(String name) fn) {
    _displayNameCallbacks.add(fn);
    return getUserDisplayName();
  }

  /// Removed [fn] from the list of callbacks for changes to user display name.
  void disposeUserDisplayNameListener(void Function(String name) fn) {
    _displayNameCallbacks.remove(fn);
  }

  /// Save [displayName] in secure storage as display_name. The future completes
  /// once the name is saved.
  Future<void> setUserDisplayName(String displayName) async {
    await _storage.write(key: "display_name", value: displayName);
    _notifyUserDisplayNameListeners(displayName);
  }

  /// Get the profile_image of the user from secure_storage. If it is not set,
  /// null is returned.
  Future<Uint8List?> getUserProfilePicture() async {
    final base64Image = await _storage.read(key: "profile_image") ?? "";
    return base64Decode(base64Image);
  }

  /// Save [encodedImage] in secure storage as profile_image. The future
  /// completes once the image is saved.
  Future<void> setUserProfilePicture(Uint8List encodedImage) async {
    final base64Image = base64Encode(encodedImage);
    await _storage.write(key: "profile_image", value: base64Image);
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

  void _notifyUserDisplayNameListeners(String displayName) {
    _displayNameCallbacks.forEach((element) => element(displayName));
  }
}
