// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ContactInfoPageModel.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ContactInfoPageModel on _ContactInfoPageModel, Store {
  final _$contactNameAtom = Atom(name: '_ContactInfoPageModel.contactName');

  @override
  String get contactName {
    _$contactNameAtom.reportRead();
    return super.contactName;
  }

  @override
  set contactName(String value) {
    _$contactNameAtom.reportWrite(value, super.contactName, () {
      super.contactName = value;
    });
  }

  final _$phoneNumberAtom = Atom(name: '_ContactInfoPageModel.phoneNumber');

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

  final _$profilePictureAtom =
      Atom(name: '_ContactInfoPageModel.profilePicture');

  @override
  String get profilePicture {
    _$profilePictureAtom.reportRead();
    return super.profilePicture;
  }

  @override
  set profilePicture(String value) {
    _$profilePictureAtom.reportWrite(value, super.profilePicture, () {
      super.profilePicture = value;
    });
  }

  final _$statusAtom = Atom(name: '_ContactInfoPageModel.status');

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

  final _$birthdayAtom = Atom(name: '_ContactInfoPageModel.birthday');

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

  @override
  String toString() {
    return '''
contactName: ${contactName},
phoneNumber: ${phoneNumber},
profilePicture: ${profilePicture},
status: ${status},
birthday: ${birthday}
    ''';
  }
}
