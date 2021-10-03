// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ProfanityPackageManagerPageModel.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ProfanityPackageManagerPageModel
    on _ProfanityPackageManagerPageModel, Store {
  final _$profanityWordsAtom =
      Atom(name: '_ProfanityPackageManagerPageModel.profanityWords');

  @override
  ObservableList<ProfanityWord> get profanityWords {
    _$profanityWordsAtom.reportRead();
    return super.profanityWords;
  }

  @override
  set profanityWords(ObservableList<ProfanityWord> value) {
    _$profanityWordsAtom.reportWrite(value, super.profanityWords, () {
      super.profanityWords = value;
    });
  }

  final _$storedProfanityWordsAtom =
      Atom(name: '_ProfanityPackageManagerPageModel.storedProfanityWords');

  @override
  ObservableList<StoredProfanityWord> get storedProfanityWords {
    _$storedProfanityWordsAtom.reportRead();
    return super.storedProfanityWords;
  }

  @override
  set storedProfanityWords(ObservableList<StoredProfanityWord> value) {
    _$storedProfanityWordsAtom.reportWrite(value, super.storedProfanityWords,
        () {
      super.storedProfanityWords = value;
    });
  }

  final _$packageCountsGeneralAtom =
      Atom(name: '_ProfanityPackageManagerPageModel.packageCountsGeneral');

  @override
  ObservableList<Tuple<int, String>> get packageCountsGeneral {
    _$packageCountsGeneralAtom.reportRead();
    return super.packageCountsGeneral;
  }

  @override
  set packageCountsGeneral(ObservableList<Tuple<int, String>> value) {
    _$packageCountsGeneralAtom.reportWrite(value, super.packageCountsGeneral,
        () {
      super.packageCountsGeneral = value;
    });
  }

  final _$packageCountsCreatedAtom =
      Atom(name: '_ProfanityPackageManagerPageModel.packageCountsCreated');

  @override
  ObservableList<Tuple<int, String>> get packageCountsCreated {
    _$packageCountsCreatedAtom.reportRead();
    return super.packageCountsCreated;
  }

  @override
  set packageCountsCreated(ObservableList<Tuple<int, String>> value) {
    _$packageCountsCreatedAtom.reportWrite(value, super.packageCountsCreated,
        () {
      super.packageCountsCreated = value;
    });
  }

  @override
  String toString() {
    return '''
profanityWords: ${profanityWords},
storedProfanityWords: ${storedProfanityWords},
packageCountsGeneral: ${packageCountsGeneral},
packageCountsCreated: ${packageCountsCreated}
    ''';
  }
}
