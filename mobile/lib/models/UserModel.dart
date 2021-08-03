import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobx/mobx.dart';

part 'UserModel.g.dart';

class UserModel = UserModelBase with _$UserModel;

abstract class UserModelBase with Store {
  final _storage = FlutterSecureStorage();

  @observable
  String displayName = "";

  @observable
  Uint8List profileImage = Uint8List(0);

  UserModelBase() {
    _storage.read(key: "display_name").then((value) {
      if (value != null) setDisplayName(value);
    });

    _storage.read(key: "profile_image").then((value) {
      if (value != null) setProfileImage(base64Decode(value));
    });
  }

  @action
  void setDisplayName(String displayName) {
    this.displayName = displayName;
    _storage.write(key: "display_name", value: displayName);
  }

  @action
  void setProfileImage(Uint8List profileImage) {
    this.profileImage = profileImage;
    _storage.write(key: "profile_image", value: base64Encode(profileImage));
  }
}
