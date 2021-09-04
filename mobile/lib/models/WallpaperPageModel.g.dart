// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'WallpaperPageModel.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$WallpaperPageModel on _WallpaperPageModel, Store {
  final _$wallpaperImageAtom = Atom(name: '_WallpaperPageModel.wallpaperImage');

  @override
  String? get wallpaperImage {
    _$wallpaperImageAtom.reportRead();
    return super.wallpaperImage;
  }

  @override
  set wallpaperImage(String? value) {
    _$wallpaperImageAtom.reportWrite(value, super.wallpaperImage, () {
      super.wallpaperImage = value;
    });
  }

  @override
  String toString() {
    return '''
wallpaperImage: ${wallpaperImage}
    ''';
  }
}
