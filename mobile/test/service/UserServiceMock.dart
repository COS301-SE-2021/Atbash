import 'package:mobile/services/UserService.dart';

class UserServiceMock implements UserService {
  @override
  Future<String> getUserPhoneNumber() {
    // TODO: implement getUserPhoneNumber
    throw UnimplementedError();
  }

  @override
  Future<String?> getUserProfilePictureAsString() {
    // TODO: implement getUserProfilePictureAsString
    throw UnimplementedError();
  }

  @override
  Future<bool> isRegistered() {
    // TODO: implement isRegistered
    throw UnimplementedError();
  }

  @override
  Future<bool> register(String phoneNumber) async {
    return true;
  }
}
