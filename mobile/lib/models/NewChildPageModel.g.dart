// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'NewChildPageModel.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$NewChildPageModel on _NewChildPageModel, Store {
  final _$contactsAtom = Atom(name: '_NewChildPageModel.contacts');

  @override
  List<Contact> get contacts {
    _$contactsAtom.reportRead();
    return super.contacts;
  }

  @override
  set contacts(List<Contact> value) {
    _$contactsAtom.reportWrite(value, super.contacts, () {
      super.contacts = value;
    });
  }

  @override
  String toString() {
    return '''
contacts: ${contacts}
    ''';
  }
}
