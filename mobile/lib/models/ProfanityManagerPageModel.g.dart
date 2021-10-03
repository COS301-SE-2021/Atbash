// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ProfanityManagerPageModel.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ProfanityManagerPageModel on _ProfanityManagerPageModel, Store {
  Computed<ObservableList<ProfanityWord>>? _$filteredProfanityWordsComputed;

  @override
  ObservableList<ProfanityWord> get filteredProfanityWords =>
      (_$filteredProfanityWordsComputed ??=
              Computed<ObservableList<ProfanityWord>>(
                  () => super.filteredProfanityWords,
                  name: '_ProfanityManagerPageModel.filteredProfanityWords'))
          .value;
  Computed<ObservableList<Tuple<int, String>>>? _$filteredPackageCountsComputed;

  @override
  ObservableList<Tuple<int, String>> get filteredPackageCounts =>
      (_$filteredPackageCountsComputed ??=
              Computed<ObservableList<Tuple<int, String>>>(
                  () => super.filteredPackageCounts,
                  name: '_ProfanityManagerPageModel.filteredPackageCounts'))
          .value;

  final _$profanityWordsAtom =
      Atom(name: '_ProfanityManagerPageModel.profanityWords');

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

  final _$packageCountsAtom =
      Atom(name: '_ProfanityManagerPageModel.packageCounts');

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

  final _$filterAtom = Atom(name: '_ProfanityManagerPageModel.filter');

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
