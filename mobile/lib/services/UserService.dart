class UserService {
  /// Register a user on the server. [deviceToken] is the firebase device token
  /// for push notifications
  Future<bool> register(
      String phoneNumber, String password, String deviceToken) {
    throw UnimplementedError();
  }

  /// Login the user. If successful, access_token and phone_number is saved in
  /// secure storage.
  Future<bool> login(String phoneNumber, String password) {
    throw UnimplementedError();
  }

  /// Get the display_name of the user from secure storage. If it is not set,
  /// phone_number is returned instead.
  Future<String> getUserDisplayName() {
    throw UnimplementedError();
  }

  /// Adds [fn] to the list of callbacks for changes to user display name.
  /// Returns the current display name.
  Future<String> onUserDisplayNameChanged(void Function(String name) fn) {
    throw UnimplementedError();
  }

  /// Removed [fn] from the list of callbacks for changes to user display name.
  void disposeUserDisplayNameListener(void Function(String name) fn) {
    throw UnimplementedError();
  }

  /// Save [displayName] in secure storage as display_name. The future completes
  /// once the name is saved.
  Future<void> setUserDisplayName(String displayName) {
    throw UnimplementedError();
  }

  /// Get the phone_number of the user from secure storage. If it is not set,
  /// the function throws a [StateError], since the phone_number of a logged-in
  /// user is expected to be saved.
  Future<String> getUserPhoneNumber() {
    throw UnimplementedError();
  }
}
