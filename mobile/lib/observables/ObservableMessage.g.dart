// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ObservableMessage.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ObservableMessage on _ObservableMessage, Store {
  final _$contentsAtom = Atom(name: '_ObservableMessage.contents');

  @override
  String get contents {
    _$contentsAtom.reportRead();
    return super.contents;
  }

  @override
  set contents(String value) {
    _$contentsAtom.reportWrite(value, super.contents, () {
      super.contents = value;
    });
  }

  final _$readReceiptAtom = Atom(name: '_ObservableMessage.readReceipt');

  @override
  ReadReceipt get readReceipt {
    _$readReceiptAtom.reportRead();
    return super.readReceipt;
  }

  @override
  set readReceipt(ReadReceipt value) {
    _$readReceiptAtom.reportWrite(value, super.readReceipt, () {
      super.readReceipt = value;
    });
  }

  final _$deletedAtom = Atom(name: '_ObservableMessage.deleted');

  @override
  bool get deleted {
    _$deletedAtom.reportRead();
    return super.deleted;
  }

  @override
  set deleted(bool value) {
    _$deletedAtom.reportWrite(value, super.deleted, () {
      super.deleted = value;
    });
  }

  final _$likedAtom = Atom(name: '_ObservableMessage.liked');

  @override
  bool get liked {
    _$likedAtom.reportRead();
    return super.liked;
  }

  @override
  set liked(bool value) {
    _$likedAtom.reportWrite(value, super.liked, () {
      super.liked = value;
    });
  }

  final _$tagsAtom = Atom(name: '_ObservableMessage.tags');

  @override
  ObservableList<ObservableTag> get tags {
    _$tagsAtom.reportRead();
    return super.tags;
  }

  @override
  set tags(ObservableList<ObservableTag> value) {
    _$tagsAtom.reportWrite(value, super.tags, () {
      super.tags = value;
    });
  }

  @override
  String toString() {
    return '''
contents: ${contents},
readReceipt: ${readReceipt},
deleted: ${deleted},
liked: ${liked},
tags: ${tags}
    ''';
  }
}
