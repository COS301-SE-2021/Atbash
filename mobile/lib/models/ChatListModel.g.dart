// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ChatListModel.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ChatListModel on _ChatListModel, Store {
  final _$chatsAtom = Atom(name: '_ChatListModel.chats');

  @override
  ObservableList<ObservableChat> get chats {
    _$chatsAtom.reportRead();
    return super.chats;
  }

  @override
  set chats(ObservableList<ObservableChat> value) {
    _$chatsAtom.reportWrite(value, super.chats, () {
      super.chats = value;
    });
  }

  final _$_ChatListModelActionController =
      ActionController(name: '_ChatListModel');

  @override
  void startChatWithContact(ObservableContact contact, ChatType chatType) {
    final _$actionInfo = _$_ChatListModelActionController.startAction(
        name: '_ChatListModel.startChatWithContact');
    try {
      return super.startChatWithContact(contact, chatType);
    } finally {
      _$_ChatListModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  void startChatWithPhoneNumber(String phoneNumber, ChatType chatType) {
    final _$actionInfo = _$_ChatListModelActionController.startAction(
        name: '_ChatListModel.startChatWithPhoneNumber');
    try {
      return super.startChatWithPhoneNumber(phoneNumber, chatType);
    } finally {
      _$_ChatListModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  void deleteChat(String id) {
    final _$actionInfo = _$_ChatListModelActionController.startAction(
        name: '_ChatListModel.deleteChat');
    try {
      return super.deleteChat(id);
    } finally {
      _$_ChatListModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setChatContact(String chatId, ObservableContact contact) {
    final _$actionInfo = _$_ChatListModelActionController.startAction(
        name: '_ChatListModel.setChatContact');
    try {
      return super.setChatContact(chatId, contact);
    } finally {
      _$_ChatListModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setChatMostRecentMessage(String chatId, ObservableMessage message) {
    final _$actionInfo = _$_ChatListModelActionController.startAction(
        name: '_ChatListModel.setChatMostRecentMessage');
    try {
      return super.setChatMostRecentMessage(chatId, message);
    } finally {
      _$_ChatListModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
chats: ${chats}
    ''';
  }
}
