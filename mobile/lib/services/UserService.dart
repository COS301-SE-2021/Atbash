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

  Future<String> getProfileImage() async {
    throw UnimplementedError();
  }

  Future<void> setProfileImage(String profileImage) async {
    throw UnimplementedError();
  }

  Future<DateTime?> getBirthday() async {
    throw UnimplementedError();
  }

  Future<void> setBirthday(DateTime birthday) async {
    throw UnimplementedError();
  }
}

class PhoneNumberNotFoundException implements Exception {}
