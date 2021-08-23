import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobx/mobx.dart';

part 'UserModel.g.dart';

class UserModel = _UserModel with _$UserModel;

abstract class _UserModel with Store {
  final _storage = FlutterSecureStorage();

  @computed
  Future<String?> get phoneNumber async =>
      await _storage.read(key: "phone_number");

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

  @computed
  Future<bool> get isRegistered async =>
      await _storage.read(key: "phone_number") != null;

  void setDisplayName(String displayName) {
    this.displayName = displayName;
    _storage.write(key: "display_name", value: displayName);
  }

  void setStatus(String status) {
    this.status = status;
    _storage.write(key: "status", value: status);
  }

  void setProfileImage(String profileImage) {
    this.profileImage = profileImage;
    _storage.write(key: "profile_image", value: profileImage);
  }

  void setBirthday(DateTime birthday) {
    this.birthday = birthday;
    _storage.write(
        key: "birthday", value: birthday.millisecondsSinceEpoch.toString());
  }
}
