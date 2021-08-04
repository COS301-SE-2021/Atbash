// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ContactsModel.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ContactsModel on ContactsModelBase, Store {
  Computed<ObservableList<Contact>>? _$savedContactsComputed;

  @override
  ObservableList<Contact> get savedContacts => (_$savedContactsComputed ??=
          Computed<ObservableList<Contact>>(() => super.savedContacts,
              name: 'ContactsModelBase.savedContacts'))
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

  final _$initialiseAsyncAction = AsyncAction('ContactsModelBase.initialise');

  @override
  Future<void> initialise() {
    return _$initialiseAsyncAction.run(() => super.initialise());
  }

  final _$ContactsModelBaseActionController =
      ActionController(name: 'ContactsModelBase');

  @override
  void addContact(Contact c) {
    final _$actionInfo = _$ContactsModelBaseActionController.startAction(
        name: 'ContactsModelBase.addContact');
    try {
      return super.addContact(c);
    } finally {
      _$ContactsModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
contacts: ${contacts},
savedContacts: ${savedContacts}
    ''';
  }
}
