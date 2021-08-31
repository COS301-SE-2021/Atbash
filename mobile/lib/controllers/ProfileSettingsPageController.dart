import 'dart:typed_data';

import 'package:get_it/get_it.dart';
import 'package:mobile/models/ProfileSettingsPageModel.dart';
import 'package:mobile/services/UserService.dart';

class ProfileSettingsPageController {
  final UserService userService = GetIt.I.get();

  final ProfileSettingsPageModel model = ProfileSettingsPageModel();

  ProfileSettingsPageController() {
    userService.getPhoneNumber().then((value) => model.phoneNumber = value);
    userService.getDisplayName().then((value) => model.displayName = value);
    userService.getStatus().then((value) => model.status = value);
    userService.getBirthday().then((value) => model.birthday = value);
    userService.getProfileImage().then((value) => model.profilePicture = value);
  }

  void setDisplayName(String name) {
    model.displayName = name;
    userService.setDisplayName(name);
  }

  void setStatus(String status) {
    model.status = status;
    userService.setStatus(status);
  }

  void setBirthday(DateTime birthday) {
    model.birthday = birthday;
    userService.setBirthday(birthday);
  }

  void setProfilePicture(Uint8List picture) {
    model.profilePicture = picture;
    userService.setProfileImage(picture);
  }
}
