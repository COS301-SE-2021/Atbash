// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'BlockedContactsPageModel.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$BlockedContactsPageModel on _BlockedContactsPageModel, Store {
  Computed<ObservableList<BlockedNumber>>? _$filteredNumbersComputed;

  @override
  ObservableList<BlockedNumber> get filteredNumbers =>
      (_$filteredNumbersComputed ??= Computed<ObservableList<BlockedNumber>>(
              () => super.filteredNumbers,
              name: '_BlockedContactsPageModel.filteredNumbers'))
          .value;

  final _$blockedNumbersAtom =
      Atom(name: '_BlockedContactsPageModel.blockedNumbers');

  @override
  ObservableList<BlockedNumber> get blockedNumbers {
    _$blockedNumbersAtom.reportRead();
    return super.blockedNumbers;
  }

  @override
  set blockedNumbers(ObservableList<BlockedNumber> value) {
    _$blockedNumbersAtom.reportWrite(value, super.blockedNumbers, () {
      super.blockedNumbers = value;
    });
  }

  final _$filterAtom = Atom(name: '_BlockedContactsPageModel.filter');

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
filter: ${filter},
filteredNumbers: ${filteredNumbers}
    ''';
  }
}
