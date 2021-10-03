// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ChildProfanityManagerPageModel.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ChildProfanityManagerPageModel
    on _ChildProfanityManagerPageModel, Store {
  Computed<ObservableList<ChildProfanityWord>>?
      _$filteredProfanityWordsComputed;

  @override
  ObservableList<ChildProfanityWord> get filteredProfanityWords =>
      (_$filteredProfanityWordsComputed ??=
              Computed<ObservableList<ChildProfanityWord>>(
                  () => super.filteredProfanityWords,
                  name:
                      '_ChildProfanityManagerPageModel.filteredProfanityWords'))
          .value;
  Computed<ObservableList<Tuple<int, String>>>? _$filteredPackageCountsComputed;

  @override
  ObservableList<Tuple<int, String>> get filteredPackageCounts =>
      (_$filteredPackageCountsComputed ??=
              Computed<ObservableList<Tuple<int, String>>>(
                  () => super.filteredPackageCounts,
                  name:
                      '_ChildProfanityManagerPageModel.filteredPackageCounts'))
          .value;

  final _$profanityWordsAtom =
      Atom(name: '_ChildProfanityManagerPageModel.profanityWords');

  @override
  ObservableList<ChildProfanityWord> get profanityWords {
    _$profanityWordsAtom.reportRead();
    return super.profanityWords;
  }

  @override
  set profanityWords(ObservableList<ChildProfanityWord> value) {
    _$profanityWordsAtom.reportWrite(value, super.profanityWords, () {
      super.profanityWords = value;
    });
  }

  final _$packageCountsAtom =
      Atom(name: '_ChildProfanityManagerPageModel.packageCounts');

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

  final _$filterAtom = Atom(name: '_ChildProfanityManagerPageModel.filter');

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
profanityWords: ${profanityWords},
packageCounts: ${packageCounts},
filter: ${filter},
filteredProfanityWords: ${filteredProfanityWords},
filteredPackageCounts: ${filteredPackageCounts}
    ''';
  }
}
