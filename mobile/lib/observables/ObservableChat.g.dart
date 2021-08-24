// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ObservableChat.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ObservableChat on _ObservableChat, Store {
  final _$contactAtom = Atom(name: '_ObservableChat.contact');

  @override
  ObservableContact? get contact {
    _$contactAtom.reportRead();
    return super.contact;
  }

  @override
  set contact(ObservableContact? value) {
    _$contactAtom.reportWrite(value, super.contact, () {
      super.contact = value;
    });
  }

  final _$mostRecentMessageAtom =
      Atom(name: '_ObservableChat.mostRecentMessage');

  @override
  ObservableMessage? get mostRecentMessage {
    _$mostRecentMessageAtom.reportRead();
    return super.mostRecentMessage;
  }

  @override
  set mostRecentMessage(ObservableMessage? value) {
    _$mostRecentMessageAtom.reportWrite(value, super.mostRecentMessage, () {
      super.mostRecentMessage = value;
    });
  }

  @override
  String toString() {
    return '''
contact: ${contact},
mostRecentMessage: ${mostRecentMessage}
    ''';
  }
}
