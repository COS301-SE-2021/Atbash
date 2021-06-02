import 'package:flutter/foundation.dart';
import 'package:mobile/domain/User.dart';

class UserModel extends ChangeNotifier {
  User? _loggedInUser;

  void changeUserDisplayName(String displayName) {
    _loggedInUser?.displayName = displayName;
    notifyListeners();
  }

  void changeUserStatus(String status) {
    _loggedInUser?.status = status;
    notifyListeners();
  }
}
