// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MessagesModel.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$MessagesModel on _MessagesModel, Store {
  final _$messagesAtom = Atom(name: '_MessagesModel.messages');

  @override
  ObservableList<ObservableMessage> get messages {
    _$messagesAtom.reportRead();
    return super.messages;
  }

  @override
  set messages(ObservableList<ObservableMessage> value) {
    _$messagesAtom.reportWrite(value, super.messages, () {
      super.messages = value;
    });
  }

  final _$openChatAtom = Atom(name: '_MessagesModel.openChat');

  @override
  ObservableChat? get openChat {
    _$openChatAtom.reportRead();
    return super.openChat;
  }

  @override
  set openChat(ObservableChat? value) {
    _$openChatAtom.reportWrite(value, super.openChat, () {
      super.openChat = value;
    });
  }

  final _$_MessagesModelActionController =
      ActionController(name: '_MessagesModel');

  @override
  void enterChat(ObservableChat chat) {
    final _$actionInfo = _$_MessagesModelActionController.startAction(
        name: '_MessagesModel.enterChat');
    try {
      return super.enterChat(chat);
    } finally {
      _$_MessagesModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  void sendMessage(String userPhoneNumber, String contents) {
    final _$actionInfo = _$_MessagesModelActionController.startAction(
        name: '_MessagesModel.sendMessage');
    try {
      return super.sendMessage(userPhoneNumber, contents);
    } finally {
      _$_MessagesModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  void deleteMessagesLocally(String messageId) {
    final _$actionInfo = _$_MessagesModelActionController.startAction(
        name: '_MessagesModel.deleteMessagesLocally');
    try {
      return super.deleteMessagesLocally(messageId);
    } finally {
      _$_MessagesModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  void sendReadReceipt(String messageId, ReadReceipt readReceipt) {
    final _$actionInfo = _$_MessagesModelActionController.startAction(
        name: '_MessagesModel.sendReadReceipt');
    try {
      return super.sendReadReceipt(messageId, readReceipt);
    } finally {
      _$_MessagesModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  void sendDeleteMessageRequest(String messageId) {
    final _$actionInfo = _$_MessagesModelActionController.startAction(
        name: '_MessagesModel.sendDeleteMessageRequest');
    try {
      return super.sendDeleteMessageRequest(messageId);
    } finally {
      _$_MessagesModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  void likeMessage(String messageId) {
    final _$actionInfo = _$_MessagesModelActionController.startAction(
        name: '_MessagesModel.likeMessage');
    try {
      return super.likeMessage(messageId);
    } finally {
      _$_MessagesModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
messages: ${messages},
openChat: ${openChat}
    ''';
  }
}
