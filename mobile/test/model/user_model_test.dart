import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/model/UserModel.dart';

void main() {
  test("User display name should be changed", () {
    final userModel = UserModel();

    userModel.changeUserDisplayName("Liam Mayston");
    expect(userModel.userDisplayName, "Liam Mayston");
  });
}
