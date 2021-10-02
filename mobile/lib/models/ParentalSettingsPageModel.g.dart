// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ParentalSettingsPageModel.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ParentalSettingsPageModel on _ParentalSettingsPageModel, Store {
  final _$childrenAtom = Atom(name: '_ParentalSettingsPageModel.children');

  @override
  ObservableList<Tuple<Child, bool>> get children {
    _$childrenAtom.reportRead();
    return super.children;
  }

  @override
  set children(ObservableList<Tuple<Child, bool>> value) {
    _$childrenAtom.reportWrite(value, super.children, () {
      super.children = value;
    });
  }

  final _$indexAtom = Atom(name: '_ParentalSettingsPageModel.index');

  @override
  int get index {
    _$indexAtom.reportRead();
    return super.index;
  }

  @override
  set index(int value) {
    _$indexAtom.reportWrite(value, super.index, () {
      super.index = value;
    });
  }

  final _$parentNameAtom = Atom(name: '_ParentalSettingsPageModel.parentName');

  @override
  String get parentName {
    _$parentNameAtom.reportRead();
    return super.parentName;
  }

  @override
  set parentName(String value) {
    _$parentNameAtom.reportWrite(value, super.parentName, () {
      super.parentName = value;
    });
  }

  @override
  String toString() {
    return '''
children: ${children},
index: ${index},
parentName: ${parentName}
    ''';
  }
}
