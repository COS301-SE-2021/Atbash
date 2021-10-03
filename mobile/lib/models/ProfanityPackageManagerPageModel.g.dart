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

  final _$packageCountsAtom =
      Atom(name: '_ProfanityPackageManagerPageModel.packageCounts');

  @override
  ObservableList<Tuple<int, String>> get packageCounts {
    _$packageCountsAtom.reportRead();
    return super.packageCounts;
  }

  @override
  set packageCounts(ObservableList<Tuple<int, String>> value) {
    _$packageCountsAtom.reportWrite(value, super.packageCounts, () {
      super.packageCounts = value;
    });
  }

  @override
  String toString() {
    return '''
profanityWords: ${profanityWords},
storedProfanityWords: ${storedProfanityWords},
packageCounts: ${packageCounts}
    ''';
  }
}
