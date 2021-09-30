// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ChatLogPageModel.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ChatLogPageModel on _ChatLogPageModel, Store {
  Computed<List<ChildChat>>? _$sortedChatsComputed;

  @override
  List<ChildChat> get sortedChats => (_$sortedChatsComputed ??=
          Computed<List<ChildChat>>(() => super.sortedChats,
              name: '_ChatLogPageModel.sortedChats'))
      .value;

  final _$childPhoneNumberAtom =
      Atom(name: '_ChatLogPageModel.childPhoneNumber');

  @override
  String get childPhoneNumber {
    _$childPhoneNumberAtom.reportRead();
    return super.childPhoneNumber;
  }

  @override
  set childPhoneNumber(String value) {
    _$childPhoneNumberAtom.reportWrite(value, super.childPhoneNumber, () {
      super.childPhoneNumber = value;
    });
  }

  final _$childNameAtom = Atom(name: '_ChatLogPageModel.childName');

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

  final _$chatsAtom = Atom(name: '_ChatLogPageModel.chats');

  @override
  List<ChildChat> get chats {
    _$chatsAtom.reportRead();
    return super.chats;
  }

  @override
  set chats(List<ChildChat> value) {
    _$chatsAtom.reportWrite(value, super.chats, () {
      super.chats = value;
    });
  }

  @override
  String toString() {
    return '''
childPhoneNumber: ${childPhoneNumber},
childName: ${childName},
chats: ${chats},
sortedChats: ${sortedChats}
    ''';
  }
}
