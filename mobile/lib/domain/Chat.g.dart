// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Chat.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$Chat on _Chat, Store {
  final _$contactAtom = Atom(name: '_Chat.contact');

  @override
  Contact? get contact {
    _$contactAtom.reportRead();
    return super.contact;
  }

  @override
  set contact(Contact? value) {
    _$contactAtom.reportWrite(value, super.contact, () {
      super.contact = value;
    });
  }

  final _$mostRecentMessageAtom = Atom(name: '_Chat.mostRecentMessage');

  @override
  Message? get mostRecentMessage {
    _$mostRecentMessageAtom.reportRead();
    return super.mostRecentMessage;
  }

  @override
  set mostRecentMessage(Message? value) {
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
