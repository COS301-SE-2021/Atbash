import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/services/RegistrationService.dart';
import 'package:mobx/mobx.dart';

part 'UserModel.g.dart';

class UserModel = _UserModel with _$UserModel;

abstract class _UserModel with Store {
  final RegistrationService registrationService = GetIt.I.get();

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
  Future<bool> register(String phoneNumber) async {
    return await registrationService.register(phoneNumber, "abc");
  }

  @computed
  Future<bool> get isRegistered async =>
      await _storage.read(key: "phone_number") != null;

  @action
  void setDisplayName(String displayName) {
    this.displayName = displayName;
    _storage.write(key: "display_name", value: displayName);
  }

  @action
  void setStatus(String status) {
    this.status = status;
    _storage.write(key: "status", value: status);
  }

  @action
  void setProfileImage(String profileImage) {
    this.profileImage = profileImage;
    _storage.write(key: "profile_image", value: profileImage);
  }

  @action
  void setBirthday(DateTime birthday) {
    this.birthday = birthday;
    _storage.write(
        key: "birthday", value: birthday.millisecondsSinceEpoch.toString());
  }
}
