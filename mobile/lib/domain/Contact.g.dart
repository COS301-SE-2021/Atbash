// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Contact.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$Contact on _Contact, Store {
  final _$displayNameAtom = Atom(name: '_Contact.displayName');

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

  final _$statusAtom = Atom(name: '_Contact.status');

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

  final _$profileImageAtom = Atom(name: '_Contact.profileImage');

  @override
  String get profileImage {
    _$profileImageAtom.reportRead();
    return super.profileImage;
  }

  @override
  set profileImage(String value) {
    _$profileImageAtom.reportWrite(value, super.profileImage, () {
      super.profileImage = value;
    });
  }

  final _$birthdayAtom = Atom(name: '_Contact.birthday');

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
displayName: ${displayName},
status: ${status},
profileImage: ${profileImage},
birthday: ${birthday}
    ''';
  }
}
