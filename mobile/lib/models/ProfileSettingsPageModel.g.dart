// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ProfileSettingsPageModel.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ProfileSettingsPageModel on _ProfileSettingsPageModel, Store {
  final _$phoneNumberAtom = Atom(name: '_ProfileSettingsPageModel.phoneNumber');

  @override
  String get phoneNumber {
    _$phoneNumberAtom.reportRead();
    return super.phoneNumber;
  }

  @override
  set phoneNumber(String value) {
    _$phoneNumberAtom.reportWrite(value, super.phoneNumber, () {
      super.phoneNumber = value;
    });
  }

  final _$displayNameAtom = Atom(name: '_ProfileSettingsPageModel.displayName');

  @override
  String get displayName {
    _$displayNameAtom.reportRead();
    return super.displayName;
  }

  @override
  set displayName(String value) {
    _$displayNameAtom.reportWrite(value, super.displayName, () {
      super.displayName = value;
    });
  }

  final _$statusAtom = Atom(name: '_ProfileSettingsPageModel.status');

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

  final _$birthdayAtom = Atom(name: '_ProfileSettingsPageModel.birthday');

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

  final _$profilePictureAtom =
      Atom(name: '_ProfileSettingsPageModel.profilePicture');

  @override
  Uint8List? get profilePicture {
    _$profilePictureAtom.reportRead();
    return super.profilePicture;
  }

  @override
  set profilePicture(Uint8List? value) {
    _$profilePictureAtom.reportWrite(value, super.profilePicture, () {
      super.profilePicture = value;
    });
  }

  @override
  String toString() {
    return '''
phoneNumber: ${phoneNumber},
displayName: ${displayName},
status: ${status},
birthday: ${birthday},
profilePicture: ${profilePicture}
    ''';
  }
}
