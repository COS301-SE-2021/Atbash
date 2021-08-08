// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ContactsModel.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ContactsModel on ContactsModelBase, Store {
  Computed<ObservableList<Contact>>? _$chatContactsComputed;

  @override
  ObservableList<Contact> get chatContacts => (_$chatContactsComputed ??=
          Computed<ObservableList<Contact>>(() => super.chatContacts,
              name: 'ContactsModelBase.chatContacts'))
      .value;
  Computed<ObservableList<Contact>>? _$savedContactsComputed;

  @override
  ObservableList<Contact> get savedContacts => (_$savedContactsComputed ??=
          Computed<ObservableList<Contact>>(() => super.savedContacts,
              name: 'ContactsModelBase.savedContacts'))
      .value;
  Computed<ObservableList<Contact>>? _$filteredChatContactsComputed;

  @override
  ObservableList<Contact> get filteredChatContacts =>
      (_$filteredChatContactsComputed ??= Computed<ObservableList<Contact>>(
              () => super.filteredChatContacts,
              name: 'ContactsModelBase.filteredChatContacts'))
          .value;
  Computed<ObservableList<Contact>>? _$filteredSavedContactsComputed;

  @override
  ObservableList<Contact> get filteredSavedContacts =>
      (_$filteredSavedContactsComputed ??= Computed<ObservableList<Contact>>(
              () => super.filteredSavedContacts,
              name: 'ContactsModelBase.filteredSavedContacts'))
          .value;

  final _$contactsAtom = Atom(name: 'ContactsModelBase.contacts');

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

  final _$filterAtom = Atom(name: 'ContactsModelBase.filter');

  @override
  String get filter {
    _$filterAtom.reportRead();
    return super.filter;
  }

  @override
  set filter(String value) {
    _$filterAtom.reportWrite(value, super.filter, () {
      super.filter = value;
    });
  }

  final _$addContactAsyncAction = AsyncAction('ContactsModelBase.addContact');

  @override
  Future<void> addContact(
      String phoneNumber, String displayName, bool hasChat, bool save) {
    return _$addContactAsyncAction
        .run(() => super.addContact(phoneNumber, displayName, hasChat, save));
  }

  final _$initialiseAsyncAction = AsyncAction('ContactsModelBase.initialise');

  @override
  Future<void> initialise() {
    return _$initialiseAsyncAction.run(() => super.initialise());
  }

  final _$ContactsModelBaseActionController =
      ActionController(name: 'ContactsModelBase');

  @override
  void startChatWithContact(String phoneNumber) {
    final _$actionInfo = _$ContactsModelBaseActionController.startAction(
        name: 'ContactsModelBase.startChatWithContact');
    try {
      return super.startChatWithContact(phoneNumber);
    } finally {
      _$ContactsModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setContactProfileImage(String phoneNumber, String base64Image) {
    final _$actionInfo = _$ContactsModelBaseActionController.startAction(
        name: 'ContactsModelBase.setContactProfileImage');
    try {
      return super.setContactProfileImage(phoneNumber, base64Image);
    } finally {
      _$ContactsModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setContactStatus(String phoneNumber, String status) {
    final _$actionInfo = _$ContactsModelBaseActionController.startAction(
        name: 'ContactsModelBase.setContactStatus');
    try {
      return super.setContactStatus(phoneNumber, status);
    } finally {
      _$ContactsModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void deleteChatsWithContacts(List<String> phoneNumbers) {
    final _$actionInfo = _$ContactsModelBaseActionController.startAction(
        name: 'ContactsModelBase.deleteChatsWithContacts');
    try {
      return super.deleteChatsWithContacts(phoneNumbers);
    } finally {
      _$ContactsModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void deleteContacts(List<String> phoneNumbers) {
    final _$actionInfo = _$ContactsModelBaseActionController.startAction(
        name: 'ContactsModelBase.deleteContacts');
    try {
      return super.deleteContacts(phoneNumbers);
    } finally {
      _$ContactsModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
contacts: ${contacts},
filter: ${filter},
chatContacts: ${chatContacts},
savedContacts: ${savedContacts},
filteredChatContacts: ${filteredChatContacts},
filteredSavedContacts: ${filteredSavedContacts}
    ''';
  }
}
