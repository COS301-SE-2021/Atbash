// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserModel.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$UserModel on UserModelBase, Store {
  final _$statusAtom = Atom(name: 'UserModelBase.status');

  @override
  String get status {
    _$statusAtom.reportRead();
    return super.status;
  }

  @override
  set status(String value) {
    _$statusAtom.reportWrite(value, super.status, () {
      super.status = value;
    });
  }

  final _$profileImageAtom = Atom(name: 'UserModelBase.profileImage');

  @override
  Uint8List get profileImage {
    _$profileImageAtom.reportRead();
    return super.profileImage;
  }

  @override
  set profileImage(Uint8List value) {
    _$profileImageAtom.reportWrite(value, super.profileImage, () {
      super.profileImage = value;
    });
  }

  final _$UserModelBaseActionController =
      ActionController(name: 'UserModelBase');

  @override
  void setProfileImage(Uint8List profileImage) {
    final _$actionInfo = _$UserModelBaseActionController.startAction(
        name: 'UserModelBase.setProfileImage');
    try {
      return super.setProfileImage(profileImage);
    } finally {
      _$UserModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setStatus(String status) {
    final _$actionInfo = _$UserModelBaseActionController.startAction(
        name: 'UserModelBase.setStatus');
    try {
      return super.setStatus(status);
    } finally {
      _$UserModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
status: ${status},
profileImage: ${profileImage}
    ''';
  }
}
