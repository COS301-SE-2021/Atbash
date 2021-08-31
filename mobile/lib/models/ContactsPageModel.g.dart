// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ContactsPageModel.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ContactsPageModel on _ContactsPageModel, Store {
  final _$contactsAtom = Atom(name: '_ContactsPageModel.contacts');

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

  final _$_ContactsPageModelActionController =
      ActionController(name: '_ContactsPageModel');

  @override
  void addContact(Contact contact) {
    final _$actionInfo = _$_ContactsPageModelActionController.startAction(
        name: '_ContactsPageModel.addContact');
    try {
      return super.addContact(contact);
    } finally {
      _$_ContactsPageModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeContact(String phoneNumber) {
    final _$actionInfo = _$_ContactsPageModelActionController.startAction(
        name: '_ContactsPageModel.removeContact');
    try {
      return super.removeContact(phoneNumber);
    } finally {
      _$_ContactsPageModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  void replaceContacts(Iterable<Contact> contacts) {
    final _$actionInfo = _$_ContactsPageModelActionController.startAction(
        name: '_ContactsPageModel.replaceContacts');
    try {
      return super.replaceContacts(contacts);
    } finally {
      _$_ContactsPageModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
contacts: ${contacts}
    ''';
  }
}
