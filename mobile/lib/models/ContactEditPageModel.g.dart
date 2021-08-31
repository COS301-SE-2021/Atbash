// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ContactEditPageModel.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ContactEditPageModel on _ContactEditPageModel, Store {
  final _$contactNameAtom = Atom(name: '_ContactEditPageModel.contactName');

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

  final _$contactBirthdayAtom =
      Atom(name: '_ContactEditPageModel.contactBirthday');

  @override
  DateTime? get contactBirthday {
    _$contactBirthdayAtom.reportRead();
    return super.contactBirthday;
  }

  @override
  set contactBirthday(DateTime? value) {
    _$contactBirthdayAtom.reportWrite(value, super.contactBirthday, () {
      super.contactBirthday = value;
    });
  }

  final _$_ContactEditPageModelActionController =
      ActionController(name: '_ContactEditPageModel');

  @override
  void setContactName(String name) {
    final _$actionInfo = _$_ContactEditPageModelActionController.startAction(
        name: '_ContactEditPageModel.setContactName');
    try {
      return super.setContactName(name);
    } finally {
      _$_ContactEditPageModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setContactBirthday(DateTime birthday) {
    final _$actionInfo = _$_ContactEditPageModelActionController.startAction(
        name: '_ContactEditPageModel.setContactBirthday');
    try {
      return super.setContactBirthday(birthday);
    } finally {
      _$_ContactEditPageModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
contactName: ${contactName},
contactBirthday: ${contactBirthday}
    ''';
  }
}
