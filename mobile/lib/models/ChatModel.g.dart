// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ChatModel.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ChatModel on ChatModelBase, Store {
  final _$contactPhoneNumberAtom =
      Atom(name: 'ChatModelBase.contactPhoneNumber');

  @override
  String get contactPhoneNumber {
    _$contactPhoneNumberAtom.reportRead();
    return super.contactPhoneNumber;
  }

  @override
  set contactPhoneNumber(String value) {
    _$contactPhoneNumberAtom.reportWrite(value, super.contactPhoneNumber, () {
      super.contactPhoneNumber = value;
    });
  }

  final _$chatMessagesAtom = Atom(name: 'ChatModelBase.chatMessages');

  @override
  ObservableList<Message> get chatMessages {
    _$chatMessagesAtom.reportRead();
    return super.chatMessages;
  }

  @override
  set chatMessages(ObservableList<Message> value) {
    _$chatMessagesAtom.reportWrite(value, super.chatMessages, () {
      super.chatMessages = value;
    });
  }

  final _$pageAtom = Atom(name: 'ChatModelBase.page');

  @override
  int get page {
    _$pageAtom.reportRead();
    return super.page;
  }

  @override
  set page(int value) {
    _$pageAtom.reportWrite(value, super.page, () {
      super.page = value;
    });
  }

  final _$initContactAsyncAction = AsyncAction('ChatModelBase.initContact');

  @override
  Future<void> initContact(String contactPhoneNumber) {
    return _$initContactAsyncAction
        .run(() => super.initContact(contactPhoneNumber));
  }

  final _$fetchNextMessagesPageAsyncAction =
      AsyncAction('ChatModelBase.fetchNextMessagesPage');

  @override
  Future<void> fetchNextMessagesPage() {
    return _$fetchNextMessagesPageAsyncAction
        .run(() => super.fetchNextMessagesPage());
  }

  final _$ChatModelBaseActionController =
      ActionController(name: 'ChatModelBase');

  @override
  void markMessageDelivered(String messageId) {
    final _$actionInfo = _$ChatModelBaseActionController.startAction(
        name: 'ChatModelBase.markMessageDelivered');
    try {
      return super.markMessageDelivered(messageId);
    } finally {
      _$ChatModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addMessage(Message m) {
    final _$actionInfo = _$ChatModelBaseActionController.startAction(
        name: 'ChatModelBase.addMessage');
    try {
      return super.addMessage(m);
    } finally {
      _$ChatModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeMessages(List<String> ids) {
    final _$actionInfo = _$ChatModelBaseActionController.startAction(
        name: 'ChatModelBase.removeMessages');
    try {
      return super.removeMessages(ids);
    } finally {
      _$ChatModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void deleteMessages(List<String> ids) {
    final _$actionInfo = _$ChatModelBaseActionController.startAction(
        name: 'ChatModelBase.deleteMessages');
    try {
      return super.deleteMessages(ids);
    } finally {
      _$ChatModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void markMessagesDeleted(List<String> ids) {
    final _$actionInfo = _$ChatModelBaseActionController.startAction(
        name: 'ChatModelBase.markMessagesDeleted');
    try {
      return super.markMessagesDeleted(ids);
    } finally {
      _$ChatModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
contactPhoneNumber: ${contactPhoneNumber},
chatMessages: ${chatMessages},
page: ${page}
    ''';
  }
}
