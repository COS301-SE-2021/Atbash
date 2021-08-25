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
    throw UnimplementedError();
  }

  Future<void> setDisplayName(String displayName) async {
    throw UnimplementedError();
  }

  Future<String> getStatus() async {
    throw UnimplementedError();
  }

  Future<void> setStatus(String status) async {
    throw UnimplementedError();
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
