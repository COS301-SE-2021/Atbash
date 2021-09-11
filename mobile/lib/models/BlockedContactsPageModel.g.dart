// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'BlockedContactsPageModel.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$BlockedContactsPageModel on _BlockedContactsPageModel, Store {
  final _$blockedNumbersAtom =
      Atom(name: '_BlockedContactsPageModel.blockedNumbers');

  @override
  List<BlockedNumber> get blockedNumbers {
    _$blockedNumbersAtom.reportRead();
    return super.blockedNumbers;
  }

  @override
  set blockedNumbers(List<BlockedNumber> value) {
    _$blockedNumbersAtom.reportWrite(value, super.blockedNumbers, () {
      super.blockedNumbers = value;
    });
  }

  @override
  String toString() {
    return '''
blockedNumbers: ${blockedNumbers}
    ''';
  }
}
