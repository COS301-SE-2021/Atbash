import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobx/mobx.dart';

part 'UserModel.g.dart';

class UserModel = _UserModel with _$UserModel;

abstract class _UserModel with Store {
  final _storage = FlutterSecureStorage();

  @observable
  String phoneNumber = "";

  @observable
  String? displayName;

  @observable
  String? status;

  @observable
  String? profileImage;

  @observable
  DateTime? birthday;

  _UserModel() {
    _storage.read(key: "display_name").then((value) {
      if (value != null) setDisplayName(value);
    });

    _storage.read(key: "status").then((value) {
      if (value != null) setStatus(value);
    });

    _storage.read(key: "profile_image").then((value) {
      if (value != null) setProfileImage(value);
    });

    _storage.read(key: "birthday").then((value) {
      if (value != null)
        setBirthday(DateTime.fromMillisecondsSinceEpoch(int.parse(value)));
    });
  }

  @action
  void register(String phoneNumber) {}

  @action
  bool isRegistered() {
    return true;
  }
}
