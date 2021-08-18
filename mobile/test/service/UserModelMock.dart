import 'dart:typed_data';

import 'package:mobile/models/UserModel.dart';

class UserModelMock implements UserModel {
  @override
  String displayName = "";

  @override
  Uint8List profileImage = Uint8List(0);

  @override
  String status = "";

  @override
  void setDisplayName(String displayName) {
    // TODO: implement setDisplayName
  }

  @override
  void setProfileImage(Uint8List profileImage) {
    // TODO: implement setProfileImage
  }

  @override
  void setStatus(String status) {
    // TODO: implement setStatus
  }
}
