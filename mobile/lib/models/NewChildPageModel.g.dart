// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'NewChildPageModel.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$NewChildPageModel on _NewChildPageModel, Store {
  Computed<ObservableList<Contact>>? _$filteredContactsComputed;

  @override
  ObservableList<Contact> get filteredContacts =>
      (_$filteredContactsComputed ??= Computed<ObservableList<Contact>>(
              () => super.filteredContacts,
              name: '_NewChildPageModel.filteredContacts'))
          .value;

  final _$contactsAtom = Atom(name: '_NewChildPageModel.contacts');

  @override
  List<Contact> get contacts {
    _$contactsAtom.reportRead();
    return super.contacts;
  }

  @override
  set contacts(List<Contact> value) {
    _$contactsAtom.reportWrite(value, super.contacts, () {
      super.contacts = value;
    });
  }

  final _$childrenAtom = Atom(name: '_NewChildPageModel.children');

  @override
  List<Child> get children {
    _$childrenAtom.reportRead();
    return super.children;
  }

  @override
  set children(List<Child> value) {
    _$childrenAtom.reportWrite(value, super.children, () {
      super.children = value;
    });
  }

  final _$filterAtom = Atom(name: '_NewChildPageModel.filter');

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

  @override
  String toString() {
    return '''
contacts: ${contacts},
children: ${children},
filter: ${filter},
filteredContacts: ${filteredContacts}
    ''';
  }
}
