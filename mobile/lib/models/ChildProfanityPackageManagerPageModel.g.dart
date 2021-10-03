// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ChildProfanityPackageManagerPageModel.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ChildProfanityPackageManagerPageModel
    on _ChildProfanityPackageManagerPageModel, Store {
  final _$storedProfanityWordsAtom =
      Atom(name: '_ChildProfanityPackageManagerPageModel.storedProfanityWords');

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
      Atom(name: '_ChildProfanityPackageManagerPageModel.packageCounts');

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
storedProfanityWords: ${storedProfanityWords},
packageCounts: ${packageCounts}
    ''';
  }
}
