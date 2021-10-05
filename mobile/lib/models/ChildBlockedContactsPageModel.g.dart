// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ChildBlockedContactsPageModel.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ChildBlockedContactsPageModel on _ChildBlockedContactsPageModel, Store {
  Computed<ObservableList<ChildBlockedNumber>>? _$filteredNumbersComputed;

  @override
  ObservableList<ChildBlockedNumber> get filteredNumbers =>
      (_$filteredNumbersComputed ??=
              Computed<ObservableList<ChildBlockedNumber>>(
                  () => super.filteredNumbers,
                  name: '_ChildBlockedContactsPageModel.filteredNumbers'))
          .value;

  final _$blockedNumbersAtom =
      Atom(name: '_ChildBlockedContactsPageModel.blockedNumbers');

  @override
  ObservableList<ChildBlockedNumber> get blockedNumbers {
    _$blockedNumbersAtom.reportRead();
    return super.blockedNumbers;
  }

  @override
  set blockedNumbers(ObservableList<ChildBlockedNumber> value) {
    _$blockedNumbersAtom.reportWrite(value, super.blockedNumbers, () {
      super.blockedNumbers = value;
    });
  }

  final _$contactsAtom = Atom(name: '_ChildBlockedContactsPageModel.contacts');

  @override
  ObservableList<ChildContact> get contacts {
    _$contactsAtom.reportRead();
    return super.contacts;
  }

  @override
  set contacts(ObservableList<ChildContact> value) {
    _$contactsAtom.reportWrite(value, super.contacts, () {
      super.contacts = value;
    });
  }

  final _$childNameAtom =
      Atom(name: '_ChildBlockedContactsPageModel.childName');

  @override
  String get childName {
    _$childNameAtom.reportRead();
    return super.childName;
  }

  @override
  set childName(String value) {
    _$childNameAtom.reportWrite(value, super.childName, () {
      super.childName = value;
    });
  }

  final _$filterAtom = Atom(name: '_ChildBlockedContactsPageModel.filter');

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
blockedNumbers: ${blockedNumbers},
contacts: ${contacts},
childName: ${childName},
filter: ${filter},
filteredNumbers: ${filteredNumbers}
    ''';
  }
}
