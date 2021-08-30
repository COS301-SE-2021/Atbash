// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserModel.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$UserModel on _UserModel, Store {
  Computed<Future<String?>>? _$phoneNumberComputed;

  @override
  Future<String?> get phoneNumber => (_$phoneNumberComputed ??=
          Computed<Future<String?>>(() => super.phoneNumber,
              name: '_UserModel.phoneNumber'))
      .value;
  Computed<Future<bool>>? _$isRegisteredComputed;

  @override
  Future<bool> get isRegistered => (_$isRegisteredComputed ??=
          Computed<Future<bool>>(() => super.isRegistered,
              name: '_UserModel.isRegistered'))
      .value;

  final _$displayNameAtom = Atom(name: '_UserModel.displayName');

  @override
  String? get displayName {
    _$displayNameAtom.reportRead();
    return super.displayName;
  }

  @override
  set displayName(String? value) {
    _$displayNameAtom.reportWrite(value, super.displayName, () {
      super.displayName = value;
    });
  }

  final _$statusAtom = Atom(name: '_UserModel.status');

  @override
  String? get status {
    _$statusAtom.reportRead();
    return super.status;
  }

  @override
  set status(String? value) {
    _$statusAtom.reportWrite(value, super.status, () {
      super.status = value;
    });
  }

  final _$profileImageAtom = Atom(name: '_UserModel.profileImage');

  @override
  String? get profileImage {
    _$profileImageAtom.reportRead();
    return super.profileImage;
  }

  @override
  set profileImage(String? value) {
    _$profileImageAtom.reportWrite(value, super.profileImage, () {
      super.profileImage = value;
    });
  }

  final _$birthdayAtom = Atom(name: '_UserModel.birthday');

  @override
  DateTime? get birthday {
    _$birthdayAtom.reportRead();
    return super.birthday;
  }

  @override
  set birthday(DateTime? value) {
    _$birthdayAtom.reportWrite(value, super.birthday, () {
      super.birthday = value;
    });
  }

  final _$registerAsyncAction = AsyncAction('_UserModel.register');

  @override
  Future<bool> register(String phoneNumber) {
    return _$registerAsyncAction.run(() => super.register(phoneNumber));
  }

  final _$_UserModelActionController = ActionController(name: '_UserModel');

  @override
  void setDisplayName(String displayName) {
    final _$actionInfo = _$_UserModelActionController.startAction(
        name: '_UserModel.setDisplayName');
    try {
      return super.setDisplayName(displayName);
    } finally {
      _$_UserModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setStatus(String status) {
    final _$actionInfo =
        _$_UserModelActionController.startAction(name: '_UserModel.setStatus');
    try {
      return super.setStatus(status);
    } finally {
      _$_UserModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setProfileImage(String profileImage) {
    final _$actionInfo = _$_UserModelActionController.startAction(
        name: '_UserModel.setProfileImage');
    try {
      return super.setProfileImage(profileImage);
    } finally {
      _$_UserModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setBirthday(DateTime birthday) {
    final _$actionInfo = _$_UserModelActionController.startAction(
        name: '_UserModel.setBirthday');
    try {
      return super.setBirthday(birthday);
    } finally {
      _$_UserModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
displayName: ${displayName},
status: ${status},
profileImage: ${profileImage},
birthday: ${birthday},
phoneNumber: ${phoneNumber},
isRegistered: ${isRegistered}
    ''';
  }
}
