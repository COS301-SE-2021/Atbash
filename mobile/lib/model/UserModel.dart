import 'package:flutter/foundation.dart';
import 'package:mobile/domain/User.dart';

class UserModel extends ChangeNotifier {
  User? _loggedInUser;

  // TODO this is a mock function
  void logInUser(String phoneNumber, String displayName) {
    _loggedInUser = User(phoneNumber, displayName, "Hi! I'm using Atbash");
  }

  void changeUserDisplayName(String displayName) {
    _loggedInUser?.displayName = displayName;
    notifyListeners();
  }

  String? get userDisplayName => _loggedInUser?.displayName;

  void changeUserStatus(String status) {
    _loggedInUser?.status = status;
    notifyListeners();
  }
}
