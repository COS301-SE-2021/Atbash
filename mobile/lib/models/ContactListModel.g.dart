// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ContactListModel.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ContactListModel on _ContactListModel, Store {
  final _$contactsAtom = Atom(name: '_ContactListModel.contacts');

  @override
  ObservableList<Contact> get contacts {
    _$contactsAtom.reportRead();
    return super.contacts;
  }

  @override
  set contacts(ObservableList<Contact> value) {
    _$contactsAtom.reportWrite(value, super.contacts, () {
      super.contacts = value;
    });
  }

  final _$addContactAsyncAction = AsyncAction('_ContactListModel.addContact');

  @override
  Future<void> addContact(String phoneNumber, String displayName) {
    return _$addContactAsyncAction
        .run(() => super.addContact(phoneNumber, displayName));
  }

  final _$setContactBirthdayAsyncAction =
      AsyncAction('_ContactListModel.setContactBirthday');

  @override
  Future<void> setContactBirthday(String phoneNumber, DateTime birthday) {
    return _$setContactBirthdayAsyncAction
        .run(() => super.setContactBirthday(phoneNumber, birthday));
  }

  final _$setContactDisplayNameAsyncAction =
      AsyncAction('_ContactListModel.setContactDisplayName');

  @override
  Future<void> setContactDisplayName(String phoneNumber, String displayName) {
    return _$setContactDisplayNameAsyncAction
        .run(() => super.setContactDisplayName(phoneNumber, displayName));
  }

  final _$_ContactListModelActionController =
      ActionController(name: '_ContactListModel');

  @override
  void init() {
    final _$actionInfo = _$_ContactListModelActionController.startAction(
        name: '_ContactListModel.init');
    try {
      return super.init();
    } finally {
      _$_ContactListModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  void deleteContact(String phoneNumber) {
    final _$actionInfo = _$_ContactListModelActionController.startAction(
        name: '_ContactListModel.deleteContact');
    try {
      return super.deleteContact(phoneNumber);
    } finally {
      _$_ContactListModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setContactStatus(String phoneNumber, String status) {
    final _$actionInfo = _$_ContactListModelActionController.startAction(
        name: '_ContactListModel.setContactStatus');
    try {
      return super.setContactStatus(phoneNumber, status);
    } finally {
      _$_ContactListModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setContactProfilePicture(
      String phoneNumber, String profilePictureBase64) {
    final _$actionInfo = _$_ContactListModelActionController.startAction(
        name: '_ContactListModel.setContactProfilePicture');
    try {
      return super.setContactProfilePicture(phoneNumber, profilePictureBase64);
    } finally {
      _$_ContactListModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
contacts: ${contacts}
    ''';
  }
}
