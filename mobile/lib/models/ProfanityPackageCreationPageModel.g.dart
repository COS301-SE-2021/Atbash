// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ProfanityPackageCreationPageModel.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ProfanityPackageCreationPageModel
    on _ProfanityPackageCreationPageModel, Store {
  final _$storedProfanityWordsAtom =
      Atom(name: '_ProfanityPackageCreationPageModel.storedProfanityWords');

  @override
  ObservableList<String> get storedProfanityWords {
    _$storedProfanityWordsAtom.reportRead();
    return super.storedProfanityWords;
  }

  @override
  set storedProfanityWords(ObservableList<String> value) {
    _$storedProfanityWordsAtom.reportWrite(value, super.storedProfanityWords,
        () {
      super.storedProfanityWords = value;
    });
  }

  @override
  String toString() {
    return '''
storedProfanityWords: ${storedProfanityWords}
    ''';
  }
}
