import 'package:mobx/mobx.dart';

part 'UserModel.g.dart';

class UserModel = _UserModel with _$UserModel;

abstract class _UserModel with Store {
  String phoneNumber = "";
  String displayName = "";
  String status = "";
  String profileImage = "";
  String birthday = "";

  @action
  register(String phoneNumber) {}

  @action
  bool isRegistered() {
    return true;
  }
}
