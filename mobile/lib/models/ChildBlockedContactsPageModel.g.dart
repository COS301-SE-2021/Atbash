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

  final _$chatsAtom = Atom(name: '_ChildBlockedContactsPageModel.chats');

  @override
  ObservableList<ChildChat> get chats {
    _$chatsAtom.reportRead();
    return super.chats;
  }

  @override
  set chats(ObservableList<ChildChat> value) {
    _$chatsAtom.reportWrite(value, super.chats, () {
      super.chats = value;
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
chats: ${chats},
filter: ${filter},
filteredNumbers: ${filteredNumbers}
    ''';
  }
}
