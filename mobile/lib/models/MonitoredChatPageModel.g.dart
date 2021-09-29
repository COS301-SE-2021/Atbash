// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MonitoredChatPageModel.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$MonitoredChatPageModel on _MonitoredChatPageModel, Store {
  final _$childNameAtom = Atom(name: '_MonitoredChatPageModel.childName');

  @override
  String get childName {
    _$childNameAtom.reportRead();
    return super.childName;
  }

  @override
  set childName(String value) {
    _$childNameAtom.reportWrite(value, super.childName, () {
      super.childName = value;
    });
  }

  final _$otherMemberNameAtom =
      Atom(name: '_MonitoredChatPageModel.otherMemberName');

  @override
  String get otherMemberName {
    _$otherMemberNameAtom.reportRead();
    return super.otherMemberName;
  }

  @override
  set otherMemberName(String value) {
    _$otherMemberNameAtom.reportWrite(value, super.otherMemberName, () {
      super.otherMemberName = value;
    });
  }

  final _$otherMemberNumberAtom =
      Atom(name: '_MonitoredChatPageModel.otherMemberNumber');

  @override
  String get otherMemberNumber {
    _$otherMemberNumberAtom.reportRead();
    return super.otherMemberNumber;
  }

  @override
  set otherMemberNumber(String value) {
    _$otherMemberNumberAtom.reportWrite(value, super.otherMemberNumber, () {
      super.otherMemberNumber = value;
    });
  }

  final _$messagesAtom = Atom(name: '_MonitoredChatPageModel.messages');

  @override
  List<ChildMessage> get messages {
    _$messagesAtom.reportRead();
    return super.messages;
  }

  @override
  set messages(List<ChildMessage> value) {
    _$messagesAtom.reportWrite(value, super.messages, () {
      super.messages = value;
    });
  }

  @override
  String toString() {
    return '''
childName: ${childName},
otherMemberName: ${otherMemberName},
otherMemberNumber: ${otherMemberNumber},
messages: ${messages}
    ''';
  }
}
