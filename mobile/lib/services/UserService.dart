import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:rsa_encrypt/rsa_encrypt.dart';
import 'package:pointycastle/asymmetric/api.dart';

class UserService {
  final _storage = FlutterSecureStorage();
  final _displayNameCallbacks = <void Function(String name)>[];
  final _statusCallbacks = <void Function(String status)>[];

  /// Register a user on the server. [deviceToken] is the firebase device token
  /// for push notifications
  Future<bool> register(String phoneNumber, String deviceToken) async {
    final url = Uri.parse(
        "https://bjarhthz5j.execute-api.af-south-1.amazonaws.com/dev/register");

    final rsaHelper = RsaKeyHelper();
    final keyPair =
        await rsaHelper.computeRSAKeyPair(rsaHelper.getSecureRandom());

    final publicKeyStr =
        rsaHelper.encodePublicKeyToPemPKCS1(keyPair.publicKey as RSAPublicKey);
    final privateKeyStr = rsaHelper
        .encodePrivateKeyToPemPKCS1(keyPair.privateKey as RSAPrivateKey);

    final data = {
      "phoneNumber": phoneNumber,
      "rsaPublicKey": publicKeyStr,
      "deviceToken": deviceToken,
    };

    final response = await http.post(url, body: jsonEncode(data));

    if (response.statusCode == 200) {
      await Future.wait([
        _storage.write(key: "phone_number", value: phoneNumber),
        _storage.write(key: "rsa_public_key", value: publicKeyStr),
        _storage.write(key: "rsa_private_key", value: privateKeyStr),
      ]);

      return true;
    } else {
      return false;
    }
  }

  Future<bool> isRegistered() async {
    return await _storage.containsKey(key: "phone_number");
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

  /// Get the status of the user from secure storage. If it is not set,
  /// an empty string is returned instead.
  Future<String> getUserStatus() async {
    return await _storage.read(key: "status") ?? "";
  }

  /// Get the status of the user from secure storage. If it is not set,
  /// null is returned instead.
  Future<String?> getUserStatusOrNull() async {
    return await _storage.read(key: "status");
  }

  Future<String> onUserStatusChanged(void Function(String status) fn) {
    _statusCallbacks.add(fn);
    return getUserStatus();
  }

  void disposeUserStatusListener(void Function(String status) fn) {
    _statusCallbacks.remove(fn);
  }

  Future<void> setUserStatus(String status) async {
    await _storage.write(key: "status", value: status);
    _notifyUserStatusListeners(status);
  }

  /// Get the profile_image of the user from secure_storage. If it is not set,
  /// null is returned.
  Future<Uint8List?> getUserProfilePicture() async {
    final base64Image = await _storage.read(key: "profile_image") ?? "";
    return base64Decode(base64Image);
  }

  Future<String?> getUserProfilePictureAsString() async {
    return await _storage.read(key: "profile_image");
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

  void _notifyUserStatusListeners(String status) {
    _statusCallbacks.forEach((element) => element(status));
  }
}
